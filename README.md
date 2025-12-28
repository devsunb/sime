# Sime - 선비 입력기 (Seonbi Input Method Editor)

개인적으로 사용하기 위해 만든 macOS 용 한글 입력기

## 지원하는 한글 자판

- 두벌식 - 기본값
- 세모이 ([세벌식 모아치기 e](https://blog.naver.com/eekdland/220526834927))

## 설치

현재는 직접 빌드 후 설치하는 방법만 지원

Xcode가 설치되어 있어야 함

```bash
git clone https://github.com/devsunb/sime.git
cd sime

# 빌드
xcodebuild -project Sime.xcodeproj -scheme Sime -configuration Release build

# 테스트 실행
xcodebuild -project Sime.xcodeproj -scheme Sime -destination 'platform=macOS' test

# 설치
pkill -9 Sime.app
rm -rf ~/Library/Input\ Methods/Sime.app
mv ~/Library/Developer/Xcode/DerivedData/Sime-*/Build/Products/Release/Sime.app ~/Library/Input\ Methods/Sime.app
```

### 설정

설치 후 로그아웃/로그인 한 번 필요할 수 있음

시스템 설정 → 키보드 → 입력 소스 편집에서 한국어 - 선비 추가

### 권한

손 뗄 때 입력(약어 사용 시 필요) 기능을 사용하려면 **손쉬운 사용** 권한 필요
- `processOnKeyUp` 옵션을 활성화하면 손쉬운 사용 권한을 요청함
- 시스템 설정 → 개인정보 보호 및 보안 → 손쉬운 사용에서 Sime 앱 추가

### 세모이 활성화 방법

터미널에서 아래 명령 실행

`defaults write dev.sunb.inputmethod.sime keyboard -int 1`
- `0`: 비활성화 (두벌식)
- `1`: 활성화 (세모이)

세부 설정은 아래 [설정](#설정) 섹션 참고

이렇게 한 이유: skhd, Hammerspoon 등을 이용해서 두벌식과 세모이를 쉽게 전환 가능

## 배경

컴퓨터를 좋아함
-> 오랜 시간 컴퓨터를 함 = 목, 허리, 손목 등 부상 우려

적은 움직임 = 빠른 속도 = 낮은 부하 -> 부상 위험 감소
-> 같은 글자를 더 적은 움직임으로, 더 빨리 치고 싶음
-> 스플릿 키보드, 입력기에 관심

한글 입력기 중에서는 세벌식 모아치기-e 자판에 관심이 생김
macOS를 사용하고 있어서 날개셋 입력기 사용이 불가능한 상태

구름 입력기나 Karabiner-Elements 기반으로 구현된 자판을 사용해보았는데
이어치기, 모아치기, 약어 중 일부가 원하는대로 동작하지 않았음

세벌식 다음 카페에서 숨통님이 macOS 용 세벌식 한글 입력기인 [팥알 입력기](https://github.com/soomtong/patim)를 만드셨다는 [게시물](https://cafe.daum.net/3bulsik/623N/324) 확인
팥알 입력기가 세모이 자판은 지원하지 않는 것 같아서 추가해보려고 시도하다 어려움 느낌
README를 읽다가 참고한 프로젝트로 나빌 입력기 for 맥이 링크되어 있어 코드를 읽어보니 여기서 출발하는 게 조금 더 쉬울 것 같다고 생각

## 기능

### 모아치기 종성 넘김

"서울"을 모아치기로 입력할 때, "서"를 입력한 상태에서 "울"의 종성인 "ㄹ"을 가장 먼저 입력하는 경우 "설우"가 될 수 있다.
이를 방지하기 위해서 다음과 같은 조건을 가지고 종성을 다음 글자로 넘기는 기능을 구현하였다.

- 현재 입력 중인 글자에 종성이 존재하고,
- 이번 입력된 낱자로 인해 다음 글자로 넘어가게 되는 시점에,
    - "서울" 예시에서는, "설"이 입력된 상태에서 "ㅇ" 이나 "ㅜ" 가 입력되는 시점이라고 보면 됨
- 직전 키와 입력 시간 간격이 임계치(기본적으로 150 ms) 미만인 경우
- 최근 연속 입력된 모든 종성을 다음 글자로 넘긴다.

### 약어

일단 IMKit 에서는 keyUp 이벤트를 기본적으로 처리하지 못하는 것으로 보인다.

- [cocoa - IMKit to catch NSKeyup event - Stack Overflow](https://stackoverflow.com/questions/23620864/imkit-to-catch-nskeyup-event)

그래서 기존과 같이 keyDown 시 입력을 처리하는 구조에서 약어 매칭을 진행하는 입력 대기열을 만들어서 약어를 구현했었다.
그리고 나니 keyDown 시 입력을 처리하면 약어 시퀀스를 포함하는 글자를 입력하는 게 어렵다는 것을 깨달았다.

예를 들어 `jw` 또는 `wj`를 입력하면 `입니다. `로 확장되어야 하는데, `jdw`를 입력하면 `입`이라는 글자가 입력되어야 한다.
근데 모아치기가 가능하니 `입`을 입력할 때는 `jdw`가 아니라 `jwd`나 `dwj`와 같이 입력해도 된다.
이때 `jwd`는 `입`이 아니라 `입니다.ㅣ`가 되어 버리고, `dwj`는 `ㅇ입니다.`가 되어 버리는 문제가 발생한다.

그래서 keyUp 시 입력 이벤트를 처리할 수 있도록 수정하였다.
keyUp 이벤트를 정상적으로 모니터 하려면 손쉬운 사용 권한을 허용해야 한다.

## 설정

터미널에서 `defaults` 명령어로 설정합니다. 변경 즉시 반영됩니다.

### 자판 선택

```bash
# 두벌식 (기본값)
defaults write dev.sunb.inputmethod.sime keyboard -int 0

# 세모이
defaults write dev.sunb.inputmethod.sime keyboard -int 1
```

### 손 뗄 때 입력 처리

세모이 약어 기능 사용하려면 활성화해야 함

활성화한 경우 손쉬운 사용 권한 필요함

```bash
# 비활성 (기본값)
defaults write dev.sunb.inputmethod.sime processOnKeyUp -int 0

# 활성
defaults write dev.sunb.inputmethod.sime processOnKeyUp -int 1
```

### 두벌식 연타로 쌍자음

```bash
# Shift 사용 (기본값)
defaults write dev.sunb.inputmethod.sime dubeolDouble -int 0

# 연타 (ㄷㄷ → ㄸ)
defaults write dev.sunb.inputmethod.sime dubeolDouble -int 1
```

### 디버그 로그

```bash
# 활성화 (~/Library/Logs/Sime.log에 기록)
defaults write dev.sunb.inputmethod.sime debug -bool true

# 비활성화
defaults write dev.sunb.inputmethod.sime debug -bool false

# 로그 실시간 확인
tail -f ~/Library/Logs/Sime.log
```

#### 로그 레벨

| 레벨 | 설명 | 항상 기록 |
|------|------|----------|
| ERROR | 예상치 못한 오류 | O |
| INFO | 설정 변경, 앱 시작/종료 | O |
| DEBUG | 키 입력, 조합 상태 등 상세 정보 | X (debug 활성화 시만) |

#### 로그 형식

```
[2025-01-01 12:00:00.000][INFO] [App] server activated
[2025-01-01 12:00:01.123][DEBUG] [Input] process 'r'
[2025-01-01 12:00:01.124][DEBUG] [Automata] preedit [r] [] []
```

카테고리: `[App]`, `[Config]`, `[Input]`, `[Automata]`, `[Timing]`

### 현재 설정 확인

```bash
defaults read dev.sunb.inputmethod.sime
```

### 설정 초기화

```bash
defaults delete dev.sunb.inputmethod.sime
```

## 문제 해결

### 로그 확인

```bash
tail -f ~/Library/Logs/Sime.log
```

## 참고한 프로젝트

- [나빌 입력기 for 맥](https://github.com/navilera/NavilIMEforMac): 한글 오토마타 코드 GPL-3.0
- [soomtong/patim](https://github.com/soomtong/patim)
- [rime/squirrel](https://github.com/rime/squirrel)
