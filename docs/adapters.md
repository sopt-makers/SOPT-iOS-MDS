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
        alignment: NSTextAlignment = .natural
    ) -> [NSAttributedString.Key: Any]
}
```

`attributedStringAttributes(foregroundColor:alignment:)`는 font/lineHeight/letterSpacing을 `NSAttributedString.Key` 딕셔너리로 변환합니다. `UILabel`처럼 아래 `setTypography`가 있는 타입이 아니라 `UIButton.Configuration.attributedTitle` 등 attributes를 직접 다뤄야 하는 곳에서 사용합니다.

## setTypography

`UILabel`, `UITextField`, `UITextView` 세 타입에 각각 구현되어 있으며, 시그니처는 동일합니다.

```swift
public func setTypography(
    _ style: MDSFont,
    textColor: UIColor? = nil,
    alignment: NSTextAlignment? = nil
)
```

`textColor`/`alignment`를 생략하면 현재 값을 그대로 유지합니다. 내부적으로 어디에 값을 반영하는지는 타입마다 다르며, 이 차이가 재호출 시점을 결정합니다.

| 타입 | 반영 대상 | 재호출이 필요한 시점 |
|---|---|---|
| `UILabel` | `attributedText`를 통째로 새로 생성 | `text`가 바뀔 때마다 |
| `UITextField` | `defaultTextAttributes` (커서 높이·입력 텍스트에 적용) | 보통 최초 1회로 충분 |
| `UITextView` | `typingAttributes` + 기존 `text`가 있으면 `attributedText`도 함께 교체 | `text`를 코드로 교체했을 때 |

`UITextView`는 `attributedText`를 교체하면 `selectedRange`(커서/선택 영역)가 초기화되는 UIKit 특성이 있어, 내부적으로 교체 전 `selectedRange`를 저장했다가 복원합니다 — 편집 중 사용자가 보는 커서 위치가 튀지 않습니다.

```swift
label.setTypography(Typography.heading1)
textField.setTypography(Typography.body1, textColor: SemanticColor.Fg.Neutral.bold)
textView.setTypography(Typography.body1, alignment: .left)
```

## setIcon

`UIImageView`에 `MDSIcon`을 적용하는 어댑터입니다. **`internal`로 선언되어 있어 MDS 모듈 밖에서는 호출할 수 없고**, `MDSActionButton` 등 컴포넌트 구현 내부에서만 사용됩니다.

```swift
// MDS 컴포넌트 내부에서만 호출 가능 (컨슈머 앱에서는 컴파일되지 않음)
func setIcon(_ icon: MDSIcon?, tint: MDSIcon.Tint = .automatic, tintColor: UIColor)
```

컨슈머 앱에서 동일한 효과를 내려면 [아이콘 가이드](icons.md#사용법)에 나온 대로 `MDSIcon.image`에 `withRenderingMode`와 `tintColor`를 직접 적용하세요.
