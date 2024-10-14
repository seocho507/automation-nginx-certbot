#!/bin/bash

# 도메인 입력받기
echo "SSL 인증서 발급을 위한 도메인을 입력하세요 (예: example.com):"
read DOMAIN

# 필요한 디렉토리 및 파일 생성
mkdir -p ./nginx/conf.d
mkdir -p ./certbot/www

# docker-compose.yml 생성
cat > docker-compose.yml <<EOF
version: '3'

services:
  nginx:
    image: nginx:alpine
    container_name: nginx_server
    volumes:
      - ./nginx/conf.d:/etc/nginx/conf.d
      - /etc/letsencrypt:/etc/letsencrypt
      - ./certbot/www:/var/www/certbot
    ports:
      - "80:80"
      - "443:443"
    depends_on:
      - certbot
    restart: unless-stopped

  certbot:
    image: certbot/certbot
    container_name: certbot
    volumes:
      - /etc/letsencrypt:/etc/letsencrypt
      - ./certbot/www:/var/www/certbot
    entrypoint: "/bin/sh -c 'trap exit TERM; while :; do certbot renew --webroot -w /var/www/certbot; sleep 12h; done'"
    restart: unless-stopped
EOF

# nginx.conf 생성
cat > ./nginx/conf.d/default.conf <<EOF
server {
    listen 80;
    server_name $DOMAIN;

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    location / {
        return 301 https://\$host\$request_uri;
    }
}

server {
    listen 443 ssl;
    server_name $DOMAIN;

    ssl_certificate /etc/letsencrypt/live/$DOMAIN/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;

    location / {
        root /usr/share/nginx/html;
        index index.html;
    }
}
EOF

# Docker와 Certbot 설치
sudo apt update
sudo apt install -y docker.io docker-compose

# 초기 Certbot SSL 인증서 발급 (웹루트 방식)
echo "Certbot을 통해 SSL 인증서를 발급합니다..."
docker-compose run --rm certbot certonly --webroot -w /var/www/certbot -d $DOMAIN

# Nginx 재시작
echo "Nginx 서버를 재시작합니다..."
docker-compose up -d

# 완료 메시지
echo "SSL 인증서가 설정되고 Nginx가 실행되었습니다."
echo "https://$DOMAIN 에서 서비스를 확인하세요."