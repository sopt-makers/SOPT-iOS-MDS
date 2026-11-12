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
- [NavigationBar](#navigationbar)
- [SnackBar](#snackbar)
- [Menu](#menu)
- [Select](#select)
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

## NavigationBar

화면 최상단에서 현재 위치를 알려주고, 뒤로가기와 주요 액션을 제공합니다. 파라미터는 Figma `TopNavigation (Mobile)`의 Component properties와 1:1로 대응합니다.

```swift
let navigationBar = MDSNavigationBar(
    leftIcon: true,
    title: .title("Title"),
    rightIcons: [.heartOutlined, .heartOutlined, .heartOutlined],
    rightButton: .textButton("text button")
)
navigationBar.onLeftIconTap = { /* 뒤로가기 */ }
navigationBar.onRightIconTap = { index in /* rightIcons[index] */ }
navigationBar.onRightButtonTap = { /* ... */ }
```

| 파라미터 | Figma | 타입 | 기본값 | 설명 |
|---|---|---|---|---|
| `leftIcon` | `LeftIcon` | `Bool` | `true` | 좌측 뒤로가기(chevron) 아이콘. 최상위 화면은 `false`, 하위 화면(depth 2 이상)은 `true` |
| `title` | `Title` + `TitleSlot` | `TitleSlot?` (`.title(String)` / `.logo` / `.custom(UIView)`) | `nil` | `nil`이면 `Title=false` |
| `rightIcons` | `RightIcon01~03` | `[MDSIcon]` | `[]` | 앞에서부터 01, 02, 03 순서. 최대 3개까지 노출되고 초과분은 무시됩니다 |
| `rightButton` | `RightButton` + Button Variant | `RightButton?` (`.textButton(String)` / `.actionButton(String)`) | `nil` | `nil`이면 `RightButton=false` |

- 모든 파라미터는 생성 후 대입으로 변경 가능합니다.
- 높이는 44로 고정이며, 좌우(leading/trailing) 제약이 필요합니다.
- `.title`은 1줄이며 길면 말줄임(…) 처리됩니다. 우측 아이콘/버튼이 먼저 공간을 차지하고 타이틀이 남는 영역을 채웁니다.
- `.logo`는 SOPT 로고를 원본 비율(65×22.38)로 노출합니다.
- `.custom(UIView)` — Slot(높이 40)에 원하는 뷰를 넣습니다. 좌측·세로 중앙 정렬되며 Slot 너비를 넘지 않습니다. 높이는 40 이하로 맞춰주세요. `title`이 바뀌면 이전 커스텀 뷰는 제거됩니다.
- `.textButton`은 `MDSTextButton(.emphasis, .medium)`, `.actionButton`은 `MDSActionButton(.primary, .small)`로 그려집니다.
- `onRightIconTap: ((Int) -> Void)?` — 탭한 아이콘의 `rightIcons` index(0부터)를 전달합니다.
- 디자인 가이드: 강조가 필요한 단일 액션(완료, 등록 등)은 `.actionButton`, 보조 액션은 `.textButton`을 사용합니다. 아이콘과 버튼을 많이 쓰면 타이틀 영역이 좁아지니 타이틀 텍스트가 잘리지 않는지 확인하세요.

### 화면에 적용하기

> **사용처에서 직접 설정해야 합니다.** MDS는 바 UI와 탭 콜백만 제공합니다. `import MDS`만으로는 화면 부착, 뒤로가기, 시스템 바 숨김, 스와이프 뒤로가기가 처리되지 않으며, 아래 코드는 모두 앱에 작성하는 예시입니다.

`MDSNavigationBar`는 `UIView`이므로 시스템 바 대신 화면에 subview로 붙입니다. 뒤로가기는 자동으로 연결되지 않으니 `onLeftIconTap`에 직접 지정하세요.

```swift
final class DetailViewController: UIViewController {
    private let navigationBar = MDSNavigationBar(title: .title("상세"))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SemanticColor.Bg.Layer.basement // 상태바 영역 색을 바와 맞춥니다.

        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        navigationBar.onLeftIconTap = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
```

`UINavigationController`에 push하는 경우 시스템 바를 숨겨야 합니다. 시스템 바를 숨기면 스와이프 뒤로가기도 막히므로 앱에 내비게이션 컨트롤러 클래스를 만들어 복구합니다. 아래 `AppNavigationController`는 MDS에 포함되어 있지 않습니다.

```swift
final class AppNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(true, animated: false) // 혼합 스택에서는 이 줄을 뺍니다.
        interactivePopGestureRecognizer?.delegate = self
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        viewControllers.count > 1
    }
}
```

시스템 바 숨김은 스택 구성에 맞춰 아래 두 방식 중 하나만 사용하세요.

**스택의 모든 화면이 `MDSNavigationBar`를 쓰는 경우**: 위 클래스를 그대로 사용합니다. 전역으로 숨겨지므로 VC별 숨김 코드는 넣지 마세요. `setNavigationBarHidden(false, ...)`를 호출하면 시스템 바가 다시 표시되어, 전역 숨김에 의존하는 다음 화면에 바가 나타납니다.

**시스템 바를 쓰는 화면이 같은 스택에 섞여 있는 경우**: 위 클래스에서 `setNavigationBarHidden(true, animated: false)` 줄을 빼세요. 그대로 쓰면 그 화면들의 시스템 바도 사라집니다. 대신 각 화면의 `viewWillAppear`에서 그 화면에 맞게 바 상태를 설정합니다.

```swift
// MDSNavigationBar를 쓰는 화면
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
}

// 시스템 바를 쓰는 화면
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)
}
```

---

## SnackBar

화면 상단에서 내려와 잠시 노출된 뒤 사라지는 알림 메시지입니다. `buttonTitle`을 넘기면 우측에 `MDSTextButton`이 붙습니다.

```swift
MDSSnackBar(
    style: .success,
    text: "프로젝트가 등록되었어요.",
    buttonTitle: "보러가기",
    onButtonTap: { /* ... */ }
).show(in: view.window ?? view)
```

| 파라미터 | 타입 | 기본값 | 설명 |
|---|---|---|---|
| `style` | `Style` (`.default` / `.success` / `.alert` / `.error`) | `.default` | 좌측 아이콘과 색상. `.default`는 아이콘 없음 |
| `text` | `String` | 필수 | 최대 2줄 |
| `buttonTitle` | `String?` | `nil` | `nil`이면 버튼 생략 |
| `onButtonTap` | `(() -> Void)?` | `nil` | 버튼 탭 콜백. 호출 후 스낵바가 자동으로 dismiss됩니다 |

- `style` / `text` / `buttonTitle`은 생성 후 대입으로 변경 가능합니다.
- `show(in:duration:)` — `view`의 safe area 상단(좌우 20, 위 16 여백)에 노출되고 `duration`초(기본 4) 뒤 자동으로 사라집니다. 화면 전환과 상관없이 위에 보이게 하려면 `view.window`를 넘기세요.
- 이미 노출 중인 스낵바가 있으면 큐에 쌓였다가 앞의 스낵바가 사라진 뒤 순서대로 노출됩니다.
- `dismiss()` — 즉시 사라지게 합니다. 아직 큐에서 대기 중인 스낵바에 호출하면 큐에서 제거됩니다.

---

## Menu

항목을 탭하면 바로 동작하는 메뉴 목록입니다. 메뉴 자체에는 선택된 상태가 없고, 선택 표시가 필요하면 Checkbox 타입을 사용합니다.

### MDSIconMenu

아이콘과 텍스트로 이뤄진 메뉴 목록입니다.

```swift
let menu = MDSIconMenu(
    items: [
        .init(title: "알림", icon: .bellOutlined),
        .init(title: "공유", icon: .sendOutlined),
        .init(title: "텍스트만"),
    ],
    onSelect: { index in /* ... */ }
)
```

| 파라미터 | 타입 | 기본값 | 설명 |
|---|---|---|---|
| `items` | `[MDSIconMenu.Item]` | 필수 | `title`과 `icon`(`MDSIcon?`)을 가집니다. `icon`이 `nil`이면 텍스트만 표시합니다 |
| `onSelect` | `((Int) -> Void)?` | `nil` | 항목을 탭(touchUpInside)했을 때 해당 index로 호출됩니다. 생성 후 대입으로도 바꿀 수 있습니다 |

- 모바일에는 hover가 없어서 항목을 누르고 있는 동안을 Hover 상태로 표현합니다. 손가락이 항목 밖으로 벗어나거나 손을 떼면 Default로 돌아갑니다.
- 폭은 내용에 맞춰지며 항목 하나의 최소 폭은 80입니다. 위치와 폭은 사용하는 쪽에서 제약으로 정합니다.
- 팝오버로 띄우는 동작은 포함하지 않는 리스트 뷰입니다.

---

## Select

탭하면 아래에 메뉴가 열리는 선택 필드입니다. `type`으로 선택 방식과 열리는 메뉴를 함께 정하며, 메뉴는 [Menu](#menu)의 공개 메뉴를 그대로 사용합니다.

```swift
// 단일 선택 — 항목을 탭하면 값이 채워지고 메뉴가 바로 닫힙니다.
let single = MDSSelect(
    type: .single(.text([
        .init(title: "Menu 1", description: "description..."),
        .init(title: "Menu 2", description: "description..."),
    ])),
    placeholder: "Placeholder"
)

// 다중 선택 — 탭할 때마다 체크가 토글되고 메뉴는 열린 채로 남습니다.
let multiple = MDSSelect(
    type: .multiple(.checkbox([
        .init(title: "Label 1", isChecked: true),
        .init(title: "Label 2"),
    ])),
    placeholder: "Placeholder",
    menuMaxHeight: 240
)
multiple.onSelectionChanged = { indices in /* ... */ }
```

| 파라미터 | 타입 | 기본값 | 설명 |
|---|---|---|---|
| `type` | `SelectType` | 필수 | 선택 방식과 열리는 메뉴. Figma Select의 Type 속성입니다. 아래 표 참고 |
| `placeholder` | `String` | 필수 | 선택된 항목이 없을 때 표시 |
| `menuWidth` | `CGFloat?` | `nil` | 메뉴 너비. `nil`이면 글자 길이에 맞추고 메뉴별 최소 너비는 지킵니다 |
| `menuMaxHeight` | `CGFloat?` | `nil` | 메뉴 최대 높이. 넘치면 메뉴 안에서 스크롤됩니다. `nil`이면 화면에 들어가는 만큼 늘어납니다 |

| `type` | 메뉴 (`SingleMenu` / `MultipleMenu`) | 항목 타입 |
|---|---|---|
| `.single(_:)` | `.text(_:)` | `[MDSTextMenu.Item]` |
| | `.icon(_:)` | `[MDSIconMenu.Item]` |
| | `.userList(_:)` | `[MDSUserListMenu.Item]` |
| `.multiple(_:)` | `.text(_:)` (체크마크) | `[MDSTextMenu.Item]` |
| | `.checkbox(_:)` (체크박스) | `[MDSCheckboxMenu.Item]` |

- 선택 방식마다 쓸 수 있는 메뉴만 받으므로, 다중 선택 + Icon/UserList 메뉴처럼 지원하지 않는 조합은 컴파일 단계에서 막힙니다.
- Text, Checkbox 항목의 `isChecked`가 처음 선택 상태가 됩니다. `.single`이면 체크된 항목 중 가장 앞의 하나만 남습니다.
- `.single`은 메뉴에 선택 표시를 남기지 않습니다. 다시 열어도 체크가 보이지 않습니다.
- 필드에는 선택된 항목 중 목록에서 가장 앞에 있는 항목의 제목이 표시되고, `.multiple`이면 오른쪽에 선택 개수 태그가 붙습니다.
- `selectedIndices: Set<Int>` — 선택된 항목의 index. 코드로 바꿀 수 있으며 이때 `onSelectionChanged`는 호출되지 않습니다. 범위를 벗어난 index는 버려집니다. 다중 선택 메뉴가 열려 있으면 메뉴의 체크도 함께 바뀌므로, `onSelectionChanged` 안에서 선택 개수를 제한하는 식으로 써도 됩니다.
- `onSelectionChanged: ((Set<Int>) -> Void)?` — 사용자가 메뉴에서 선택을 바꾼 뒤 호출됩니다.
- 메뉴는 window 위에 떠서 열리고, 메뉴 바깥을 탭하면 닫힙니다. 열려 있는 동안 필드는 Active 상태(테두리, 위쪽 chevron)가 됩니다.
- 메뉴는 필드 아래 10 간격으로 열리며, 아래 공간이 모자라고 위가 더 넓으면 필드 위로 열립니다. 오른쪽 화면 끝을 넘으면 넘는 만큼 왼쪽으로 당겨서 열리고, 화면 끝에서 16 이상 떨어지도록 크기가 제한됩니다.
- 필드 높이는 46으로 고정이고 최소 너비는 100입니다. 너비는 사용하는 쪽에서 제약으로 정합니다.
- 디자인 가이드: 모바일에서는 아래 경우 Select 대신 바텀시트 사용을 권장합니다.
  - 텍스트가 길어 메뉴가 가로로 화면 끝까지 늘어나거나 말줄임이 필요한 경우 (바텀시트로 전체 내용을 보여줍니다)
  - 항목이 많아 메뉴가 세로로 길어지거나 화면을 많이 가리는 경우

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
