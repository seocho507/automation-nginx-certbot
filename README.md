# Nginx & Let's Encrypt Certbot 자동 설정 스크립트

이 스크립트는 Nginx와 Let's Encrypt의 Certbot을 사용하여 SSL 인증서를 자동으로 발급하고, 이를 Docker 환경에서 Nginx와 함께 실행합니다. 주기적으로 인증서를 갱신하여 HTTPS 서비스를 제공합니다.

## 스크립트 기능

1. **Docker Compose** 및 **Nginx** 설정 자동화.
2. 사용자가 입력한 도메인에 대해 **Let's Encrypt SSL 인증서**를 발급.
3. 인증서 갱신을 위한 **Certbot 자동 갱신** 설정.
4. **Docker** 및 **Certbot** 설치 및 실행 관리.

## 요구 사항

- **Ubuntu** 운영체제
- **Docker**와 **Docker Compose**가 설치되지 않은 경우, 스크립트가 자동으로 설치합니다.

## 사용 방법

### 1. 스크립트 다운로드 및 권한 설정

스크립트 파일을 다운로드한 후, 실행 권한을 부여합니다.

```bash
chmod +x setup-nginx-certbot.sh