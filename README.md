# SPARCS NewAra App

<p align=center>
  <a href="https://newara.sparcs.org">
    <img
      src="https://raw.githubusercontent.com/sparcs-kaist/new-ara-app/dev/assets/images/logo.svg"
      alt="Ara Logo"
      height="150"
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
  <a href="#">
    <img
      src="https://img.shields.io/github/license/sparcs-kaist/new-ara-app"
      alt="License"
    />
  </a>
</p>

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

- `development`와 `production` 둘 중 하나를 선택해서 실행합니다.
ex) `flutter run --dart-define=ENV=development`
ex) `flutter run --dart-define=ENV=production`