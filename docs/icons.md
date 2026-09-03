# 아이콘 가이드

MDS는 `Icon.xcassets`에 등록된 SVG 벡터 아이콘을 `MDSIcon` enum으로 타입 세이프하게 노출합니다.

## 구조

```text
icon.{name}.{style}
```

- `name`: 아이콘 의미 (예: `alarm`, `arrowDown`, `checkCircle`)
- `style`: `filled` / `outlined` 중 하나. 브랜드 로고(`apple`, `github`, `googleColor` 등)처럼 스타일이 하나뿐인 아이콘도 있습니다.

현재 총 159개 아이콘, `filled`/`outlined` 조합으로 255개의 asset이 `MDS/Sources/Foundation/Resources/Icons/Icon.xcassets`에 존재합니다. 전체 목록과 실제 값은 [`MDSIcon.swift`](../MDS/Sources/Tokens/MDSIcon.swift)가 SSOT이며, 앱 안에서는 MDSStoryBook 카탈로그(Icon 탭)에서 시각적으로 확인할 수 있습니다.

카테고리 예시:

| 분류 | 예시 |
|---|---|
| 화살표/방향 | `arrowUp`, `arrowDownLeft`, `chevronRight`, `flipBackward` |
| 알림/시간 | `alarm`, `alarmCheck`, `bell`, `bellActive`, `clock`, `clockSnooze` |
| 파일/이미지 | `file`, `fileDownload`, `folder`, `image`, `imagePlus` |
| 커뮤니케이션 | `message`, `messageChat`, `mail`, `send`, `share` |
| 사용자/계정 | `user`, `userCheck`, `users`, `usersPlus`, `lock`, `unlock` |
| 편집/텍스트 | `edit`, `bold`, `italic`, `underline`, `alignCenter`, `letterSpacing` |
| 상태/피드백 | `checkCircle`, `alertTriangle`, `infoCircle`, `xCircle` |
| 소셜/브랜드 | `apple`, `github`, `googleColor`, `googleMono`, `kakao`, `instagram`, `linkedin`, `behance` |

## 사용법

`MDSIcon`으로 이미지를 직접 얻어 사용합니다.

```swift
imageView.image = MDSIcon.checkCircleFilled.image
```

tint 적용이 필요하면 `withRenderingMode(.alwaysTemplate)`으로 template 렌더링한 뒤 `tintColor`를 지정합니다.

```swift
imageView.image = MDSIcon.bellFilled.image.withRenderingMode(.alwaysTemplate)
imageView.tintColor = SemanticColor.Fg.Neutral.default
```

> `UIImageView.setIcon(_:tint:tintColor:)`는 MDS 컴포넌트 내부 구현에서 위 패턴을 감싼 `internal` 어댑터로, MDS 모듈 밖(컨슈머 앱)에서는 호출할 수 없습니다. 자세한 내용은 [어댑터 가이드](adapters.md#seticon)를 참고하세요.

### Tint 종류

```swift
public extension MDSIcon {
    enum Tint {
        case automatic  // 컴포넌트의 foreground 색을 따라감 (template 렌더링)
        case original   // asset 원본 색상 유지 (renderingMode: .alwaysOriginal)
    }
}
```

- `.automatic`: 대부분의 UI 아이콘에 사용. `SemanticColor` 기반 foreground를 그대로 입힙니다.
- `.original`: 브랜드/멀티컬러 아이콘(`googleColor` 등)처럼 원본 색상을 유지해야 할 때 사용합니다.

## 새 아이콘 추가하기

아이콘은 Figma → 토큰 파이프라인이 아닌 **직접 asset 추가** 방식입니다.

1. `Icon.xcassets`에 `icon.{name}.{style}.imageset`을 추가하고 SVG를 넣습니다.
2. `MDS/Sources/Tokens/MDSIcon.swift`의 `MDSIcon` enum에 `case`를 추가합니다 (`rawValue`는 asset 이름과 동일해야 합니다).
3. 필요 시 `IconTokenDataSource`(`MDSStoryBook/MDSStoryBook/Token/Icon`)는 `MDSIcon.allCases`를 그대로 사용하므로 카탈로그에 자동 반영됩니다.
