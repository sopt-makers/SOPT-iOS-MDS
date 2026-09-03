# MDS — Makers Design System

SOPT Makers의 iOS 디자인 시스템 라이브러리입니다.
Style Dictionary 기반으로 디자인 토큰을 Swift 코드로 자동 변환하며, Swift 6 strict concurrency를 완전 지원합니다.

## 요구사항

- iOS 16+
- Swift 6

## 설치

Xcode → File → Add Package Dependencies에서 아래 URL을 입력합니다.

```
https://github.com/sopt-makers/SOPT-iOS-MDS
```

## 시작하기

앱 시작 시점에 SUIT 폰트를 한 번 등록합니다.

```swift
// AppDelegate 또는 @main
@MainActor
func application(_ application: UIApplication,
                 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FontLoader.registerIfNeeded()
    return true
}
```

## 사용법

### Typography

`UILabel.setTypography(_:)`를 사용하면 font, lineHeight, letterSpacing이 한 번에 적용됩니다.

```swift
label.setTypography(Typography.heading1)
label.setTypography(Typography.body2)
```

`UITextField`, `UITextView`에도 동일한 시그니처의 `setTypography`가 있습니다. 타입별 반영 방식 차이는 [어댑터 가이드](docs/adapters.md)를 참고하세요.

### SemanticColor

```swift
view.backgroundColor = SemanticColor.Bg.Neutral.default
label.textColor = SemanticColor.Fg.Neutral.default
view.layer.borderColor = SemanticColor.Stroke.Brand.default.cgColor
```

hover, pressed, disabled 등 상태값이 있는 토큰은 중첩 enum으로 접근합니다.

```swift
button.backgroundColor = SemanticColor.Bg.Secondary.Default.hover
button.backgroundColor = SemanticColor.Bg.Danger.Default.pressed
```

### Components

버튼, 인풋, 다이얼로그 등 UIKit 컴포넌트를 제공합니다. 아이콘은 `MDSIcon` enum으로 타입 세이프하게 전달합니다.

```swift
let button = MDSActionButton(variant: .primary, size: .large, title: "확인", suffixIcon: .arrowRightOutlined)
let field = MDSTextField(placeholder: "이메일을 입력하세요", label: "이메일", isRequired: true)
```

전체 컴포넌트 목록과 API는 [컴포넌트 가이드](docs/components.md), 아이콘 목록과 사용법은 [아이콘 가이드](docs/icons.md)를 참고하세요.

## 토큰 구조

토큰은 Base와 Semantic 두 레이어로 구성됩니다.

| 레이어 | 접근 | 예시 | 역할 |
|--------|------|------|------|
| Base | `internal` | `BaseColor.gray600` | 원시값 정의. 외부에서 직접 사용 불가 |
| Semantic | `public` | `SemanticColor.Bg.Neutral.default` | 의미 기반 사용 API |

Semantic 토큰은 항상 Base 토큰을 참조합니다. 디자이너가 Figma에서 토큰을 수정하면 JSON → Swift 변환이 자동으로 이루어집니다.

## 의사결정 기록

### Base 레이어에 prefix를 붙인 이유

디자이너가 정의한 토큰 위계는 `Typography.size.16`이지만, Swift에서 숫자는 식별자의 시작이 될 수 없어 그대로 사용할 수 없습니다. 카테고리명을 반복해 `Typography.size.size16`으로 해결할 수도 있지만 위계 정보가 두 번 중복됩니다. Seed Design, TDS 등을 참고해 Base prefix를 붙이는 방식으로 중복 없이 해결했습니다.

반면 Semantic 토큰(`Typography.heading1`, `SemanticColor.Bg.Neutral.default`)은 그 자체가 디자인 요소명으로서 의미를 담고 있어 prefix가 불필요합니다.

또한 Base 레이어는 `internal`로, Semantic 레이어는 `public`으로 접근을 제한해 네이밍과 접근제어가 같은 의도를 표현합니다.

### Storybook을 사용하지 않은 이유

iOS 앱 디자인 시스템을 웹 브라우저에서 확인하는 것은 실제 사용 맥락(네이티브 앱)과 달라 컴포넌트의 실제 동작을 정확히 검증하기 어렵다고 판단했습니다. iOS 생태계에서 Storybook은 웹만큼 성숙하지 않아 별도 앱 타겟을 유지하는 비용도 큽니다. 대신 xcodebuild CI 검증으로 빌드 안전성을 확보했습니다.

