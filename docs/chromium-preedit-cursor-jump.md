# Chromium 계열 앱에서 조합 커밋 시 커서 튐 문제

2026-07 진단/수정 기록. 관련 커밋: `Sime/SimeInputController.swift`의 preedit을
`kTSMHiliteRawText` attributed string으로 전달하는 변경.

## 증상

Chromium 기반 GUI 앱(Claude Desktop, Codex 등)의 리치 텍스트 입력창에서만:

- 커서 바로 뒤에 공백이 **정확히 1개** 있을 때 (`|_`)
- 한글 조합 후 space를 입력하면 (`가` + space)
- 텍스트는 `가__`로 정상 삽입되지만 커서가 `가|__` 위치로 튐
- 앱에 따라 preedit이 종료되지 않고 다음 글자가 덮어써지는 변형도 있음 (Codex)

특이 조건:

- 공백 0개 또는 2개 이상이면 정상. 공백 뒤 내용 유무는 무관
- space뿐 아니라 "커밋 문자와 같은 문자가 커서 뒤에 1개 있는" 모든 경우 재현
  (`|.` 상태에서 `가` + `.` -> `가|..`)
- plain contenteditable, textarea, 네이티브 앱은 모두 정상
- 기본 macOS 두벌식은 재현 안 됨

## 원인 체인

세 레이어가 겹쳐서 발생. Blink(Chromium 렌더링 엔진)는 무죄.

### 1. sime -> IMKit: plain string의 함정 (근본 원인)

`setMarkedText`에 plain NSString을 넘기면 IMKit이 클라이언트로 전달하는 과정에서
"선택된 절" 스타일(`kTSMHiliteSelectedConvertedText`)로 포장하며, 이때 IME가 지정한
`selectionRange`를 **무시하고 preedit 전체 `(0, length)`로 덮어쓴다**. 일본어식
절(clause) 변환 모델에서 "사용자가 지금 고르는 중인 절은 전체 선택으로 표시한다"는
관례 때문. 클라이언트에 도착하는 값은 NSTextView의 `setMarkedText`를 오버라이드한
로거(`scripts/imelogger.swift`)로 확인할 수 있다.

TSM 하이라이트 스타일별 도착값 (실측, macOS 15):

| 스타일 | 도착 selectedRange | 도착 속성 |
|---|---|---|
| 1 CaretPosition / 2 RawText / 3 SelectedRawText | IME 지정값 그대로 | NSUnderline=2 + 액센트색 (셋 다 동일) |
| 4 ConvertedText | IME 지정값 그대로 | NSUnderline=1 + 액센트색 + NSMarkedClauseSegment |
| 5 SelectedConvertedText, **plain string** | **(0, length)로 강제** | NSUnderline=2 + 액센트색 (+ NSMarkedClauseSegment) |

### 2. Chromium: selection을 DOM에 그대로 반영

Chromium(`render_widget_host_view_cocoa.mm`)은 도착한 selectedRange를 Blink에 그대로
전달하고, Blink `InputMethodController::SetComposition`은 조합 텍스트 삽입 후 그
범위를 실제 DOM selection으로 설정한다. 결과: 조합 중 DOM selection이 조합 글자
전체를 덮는 범위 선택이 된다 (Apple 두벌식은 preedit 끝의 collapsed 커서).

참고: 같은 keydown 안에서 여러 번 `insertText`를 호출해도 Chromium이
`_textToBeInserted`로 누적해 단일 `ImeCommitText`로 합치므로, 커밋을 쪼개는 방식의
우회는 불가능하다.

### 3. ProseMirror: 모호한 diff + Chrome 워크어라운드 오탐

ProseMirror는 IME 입력을 DOM mutation을 관찰해 diff로 역산한다
(`prosemirror-view/src/domchange.ts`). 커밋 mutation `"가_" -> "가__"`는 "공백이
어디에 삽입됐는지"가 모호하고, 이때 조합 중 모델 selection 시작점을 앵커 힌트로
쓴다(`findDiff`의 `preferredPos`).

- Apple (collapsed, 힌트=가 뒤): 삽입 위치를 가와 기존 공백 사이로 해석 -> 정상
- sime (전체 선택, 힌트=가 앞): 힌트가 모호 구간 밖 -> 삽입 위치를 문서 끝으로 해석

후자의 경우 "diff상 삽입 지점"과 "브라우저가 놓은 올바른 DOM 커서 위치"가 우연히
일치하는데, 이 조합이 prosemirror-view의 Chrome 전용 워크어라운드("Chrome은 조합 중
selection을 변경 시작점으로 잘못 보고할 때가 있으니 무시하라", `mkTr`의
`sel.head == chFrom` 검사)에 오탐으로 걸려 **올바른 커서 위치가 버려진다**. 이후
compositionend에서 ProseMirror가 자기 모델의 (낡은) selection으로 DOM을 되돌려
커서가 조합 글자 뒤로 튄다.

공백 2개 이상이면 diff 앵커(끝)와 DOM 커서 위치가 1 이상 어긋나 워크어라운드에
안 걸리고, 0개면 diff가 모호하지 않아 정상. "정확히 1개" 조건의 정체.

## 수정

`SimeInputController.updateDisplay`에서 preedit을 `mark(forStyle: kTSMHiliteRawText,
at:)` 속성을 입힌 NSAttributedString으로 전달. IMKit이 selectionRange(preedit 끝
collapsed)를 그대로 전달하게 되어 3번의 diff 앵커가 올바르게 잡힌다.

스타일은 의미상 정확한 2(RawText, 입력 중 미변환 텍스트)를 사용. 부작용으로 조합
중 글자가 "전체 선택 블록"에서 "밑줄"로 바뀌는데, 이는 Apple 입력기가 Chromium에서
보이는 모양과 동일하다.

## 진단 도구

- `scripts/imelogger.swift`: NSTextView의 NSTextInputClient 메서드를 오버라이드해
  클라이언트에 실제 도착하는 setMarkedText/insertText 인자를 출력하는 미니 앱.
  `xcrun swiftc -o /tmp/imelogger scripts/imelogger.swift && /tmp/imelogger`
- Chromium 쪽 검증은 contenteditable/ProseMirror/textarea에 keydown, beforeinput,
  composition 이벤트, MutationObserver(변경 전후), selectionchange를 전부 로깅하는
  HTML 페이지로 수행했다 (일회성이라 저장소에는 미포함).

## 배운 것

- IMKit은 IME가 넘긴 인자를 그대로 전달하지 않는다. plain string은 "선택된 절"로
  재해석되어 selectedRange가 덮어써진다. **preedit은 반드시 mark(forStyle:at:)로
  스타일을 명시한 attributed string으로 넘길 것.**
- Apple 두벌식은 네이티브 앱에서 marked text를 쓰지 않고 `insertText` +
  `replacementRange`로 앞 글자를 교체하는 방식으로 조합한다. replacementRange를
  지원하지 않는 클라이언트(Chromium 등)에서만 marked text로 폴백한다.
- Chromium에서 조합 중 한글이 "선택된 것처럼" 보이는 하이라이트는 DOM selection이
  아니라 composition marker 페인팅일 수도, 진짜 selection일 수도 있다. 진단 시
  둘을 구분해야 한다.
