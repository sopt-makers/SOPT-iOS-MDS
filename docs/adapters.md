# 어댑터 가이드

`MDS/Sources/Adapters`에는 `MDSFont`(타이포그래피 토큰)와 `MDSIcon`(아이콘 토큰)을 표준 UIKit 뷰에 적용하는 extension이 모여 있습니다. `setTypography`는 `public`이라 컨슈머 앱에서도 그대로 사용할 수 있지만, `setIcon`은 `internal`이라 MDS 컴포넌트 구현 내부에서만 쓰입니다 — 자세한 내용은 [setIcon](#seticon) 참고.

## MDSFont

[`Typography`](tokens.md#typography) semantic 토큰(`Typography.heading1` 등)의 실제 타입입니다.

```swift
public struct MDSFont: @unchecked Sendable {
    public let font: UIFont
    public let lineHeight: CGFloat
    public let letterSpacing: CGFloat

    public func attributedStringAttributes(
        foregroundColor: UIColor,
        alignment: NSTextAlignment = .natural,
        paragraphStyle configure: ((NSMutableParagraphStyle) -> Void)? = nil
    ) -> [NSAttributedString.Key: Any]
}
```

`attributedStringAttributes(foregroundColor:alignment:paragraphStyle:)`는 font/lineHeight/letterSpacing을 `NSAttributedString.Key` 딕셔너리로 변환합니다. 아래 `setTypography`가 있는 `UILabel`, `UITextField`, `UITextView`가 아니라 `UITextField.attributedPlaceholder`, `UIButton.Configuration.attributedTitle`처럼 attributes를 직접 다뤄야 하는 곳에서 사용합니다. 세 `setTypography`도 내부적으로 이 메서드를 호출하므로 `paragraphStyle` 클로저는 한 곳에서 처리됩니다.

`paragraphStyle` 클로저는 MDS가 만든 `NSMutableParagraphStyle`을 넘겨받아 `lineBreakMode` 등 문단 속성을 추가로 지정할 때 씁니다. 행간(`minimumLineHeight`, `maximumLineHeight`, `lineSpacing`, `lineHeightMultiple`)은 `lineHeight`가 정하는 값이므로 바꾸지 마세요.

```swift
// placeholder
textField.attributedPlaceholder = NSAttributedString(
    string: "검색어를 입력하세요",
    attributes: Typography.body1.attributedStringAttributes(
        foregroundColor: SemanticColor.Fg.Neutral.ghost
    )
)

// 버튼 타이틀 + 말줄임
var config = UIButton.Configuration.plain()
config.attributedTitle = AttributedString(NSAttributedString(
    string: "확인",
    attributes: Typography.label2.attributedStringAttributes(foregroundColor: .white) {
        $0.lineBreakMode = .byTruncatingTail
    }
))
```

## setTypography

`UILabel`, `UITextField`, `UITextView` 세 타입에 각각 구현되어 있으며, 공통 시그니처는 다음과 같습니다.

```swift
public func setTypography(
    _ style: MDSFont,
    textColor: UIColor? = nil,
    paragraphStyle configure: ((NSMutableParagraphStyle) -> Void)? = nil
)
```

`setTypography`가 직접 적용하는 것은 MDS 토큰인 **색상**(`textColor`)과 **타이포그래피**(`MDSFont`의 폰트·자간·행간)입니다. `textColor`를 생략하면 현재 값을, alignment는 현재 `textAlignment`를 그대로 유지하므로 정렬은 `setTypography`를 부르기 전에 `textAlignment`로 설정하세요. 그 외 문단 속성은 `paragraphStyle` 클로저로 지정합니다. 클로저는 MDS가 만든 paragraph style을 넘겨받아 `lineBreakMode` 등을 추가로 지정할 때 쓰며, 행간(`minimumLineHeight`, `maximumLineHeight`, `lineSpacing`, `lineHeightMultiple`)은 `style.lineHeight`가 정하는 값이므로 바꾸지 마세요. `UILabel`의 말줄임(`.byTruncatingTail`) 등은 `label.lineBreakMode`로도 지정할 수 있지만 호출 순서의 영향을 받으므로(아래 '말줄임 설정 순서' 참고) 순서와 상관없이 적용되는 이 클로저를 권장합니다. 내부적으로 어디에 값을 반영하는지는 타입마다 다르며, 이 차이가 재호출 시점을 결정합니다.

| 타입 | 반영 대상 | 재호출이 필요한 시점 |
|---|---|---|
| `UILabel` | `attributedText`를 통째로 새로 생성 | `text`가 바뀔 때마다 |
| `UITextField` | `defaultTextAttributes` (커서 높이·입력 텍스트에 적용) | 보통 최초 1회로 충분 |
| `UITextView` | `typingAttributes` + 기존 `text`가 있으면 `attributedText`도 함께 교체 | `text`를 코드로 교체했을 때 |

`UITextView`는 `attributedText`를 교체하면 `selectedRange`(커서/선택 영역)가 초기화되는 UIKit 특성이 있어, 내부적으로 교체 전 `selectedRange`를 저장했다가 복원합니다 — 편집 중 사용자가 보는 커서 위치가 튀지 않습니다.

```swift
label.setTypography(Typography.heading1)
textField.setTypography(Typography.body1, textColor: SemanticColor.Fg.Neutral.bold)
textView.textAlignment = .left
textView.setTypography(Typography.body1)
```

### `paragraphStyle` 클로저

`lineBreakMode` 등 문단 속성은 클로저로 지정합니다. `UILabel`, `UITextField`, `UITextView`에 공통이며, 생략하면 기존 동작 그대로입니다.

```swift
// 한 줄 라벨 말줄임 (호출 순서와 재호출에 상관없이 적용)
label.numberOfLines = 1
label.setTypography(Typography.label2, textColor: SemanticColor.Fg.Neutral.bold) {
    $0.lineBreakMode = .byTruncatingTail
}

// 한글 단어 단위 줄바꿈
label.numberOfLines = 0
label.setTypography(Typography.body1) { $0.lineBreakStrategy = .hangulWordPriority }

// UITextView: 문단 간격
textView.setTypography(Typography.body1) { $0.paragraphSpacing = 8 }
```

### 말줄임(`lineBreakMode`) 설정 순서

`UILabel`의 `setTypography`는 `attributedText`를 통째로 새로 만들기 때문에 `label.lineBreakMode`는 호출 순서에 영향을 받습니다.

- `setTypography` **전**에 설정한 값은 새 `attributedText`에 덮여서 적용되지 않습니다.
- `setTypography` **후**에 설정하면 적용되지만, `setTypography`를 다시 호출하면(예: `text` 변경 후) 사라지므로 매번 다시 설정해야 합니다.
- `paragraphStyle` 클로저는 순서와 재호출에 상관없이 항상 적용되므로 권장합니다.

```swift
// 적용되지 않음: setTypography가 attributedText를 새로 만들면서 덮어씀
label.lineBreakMode = .byTruncatingTail
label.setTypography(Typography.label2)

// 적용됨: 단, setTypography를 다시 부르면 사라지므로 그때마다 다시 설정해야 함
label.setTypography(Typography.label2)
label.lineBreakMode = .byTruncatingTail

// 권장: 순서와 재호출에 상관없이 적용됨
label.setTypography(Typography.label2) { $0.lineBreakMode = .byTruncatingTail }
```

### `alignment:` 파라미터는 deprecated

이전에는 `setTypography(_:textColor:alignment:)`로 정렬을 넘길 수 있었습니다. 이 시그니처는 **deprecated**이며 다음 major 버전에서 제거될 예정입니다. 호출하면 컴파일 경고가 나며, 동작은 이전과 같습니다.

```swift
// Before (deprecated)
label.setTypography(Typography.body1, alignment: .center)

// After
label.textAlignment = .center
label.setTypography(Typography.body1)
```

## setIcon

`UIImageView`에 `MDSIcon`을 적용하는 어댑터입니다. **`internal`로 선언되어 있어 MDS 모듈 밖에서는 호출할 수 없고**, `MDSActionButton` 등 컴포넌트 구현 내부에서만 사용됩니다.

```swift
// MDS 컴포넌트 내부에서만 호출 가능 (컨슈머 앱에서는 컴파일되지 않음)
func setIcon(_ icon: MDSIcon?, tint: MDSIcon.Tint = .automatic, tintColor: UIColor)
```

컨슈머 앱에서 동일한 효과를 내려면 [아이콘 가이드](icons.md#사용법)에 나온 대로 `MDSIcon.image`에 `withRenderingMode`와 `tintColor`를 직접 적용하세요.