### Style Dictionary를 도입한 이유

디자인 토큰을 JSON으로 단일 정의(SSOT)하면 웹, Android, iOS 모두가 동일한 소스에서 각 플랫폼에 맞게 코드를 자동 생성할 수 있습니다. Figma 변경이 생겼을 때 수동 변환 과정 없이 반영되어 휴먼 에러를 제거합니다.

### Swift 6 strict concurrency 대응

| 타입 | 선택 | 이유 |
|------|------|------|
| `MDSFont` | `@unchecked Sendable` | `UIFont`는 class 타입이라 컴파일러가 Sendable을 자동 증명할 수 없음. 모든 프로퍼티가 `let`이고 생성 후 불변이므로 개발자가 직접 보장 |
| `FontLoader` | `@MainActor` | `isRegistered`가 mutable static var. `registerIfNeeded()`는 UIKit 초기화(메인 스레드)에서만 호출되므로 `@MainActor` 격리가 의미적으로 적합 |

`MDSFont`에 `@MainActor`가 아닌 `@unchecked Sendable`을 선택한 이유: `MDSFont`는 폰트 명세를 담는 데이터 타입으로 `CGSize`, `UIEdgeInsets`에 가깝습니다. UI를 직접 건드리는 타입이 아니므로 메인 스레드에 귀속시키지 않고 어느 스레드에서든 자유롭게 참조할 수 있도록 설계했습니다.

## 워크플로우

### 자동화가 필요했던 이유

1. 토큰을 수정할 때마다 Style Dictionary를 수동으로 실행해 각 플랫폼 코드로 변환해야 해 번거로움
2. Token Studio 무료 플랜은 기간 제한이 있어 장기 운영이 불가 → Figma 플러그인에서 JSON 추출까지 자동화 필요

### 목표 구조

```
Figma 플러그인
    ├── 토큰 등록 (Base / Semantic 분류, 토큰 간 참조)
    └── JSON으로 변환 → 서버로 전송
          ↓
    서버에서 JSON 수신
    → GitHub API로 브랜치 생성 + PR 자동 오픈
          ↓
    개발자 PR 리뷰 & 머지
          ↓
    GitHub Actions 실행
    ├── Style Dictionary: JSON → 각 플랫폼 코드 자동 변환
    └── 패키지 재배포
          ↓
    Slack 알림
```

### 현재 구조 (서버 연동 전)

```
tokens/ JSON 수정 후 token-sync 브랜치에 push
    ↓
GitHub Actions 실행
    ├── Style Dictionary: JSON → Swift 파일 자동 생성
    ├── xcodebuild: iOS Simulator 빌드 검증
    └── 변경된 Swift 파일 커밋 + default로 PR 생성
    ↓
PR 리뷰 & 머지 → 태그 → SPM 배포
```

> **향후 계획:** Figma 서버 연동 시 `repository_dispatch` 이벤트로 전환 예정.
> 토큰 변경이 감지될 때만 `token-sync/날짜` 에페머럴 브랜치를 생성해
> 장기 브랜치의 rebase 비용을 제거합니다.

파이프라인 각 단계(빌드 대상 파일, 토큰 diff 생성, 자동 커밋/PR 규칙)에 대한 자세한 내용은 [자동화 가이드](docs/automation.md)를 참고하세요.

## 상세 문서

- [토큰 가이드](docs/tokens.md) — 토큰 구조, 네이밍 컨벤션, Base/Semantic 설계 이유
- [컴포넌트 가이드](docs/components.md) — 컴포넌트별 public API와 사용 예시
- [아이콘 가이드](docs/icons.md) — 아이콘 네이밍 컨벤션, `MDSIcon` 사용법, 아이콘 추가 절차
- [어댑터 가이드](docs/adapters.md) — `MDSFont`, `UILabel`/`UITextField`/`UITextView`의 `setTypography`, `UIImageView.setIcon`
- [자동화 가이드](docs/automation.md) — 디자인 토큰 파이프라인(Style Dictionary + GitHub Actions) 상세
- [Makers Design System 웹](https://makers-design-system-2-0-web.vercel.app/) (외부) — SOPT Makers 디자인 시스템 웹 사이트
