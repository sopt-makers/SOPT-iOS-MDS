# 컴포넌트 가이드

MDS가 제공하는 UIKit 컴포넌트의 공개 API와 사용법을 정리합니다. 모든 컴포넌트는 `public final class`로 제공되며, 색상·타이포그래피·spacing·radius는 [토큰 가이드](tokens.md)의 Semantic 토큰을 내부적으로 사용합니다. 아이콘 파라미터는 모두 [`MDSIcon`](icons.md) 타입입니다.

## 목차

- [Button](#button)
- [Control](#control)
- [Input](#input)
- [Avatar](#avatar)
- [Callout](#callout)
- [Chip](#chip)
- [Dialog](#dialog)
- [Tab](#tab)
- [Tag](#tag)

---

## Button

### MDSActionButton

`UIControl` 기반 기본 액션 버튼입니다. `isEnabled`/`isHighlighted`로 상태를 제어합니다.

```swift
let button = MDSActionButton(
    variant: .primary,
    size: .large,
    title: "확인",
    suffixIcon: .arrowRightOutlined
)
```

| 파라미터 | 타입 | 기본값 | 설명 |
|---|---|---|---|
| `variant` | `Variant` (`.primary` / `.secondary` / `.danger`) | `.primary` | 색상 스타일. `danger` + `xsmall` 조합은 지원하지 않습니다 — 이 조합으로 생성하면 디버그 빌드에서 `assertionFailure`가 발생하고, size가 `.small`로 자동 보정됩니다(릴리즈 빌드는 assertion 없이 보정만 적용). |
| `size` | `Size` (`.xsmall` / `.small` / `.medium` / `.large`) | `.large` | 높이·타이포그래피·아이콘 크기를 함께 결정 |
| `title` | `String?` | `nil` | 버튼 텍스트. 이후 대입으로 변경 가능 |
| `prefixIcon` / `suffixIcon` | `MDSIcon?` | `nil` | 좌/우 아이콘 |
| `prefixIconTint` / `suffixIconTint` | `MDSIcon.Tint` | `.automatic` | 아이콘 색상 적용 방식 |

### MDSFloatingButton

화면에 고정 노출되는 원형/확장형 플로팅 버튼입니다.

```swift
let fab = MDSFloatingButton(size: .default, icon: .plusOutlined)
let extendedFab = MDSFloatingButton(size: .extended, icon: .plusOutlined, label: "새 글쓰기")
```

| 파라미터 | 타입 | 기본값 | 설명 |
|---|---|---|---|
| `size` | `Size` (`.default` / `.extended`) | `.default` | `.default`는 48×48 아이콘 전용 원형, `.extended`는 아이콘+라벨 |
| `icon` | `MDSIcon?` | `nil` | |
| `iconTint` | `MDSIcon.Tint` | `.automatic` | |
| `label` | `String?` | `nil` | `.extended`에서만 표시 |

### MDSReactionButton

좋아요/공감 등 카운트가 붙는 토글형 버튼입니다. `isSelected`로 선택 상태를 제어합니다.

```swift
let reaction = MDSReactionButton(
    size: .medium,
    icon: .thumbsUpOutlined,
    title: "좋아요",
    count: 12
)
reaction.addTarget(self, action: #selector(toggleReaction), for: .touchUpInside)
```

| 파라미터 | 타입 | 기본값 | 설명 |
|---|---|---|---|
| `size` | `Size` (`.xsmall` / `.small` / `.medium` / `.large`) | `.medium` | `.xsmall`은 배경/보더 없이 텍스트만 표시 |
| `icon` / `trailingIcon` | `MDSIcon?` | `nil` | 좌/우 아이콘, 각각 독립된 tint 파라미터 보유 |
| `title` | `String` | 필수 | |
| `count` | `Int?` | `nil` | `nil`이면 카운트 라벨 숨김 |
| `isSelected` | `Bool` | `false` | 선택 시 accessibilityLabel에 카운트 포함 |

### MDSTextButton

배경 없이 텍스트(+ 선택적 아이콘)만 있는 버튼입니다.

```swift
let textButton = MDSTextButton(variant: .emphasis, size: .small, title: "더보기", icon: .chevronRightOutlined)
```

| 파라미터 | 타입 | 기본값 | 설명 |
|---|---|---|---|
| `variant` | `Variant` (`.default` / `.emphasis`) | `.default` | `.emphasis`는 더 진한 foreground |
| `size` | `Size` (`.small` / `.medium`) | `.medium` | |
| `title` | `String` | 필수 | |
| `icon` | `MDSIcon?` | `nil` | 텍스트 우측에 표시 |

---

## Control

### MDSCheckbox

```swift
let checkbox = MDSCheckbox(size: .large, title: "약관에 동의합니다")
checkbox.addTarget(self, action: #selector(checkboxChanged), for: .valueChanged)
```

- `size`: `.small` / `.large`
- `title: String?` — 대입 후 변경 가능
- `isSelected` / `isEnabled` — 오버라이드된 `UIControl` 프로퍼티, 탭 시 자체적으로 토글되고 `.valueChanged` 액션을 보냅니다.

### MDSRadioButton / MDSRadioGroup

라디오 버튼 자체는 상호배타 로직을 갖지 않으므로, 여러 개를 묶을 때는 `MDSRadioGroup`을 사용합니다.

```swift
let optionA = MDSRadioButton(size: .large, label: "옵션 A")
let optionB = MDSRadioButton(size: .large, label: "옵션 B")

let group = MDSRadioGroup()
group.add([optionA, optionB])
group.onSelectionChanged = { index in
    print("selected index: \(index)")
}
```

- `MDSRadioButton(size:label:)` — `size`: `.small` / `.large`
- `MDSRadioGroup.add(_:)` — 버튼 등록(단일/배열 오버로드). 등록된 버튼 중 하나가 탭되면 나머지를 자동으로 `isSelected = false` 처리합니다.
- `onSelectionChanged: ((Int) -> Void)?` — 그룹 내 등록 순서 기준 index 콜백

### MDSToggle

```swift
let toggle = MDSToggle(size: .large)
toggle.isOn = true
toggle.addTarget(self, action: #selector(toggleChanged), for: .valueChanged)
```

- `size`: `.small` / `.large`
- `isOn: Bool` — 대입 시 애니메이션과 함께 thumb 위치가 갱신됩니다. 탭하면 자체적으로 토글됩니다.

---

## Input

세 컴포넌트(`MDSTextField`, `MDSTextArea`, `MDSSearchField`) 모두 `label` / `descriptionText` / `helperText` / `errorMessage` / `maxLength` 등 동일한 필드 구성 패턴을 공유하고, `keyboardType`·`returnKeyType`·`autocapitalizationType` 등 `UITextField`/`UITextView`의 주요 설정을 그대로 노출합니다.

### MDSTextField

```swift
let field = MDSTextField(
    variant: .default,
    placeholder: "이메일을 입력하세요",
    label: "이메일",
    isRequired: true,
    helperText: "회사 이메일만 가능합니다",
    maxLength: 50
)
field.onTextChanged = { text in /* ... */ }
field.errorMessage = "올바른 이메일 형식이 아닙니다" // nil이면 에러 상태 해제
```

| 프로퍼티 | 설명 |
|---|---|
| `variant` | `.default`(레이어 배경) / `.bold`(neutral ghost 배경), init 전용 |
| `state` | `.default` / `.disabled`. `.active`·`.filled`는 포커스·입력값 유무로 자동 계산됩니다 |
| `errorMessage` | `nil`이 아니면 에러 스타일 표시(단, `disabled`가 우선) |
| `text` | get/set 가능. **직접 대입 시 `onTextChanged`는 호출되지 않습니다** — 사용자 입력에만 반응 |
| `onTextChanged` / `onEditingBegin` / `onEditingEnd` / `onReturn` | 콜백 |

### MDSTextArea

`MDSTextField`와 동일한 필드 패턴에 자동 높이 조절(48~150pt, 초과 시 내부 스크롤)과 전송 버튼을 추가로 지원합니다.

```swift
let textArea = MDSTextArea(
    variant: .default,
    hasSendButton: true,
    placeholder: "메시지를 입력하세요",
    maxLength: 500
)
textArea.onSendTapped = { /* ... */ }
```

- `hasSendButton: Bool` — `true`면 우측 하단에 전송 아이콘 버튼 표시, `sendButtonIcon`(기본 `.sendOutlined`)으로 아이콘 교체 가능
- `onSendTapped: (() -> Void)?`

### MDSSearchField

```swift
let search = MDSSearchField(variant: .default, placeholder: "검색어를 입력하세요")
search.onSearchTapped = { keyword in /* ... */ }
```

- 좌측 검색 아이콘 + 우측 clear 버튼(입력 중일 때만 노출) 고정 구성
- `onTextChanged` / `onEditingBegin` / `onEditingEnd` / `onSearchTapped(keyword:)` / `onClearTapped`

---

## Avatar

```swift
let avatar = MDSAvatar(size: 48, variant: .ghost, image: profileImage, hasStroke: true)
```

- `size: CGFloat` — 권장 사이즈: 24 / 32 / 48 / 56 / 72 / 80 / 120 / 180pt (자유값도 가능하나 stroke 두께가 이 스케일 기준으로 계산됩니다)
- `variant`: `.ghost` / `.subtle` — `image`가 `nil`일 때 보이는 fallback 배경
- `image: UIImage?` — `nil`이면 기본 사용자 아이콘 표시
- `hasStroke` / `strokeColor` — 외곽선 여부와 색상

---

## Callout

배너형 안내 메시지입니다. `buttonTitle`을 넘기면 내부적으로 `MDSTextButton`이 붙습니다.

```swift
let callout = MDSCallout(
    style: .information,
    text: "새로운 기능이 추가되었습니다.",
    icon: .infoCircleFilled,
    buttonTitle: "자세히 보기"
)
callout.onButtonTap = { /* ... */ }
```

- `style`: `.danger` / `.information`
- `buttonIcon` 기본값은 `.chevronRightOutlined`이며, `buttonTitle`이 `nil`이면 버튼 자체가 생략됩니다.

---

## Chip

```swift
let chip = MDSChip(size: .medium, type: .outlined, prefixIcon: .checkOutlined)
chip.chipTitle = "전체"
chip.isSelected = true
```

- `size`: `.small` / `.medium`
- `type`: `.outlined` / `.solid`
- `isSelected` / `isEnabled` 조합으로 배경·보더·foreground가 계산됩니다.

---

## Dialog

```swift
let dialog = MDSDialog(
    variant: .default(
        primaryButtonTitle: "확인", primaryButtonPrefixIcon: nil, primaryButtonSuffixIcon: nil,
        secondaryButtonTitle: "취소", secondaryButtonPrefixIcon: nil, secondaryButtonSuffixIcon: nil
    ),
    title: "정말 삭제하시겠어요?",
    description: "삭제 후에는 복구할 수 없습니다.",
    checkBoxTitle: "다시 보지 않기"
)
dialog.onPrimaryTap = { /* ... */ }
dialog.onSecondaryTap = { /* ... */ }
dialog.onCheckBoxChanged = { isSelected in /* ... */ }
```

`variant`는 associated value로 버튼 텍스트/아이콘을 함께 받는 3가지 케이스를 가집니다.

| variant | 버튼 구성 |
|---|---|
| `.default(primary…, secondary…)` | primary(강조) + secondary(취소) |
| `.information(primary…)` | primary 버튼 하나만 |
| `.danger(primary…, secondary…)` | danger 스타일 primary + secondary |

`checkBoxTitle`을 넘기면 내부에 `MDSCheckbox`가 생성되며, `isCheckBoxSelected`로 외부에서 선택 상태를 읽고 쓸 수 있습니다.

---

## Tab

`MDSTab`은 탭 하나이고, `MDSTabs`는 탭을 모아 단일 선택으로 동작시키는 컨테이너입니다. 화면 전환은 사용하는 쪽에서 `MDSTabs.onSelectionChanged`로 처리합니다.

### MDSTab

```swift
let tab = MDSTab(title: "Tab", variant: .hug, size: .large, tag: .init(text: "TAG"), isSelected: true)
tab.tabTag = nil   // 태그 제거
```

| 파라미터 | 타입 | 설명 |
|---|---|---|
| `title` | `String` | 필수. 이후 대입으로 변경 가능 |
| `variant` | `.hug` / `.fill` | `.hug`는 내용 크기, `.fill`은 부모가 준 폭을 채움 (라벨이 남는 폭을 채우고 태그는 오른쪽) |
| `size` | `.small` / `.medium` / `.large` | 타이포그래피 `heading4` / `heading3` / `heading2` |
| `tag` | `MDSTab.Tag?` | `text` / `icon` / `style`(기본 `.subtle`)만 받습니다. 프로퍼티 이름은 `tabTag` |

- Tag의 `shape`(`pill`), `variant`(`primary`), `size`(`small`)는 Figma 규칙대로 고정이라 외부에서 바꿀 수 없습니다.
- 상태는 `isSelected` / `isEnabled`로 표현하며, `isEnabled = false`가 `isSelected`보다 우선합니다. 선택된 탭에만 밑줄이 그려집니다.
- `MDSTab`은 스스로 선택을 토글하지 않고 `.touchUpInside`만 보냅니다. 단일 선택은 `MDSTabs`가 관리합니다.
- `MDSTab` 자체가 투명한 터치 영역이고, 라벨·태그·밑줄은 그 안쪽에 그려집니다. 바깥 여백은 `.hug`는 좌우 10, `.fill`은 좌우 8, 상하 1이며 이 영역 전체가 터치됩니다. 높이는 Large 50 / Medium 44 / Small 38입니다.

### MDSTabs

```swift
let tabs = MDSTabs(
    items: [
        .init(title: "Tab"),
        .init(title: "Tab", tag: .init(text: "TAG")),
        .init(title: "Tab", isEnabled: false),
    ],
    variant: .fixed,
    size: .large
)
tabs.onSelectionChanged = { index in
    // 선택된 index에 맞는 화면으로 전환
}
tabs.setSelectedIndex(1)   // 코드로 변경. onSelectionChanged는 호출되지 않습니다.
```

| 파라미터 | 타입 | 설명 |
|---|---|---|
| `items` | `[MDSTabs.Item]` | `Item(title:tag:isEnabled:)` — 탭별 제목, 태그, 비활성 여부 |
| `variant` | `.scrollable` / `.fixed` | `.fixed`는 폭을 균등하게 나눠 가지며(Fill 탭), `.scrollable`은 폭을 넘치면 가로로 스크롤됩니다(Hug 탭) |
| `size` | `.small` / `.medium` / `.large` | `MDSTab.Size`와 같은 타입입니다. 높이는 Large 50 / Medium 44 / Small 38 |
| `divider` | `Bool` | 기본 `true`. 아래 구분선 표시 여부 |
| `selectedIndex` | `Int` | 초기 선택 index. 범위를 벗어나거나 비활성 항목이면 첫 번째 활성 항목으로 보정됩니다 |

- `onSelectionChanged: ((Int) -> Void)?` — 사용자가 탭을 눌러 선택이 바뀔 때만 호출됩니다. 이미 선택된 탭을 다시 누르거나 `setSelectedIndex(_:animated:)`로 바꾼 경우에는 호출되지 않습니다 (화면 → 탭 → 화면으로 이어지는 루프를 막기 위함).
- `.scrollable`에서는 선택한 탭이 화면 밖에 있으면 보이도록 자동으로 스크롤됩니다.
- `MDSTabs`는 폭을 직접 정하지 않으므로 좌우(leading/trailing) 제약이 필요합니다. 높이는 `size`로 정해집니다.
- 비활성(`isEnabled: false`) 항목은 선택할 수 없습니다. 초기 선택은 활성 항목으로 정해지고, `setSelectedIndex(_:animated:)`에 범위를 벗어나거나 비활성인 index를 넘기면 무시됩니다. 선택 가능한 탭이 하나도 없으면 `selectedIndex`는 `nil`입니다(`selectedIndex: Int?`).
- 탭은 최소 2개가 필요합니다. 2개 미만이면 디버그 빌드에서 `assert`로 알립니다(릴리즈 빌드는 동작은 하지만 지원하지 않는 구성입니다).
- 디자인 가이드: 권장 최대 5개입니다. 화면에 모두 보이면 `.fixed`, 많아지면 `.scrollable`을 사용합니다.

---

## Tag

```swift
let tag = MDSTag(text: "NEW", size: .small, shape: .pill, variant: .primary, style: .solid, icon: nil)
```

| 파라미터 | 타입 | 설명 |
|---|---|---|
| `size` | `.small` / `.medium` | |
| `shape` | `.rect` / `.pill` | `.pill`은 높이의 절반을 radius로 사용 |
| `variant` | `.default` / `.primary` / `.secondary` | |
| `style` | `.solid` / `.subtle` | `variant`와 조합되어 최종 배경/foreground 결정 |
| `text` | `String` | 이후 대입으로 변경 가능 |
