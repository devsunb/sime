# Sime 테스트

이 디렉토리에는 Sime 입력기의 핵심 로직을 검증하는 단위 테스트가 포함되어 있습니다.

## 테스트 파일 구조

```
SimeTests/
├── HangulCharacterTests.swift    # 한글 문자 Enum 및 매핑 테스트
├── CompositionTests.swift        # Composition/Automata 테스트
├── KeyboardDubeolTests.swift     # 두벌식 키보드 테스트
├── KeyboardSemoiTests.swift      # 세모이 키보드 테스트
└── HangulTests.swift             # Hangul 통합 테스트
```

## 테스트 영역

### HangulCharacterTests
- 초성/중성/종성 유니코드 값 검증
- 호환 자모 매핑 검증

### CompositionTests
- Composition struct 초기 상태 및 크기 계산
- Automata 조합 로직 (두벌식/세모이)

### KeyboardDubeolTests
- 두벌식 레이아웃 매핑
- 복합 모음/겹받침 처리
- 쌍자음 처리 (Shift/연타)
- NFC/NFD 정규화
- 완성형 글자 조합

### KeyboardSemoiTests
- 세모이 레이아웃 매핑 (모아치기)
- 순서 무관 조합
- 약어 데이터 검증
- 기호 레이아웃

### HangulTests
- Hangul 클래스 통합 테스트
- process/backspace/flush 동작
- 키보드 전환
- 약어 처리

## Xcode에서 테스트 타겟 추가 방법

### 1. 테스트 타겟 생성

1. Xcode에서 `Sime.xcodeproj` 열기
2. File → New → Target 선택
3. **macOS** → **Unit Testing Bundle** 선택
4. Product Name: `SimeTests`
5. Target to be Tested: `Sime`
6. Finish 클릭

### 2. 테스트 파일 추가

1. 프로젝트 네비게이터에서 `SimeTests` 그룹 선택
2. File → Add Files to "Sime"... 선택
3. `SimeTests` 폴더의 모든 `.swift` 파일 선택
4. "Copy items if needed" 체크 해제
5. Target: `SimeTests` 체크
6. Add 클릭

### 3. 테스트 실행

- **단축키**: `Cmd + U` (전체 테스트 실행)
- **개별 실행**: 테스트 함수 옆의 다이아몬드 아이콘 클릭
- **테스트 네비게이터**: `Cmd + 6`으로 열기

## 명령줄에서 테스트 실행

테스트 타겟이 추가된 후:

```bash
# 전체 테스트 실행
xcodebuild test \
  -project Sime.xcodeproj \
  -scheme Sime \
  -destination 'platform=macOS'

# 특정 테스트 클래스 실행
xcodebuild test \
  -project Sime.xcodeproj \
  -scheme Sime \
  -destination 'platform=macOS' \
  -only-testing:SimeTests/KeyboardDubeolTests
```

## 테스트 커버리지

현재 테스트가 커버하는 영역:

| 파일 | 커버 영역 |
|------|----------|
| `HangulCharacter.swift` | Enum 값, 매핑 테이블 |
| `Hangul.swift` | Composition, Automata, Hangul 클래스 |
| `Keyboards.swift` | 기본 클래스 메서드 |
| `KeyboardDubeol.swift` | 레이아웃, 조합 로직 |
| `KeyboardSemoi.swift` | 레이아웃, 약어, 모아치기 |

### 테스트되지 않는 영역

- `SimeInputController.swift`: InputMethodKit 의존성
- `SingletonOpt.swift`: UserDefaults 의존성
- `SingletonPrintLog.swift`: 파일 I/O 의존성
- `AppDelegate.swift`, `Main.swift`: 앱 생명주기

## 참고사항

- 타이밍 관련 테스트는 실제 시간 지연이 필요할 수 있음
- 모아치기 테스트는 입력 순서가 달라도 같은 결과가 나와야 함
- 약어 키는 항상 정렬된 상태로 저장되어야 함
