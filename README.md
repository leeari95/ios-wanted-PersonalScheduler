[![Swift 5.7](https://img.shields.io/badge/swift-5.7-ED523F.svg?style=flat)](https://swift.org/download/) [![Xcode 14.1](https://img.shields.io/badge/Xcode-14.1-ED523F.svg?style=flat&color=blue)](https://swift.org/download/)

# PersonalScheduler

> `OAuth`를 통해 회원가입, 로그인, 로그아웃을 통해 유저를 식별하고, `Firebase`를 활용한 스케줄링 앱.

&nbsp;

## API Key 다운로드 및 프로젝트 설정

> [API KEY 다운로드 바로가기](https://drive.google.com/drive/folders/1m4ezW5HngcVKzC8QyCw0Y00bF2ei6djo?usp=sharing)

&nbsp;

![](https://i.imgur.com/Ah8ARFJ.png)

> 위 링크에서 파일 두개를 다운받고 위와 동일하게 파일들을 프로젝트 내에 경로를 추가해주세요.

&nbsp;

![](https://i.imgur.com/Ghmh4gD.png)

> 이후 프로젝트 Configuration 설정을 위와 동일하게 설정해주세요.

&nbsp;

## 목차

* [파일 디렉토리 구조](#-파일-디렉토리-구조)
* [기술 스택](#-기술-스택)
* [기능 및 UI](#-기능-및-ui)
* [설계 및 구현](#-설계-및-구현)
* [실행 화면](#-실행-화면)
* [기술적 도전](#-기술적-도전)
    * [Combine](#combine)
    * [Coordinator](#coordinator)
    * [Firebase-FireStore](#firebase-firestore)
* [Truoble Shooting](#-truoble-shooting)
    * [메모리 누수 디버깅](#메모리-누수-디버깅)
    * [네비게이션 바 버튼 커스텀하기](#네비게이션-바-버튼-커스텀하기)
* [고민했던 점](#-고민했던-점)
    * [API Secret Key 관리하기](#api-secret-key-관리하기)
    * [에러 처리](#에러-처리)
    * [UI/UX 설계하기](#uiux-설계하기)

## 🗂 파일 디렉토리 구조

```
  PersonalScheduler
 ├── Resources
 │   └── Assets.xcassets
 └── Sources
     ├── App
     ├── Common
     │   ├── Extensions
     │   │   └── UI
     │   └── Utility
     ├── Data
     │   ├── Network
     │   │   └── Protocol
     │   ├── Repositories
     │   └── Storages
     ├── Model
     └── Presentation
         ├── Auth
         │   ├── Coordinator
         │   ├── View
         │   ├── ViewController
         │   └── ViewModel
         ├── Schedule
         │   ├── Coordinator
         │   ├── View
         │   ├── ViewController
         │   └── ViewModel
         └── ScheduleList
             ├── Coordinator
             ├── View
             ├── ViewController
             └── ViewModel
```

&nbsp;

## 🛠 기술 스택

### 아키텍처

* MVVM
* Coordinator

&nbsp;

### 데이터 및 UI 이벤트 처리

* Combine

&nbsp;

## 📱 기능 및 UI

|기능/UI|설명|
|:-|:-|
|로그인, 로그아웃|OAuth를 이용해 인증 토큰을 요청하여, 로그인 및 로그아웃을 할 수 있습니다. 지원하는 소셜 로그인은 `Kakao`, `Apple`, `Facebook`이 있습니다.|
|스케줄 목록|사용자가 추가한 스케줄을 리스트 형태로 확인할 수 있습니다. 일정이 없다면 빈 화면 대신 일정을 추가해달라는 Label을 대신 띄웁니다. 좌측 상단 네비게이션 타이틀을 활용하여 `사용자가 원하는 날짜 스케줄을 확인`할 수도 있습니다. 또한, 현재 진행중인 스케줄인 경우 `연두색으로 하이라이트 표시` 됩니다.|
|스케줄 등록|목록 화면에서 우측 하단 `+`버튼을 통해 새로운 스케줄을 등록할 수 있습니다.|
|스케줄 수정|목록에 있는 스케줄을 터치하면 스케줄을 수정할 수 있는 화면으로 이동합니다.|

&nbsp;

## 💻 설계 및 구현

### MVVM + Coordinator 구조

![](https://i.imgur.com/qCDTjCz.png)

![](https://i.imgur.com/6JTpADt.png)

&nbsp;

### 역할 분배

|class/struct|역할|
|:-|:-|
|`AuthViewController`|로그인 및 회원가입을 진행할 수 있는 화면이다.|
|`ScheduleListViewController`|등록한 스케줄 일정을 확인할 수 있는 화면이다. 셀을 터치시 스케줄 수정 화면으로 진입하고, `+`버튼을 클릭 시 새 일정을 등록할 수 있는 화면으로 이동한다.|
|`ScheduleViewController`|스케줄 수정 및 생성시 나타나는 화면이다.  스케줄의 정보를 입력하고 저장버튼 클릭 시 로컬과 리모트에 스케줄이 저장된다. 저장하면서 Notification 예약도 함께 진행된다.|
|`AuthenticationRepository`|OAuth를 통해 인증 토큰을 받아오고, 받아온 토큰을 키체인을 통해 관리한다.|
|`UserRepository`|Firebase를 통해 유저를 등록한다. 로컬에 저장되어있는 유저 정보를 읽어오거나 제거할 수 있다.|
|`ScheduleRepository`|스케줄 데이터를 관리하는 타입이다. 불러오기, 수정, 쓰기, 삭제 기능 등을 제공하고, 모든 작업을 리모트와 로컬에 모두 반영될 수 있도록 한다. 스케줄들을 관리하면서 `해당 스케줄의 Notification`도 같이 관리한다.|

&nbsp;

### Utilities

|class/struct|역할|
|:-|:-|
|`LocalStorage`|로컬에 사용자 정보를 관리해주는 타입이다.|
|`KeyChainStorage`|키체인에 인증 토큰을 관리해주는 타입이다.|
|`FirestoreStorage`|Firebase DB를 활용하여 사용자 정보 및 스케줄들을 관리해주는 타입이다.|

&nbsp;

## 👀 실행 화면

> 기능들을 빠르게 확인하려면, `더보기`에 타임 라인을 활용해주세요.

[![실행 화면](http://img.youtube.com/vi/inRuSgawL1Y/0.jpg)](https://youtu.be/inRuSgawL1Y)

&nbsp;

## 💪🏻 기술적 도전

### Combine

연속된 escaping closure를 피하고, 선언형 프로그래밍을 통한 높은 가독성과 오퍼레이터들을 통한 효율적인 비동기 처리를 위해서 Combine을 사용하게 되었습니다.

### Coordinator

화면 전환에 대한 로직을 ViewController로부터 분리하고 의존성 객체에 대한 주입을 외부에서 처리하도록 하기 위해 코디네이터를 적용했습니다.

&nbsp;

### Firebase-FireStore

하나의 쿼리에 정렬과 필터링 모두 가능하여 복합적인 쿼리가 가능하고, 대용량 데이터가 자주 읽힐 때 사용하기 좋은 FireStore 데이터베이스를 사용하였습니다.

&nbsp;

## 🔥 Trouble Shooting

### 메모리 누수 디버깅

* `상황` 기능 구현을 모두 마치고, 리팩토링하며 개선하는 과정중에 메모리 누수가 나는 것을 발견하여 디버깅을 시도하였다. 정말 할 수 있는 방법을 모두 써가면서 디버깅을 해보았지만, 아무리 찾아봐도 어디서 누수가 나는 건지 찾을 수가 없었다. 그래서 메모리 누수가 의심되는 ViewController 내부에 View 설정, bind 작업 등을 하나씩 다시 추가해가며, 어떤 곳에서 누수가 나는지.... 노가다를 시작하게 되었다.
* `이유` 이번에 잘 사용하지 않았던 UICollectionViewDiffableDataSource를 사용하게 되면서 레이아웃 또한 CompositionalLayout으로 도전하게 되었는데, 구현하던 도중 클로저를 메소드로 할당해주는 작업에서 누수가 나는 것을 확인하게 되었다.
* `해결` 따라서 아래와 같이 클로저를 메소드로 바로 할당해주는 것이 아니라, 클로저를 통해 메소드를 호출하는 방식으로 수정하여 누수를 해결하게 되었다. 이런 곳에서 누수가 나는 경험은 처음이라서... 삽질을 많이 했던 것 같은데, 덕분에 다음부턴 조심할 수 있게 되었다...!!!

> 코드를 수정한 내용

![](https://i.imgur.com/1POQ27X.png)

&nbsp;

### 네비게이션 바 버튼 커스텀하기

* `상황` 네비게이션 바에 back 버튼을 커스텀하고 싶어서 새로운 바버튼 아이템을 할당해주었다. 그러고나니까 기존에 기본으로 있던 기능인 뒤로가기 제스처가 동작하지 않았다.
* `이유` 기본적으로 있던 바버튼을 새로운 바버튼으로 할당시켜준 부분 때문에 뒤로가기 제스처도 같이 사라진 것 같았다. 
* `해결` 그래서 네비게이션 컨트롤러를 override하여 UIGestureRecognizerDelegate를 채택하고, gestureRecognizerShouldBegin 함수를 활용하여 네비게이션 컨트롤러를 커스텀하여 해당 문제를 해결하게 되었다.

&nbsp;


## 😵‍💫 고민했던 점

### API Secret Key 관리하기
    
PR을 올리는 과정에서 GitGuardian에게 아래와 같은 메일을 받았다.

![](https://i.imgur.com/64PUPkN.png)

App ID나 App Key는 remote에 올리면 안된다는 것을 알고 있었다. 하지만 Facebook의 경우 info.plist에 App key를 등록해야 이용할 수 있었다. 이 문제를 해결하기 위해 방법을 알아보니 `.xcconfig`를 활용하는 방법이 있었고, 해당 파일을 활용하여 환경변수를 설정하고 App key를 remote에서 감출 수 있었다.

> Configuration Set을 설정하고...

![](https://i.imgur.com/RCMi9yq.png)

> 환경변수로 APP ID 등을 감춘 모습.

![](https://i.imgur.com/7NacUnA.png)

&nbsp;

### 에러 처리
API 문서를 참고해서 상태 코드에 따라 개발자에게는 로그를 보여주도록 했다. </br>
사용자의 경우는 사용자가 처리할 수 있는 에러라면 설명을 넣었고, 그렇지 않다면 `알 수 없는 에러`를 보여주도록 해주었다.

&nbsp;

### UI/UX 설계하기

프로젝트 요구사항에는 화면을 자유롭게 구성 및 배치하라고 되어있어서 화면들을 직접 설계해야했었다. 그래서 프로젝트 요구사항들을 체크해서 구현해야하는 기능 명세를 정리하고, 타사 앱들을 참고해가며 Figma를 사용해서 최대한 할 수 있는 만큼 실력을 발휘해서 UI 배치를 성공적으로 마무리했다.

> [당시 만들었던 프로토타입 바로가기](https://www.figma.com/file/p3vmDFgSHX7xAby2kAdF9D/PersonalScheduler?node-id=0%3A1&t=m3EyHjCW5j5u91eY-1)
