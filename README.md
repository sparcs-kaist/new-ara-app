# SPARCS NewAra App

<p align=center>
  <a href="https://newara.sparcs.org">
    <img
      src="https://raw.githubusercontent.com/sparcs-kaist/new-ara-app/dev/assets/images/logo.svg"
      alt="Ara Logo"
      height="100"
    >
  </a>
</p>
<p align=center>
  <em>Mobile app for NewAra, KAIST's official community service</em>
</p>
<p align="center">
  <a href="#">
    <img
      src="https://img.shields.io/github/v/release/sparcs-kaist/new-ara-app?display_name=tag"
      alt="Release version"
    />
  </a>
  </a>
  <a href="#">
    <img
      src="https://img.shields.io/github/license/sparcs-kaist/new-ara-app"
      alt="License"
    />
  </a>
</p>

## How to Download
The SPARCS NewAra App is available for both Android and iOS. Follow the instructions below to download and install the app on your device.

### Android
1. Visit the Google Play Store on your Android device.
2. Search for "Ara for KAIST".
3. Tap "Install" to download and install the app.

[Play Store Link: Ara for KAIST](https://play.google.com/store/apps/details?id=org.sparcs.newara)

### iOS
1. Open the App Store on your iOS device.
Search for "Ara for KAIST".
2. Tap "Get" to download and install the app.

[App Store Link: Ara for KAIST](https://apps.apple.com/kr/app/ara-for-kaist/id6457209147)

## How to develop
### run

`FLUTTER_VERSION: "3.13"`, `JAVA_VERSION: "11"`


- `.env.development` : 프로젝트 루트 디렉토리에 `.env.developemnt` 파일을 생성하고 아래와 같이 정보를 입력합니다.
```env
NEW_ARA_DEFAULT_URL=https://newara.dev.sparcs.org
NEW_ARA_AUTHORITY=newara.dev.sparcs.org
SPARCS_SSO_DEFAULT_URL=https://sparcssso.kaist.ac.kr
```
<br>

- `.env.production` : 프로젝트 루트 디렉토리에 `.env.production` 파일을 생성하고 아래와 같이 정보를 입력합니다.
```env
NEW_ARA_DEFAULT_URL=https://newara.sparcs.org
NEW_ARA_AUTHORITY=newara.sparcs.org
SPARCS_SSO_DEFAULT_URL=https://sparcssso.kaist.ac.kr
```

<br>

#### Terminal

- `development`와 `production` 둘 중 하나를 선택해서 실행합니다.
- 지정하지 않을 시 `development`로 자동 실행됩니다.
ex) `flutter run --dart-define=ENV=development`
ex) `flutter run --dart-define=ENV=production`

#### VSCode

[VSCode에서 디버깅 방법](https://code.visualstudio.com/docs/editor/debugging)

- `launch.json`의 `configurations`에 아래 내용을 추가하면 `development`과 `production`을 전환하기 편합니다.
```
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "new-ara-app(Delevopment)",
            "request": "launch",
            "type": "dart",
            "args": [
                "--dart-define=ENV=development"
            ]
        },
        {
            "name": "new-ara-app(Production)",
            "request": "launch",
            "type": "dart",
            "args": [
                "--dart-define=ENV=production"
            ],
        },
    ]
}
```

##How to Deploy
- [CONTRIBUTING.md](https://github.com/sparcs-kaist/new-ara-app/blob/dev/CONTRIBUTING.md) 참조