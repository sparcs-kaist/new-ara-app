# 기여하기

## How to deploy

### Fastlane 설정

공식 홈페이지를 참고하였습니다.
[Continuous Delivery using fastlane with Flutter](https://flutter.io/docs/deployment/fastlane-cd)

아래 명령어를 최초 1회 실행하여 bundler를 설치합니다.

```bash
gem install bundler
```

`/android`와 `/ios`폴더에서 아래 명령어를 최초 1회 실행합니다.

```bash
bundle install
```

### Credentials

- `android/fastlane/otlplus-fastlane.json` : Google Play 서비스 계정 JSON 파일
- `android/fastlane/upload-keystore.jks` : Android App Signing Key for Upload Google Play
- `android/key.properties` : 아래와 같이 Signing Key 정보를 입력합니다.

```env
storeFile=../fastlane/upload-keystore.jks
storePassword=********
keyPassword=********
keyAlias=upload
```

- `ios/fastlane/.env.default` : 아래와 같이 Apple ID 계정 정보를 입력합니다.

```env
FASTLANE_USER=****@****.***
FASTLANE_PASSWORD=********
FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD=****-****-****-****
```

- `ios/fastlane/Appfile` : 아래와 같이 Apple ID 계정 정보를 입력합니다.
```env
app_identifier("org.sparcs.new-ara-app") # The bundle identifier of your app
apple_id("****@****.***") # Your Apple Developer Portal username

itc_team_name("SPARCS") # App Store Connect Team Name
team_id("N5V8W52U3U") # Developer Portal Team ID
```

### 알파 버전 배포

- Android: Google Play 스토어 `비공개 테스트 - Alpha` 트랙으로 업로드
- iOS: TestFlight로 업로드

```bash
cd android && bundle exec fastlane alpha && cd ../ios && bundle exec fastlane alpha
```

배포 후 `pubspec.yaml`과 iOS Xcode 프로젝트 관련 파일들의 변경사항을 Discard 합니다.

### Release Note 작성

1. [Releases](https://github.com/sparcs-kaist/otl-app/releases)에 갑니다.
2. 이번 버전에서 변경된 사항을 Changes에 작성합니다.
3. `pubspec.yaml`의 버전을 하나 올리는 커밋을 추가합니다.

**버전을 하나 올린 후 `flutter build ios`를 반드시 실행해 주도록 합니다.**
