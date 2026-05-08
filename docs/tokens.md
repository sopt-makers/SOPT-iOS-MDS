# 토큰 가이드

## 토큰이란?

**디자인 의사결정**을 이름 있는 변수로 **코드화**한 것으로, 디자이너와 개발자가 동일한 기준으로 소통하기 위한 공통 언어입니다.

- 디자인과 구현 사이의 기준을 일치시켜 의도한 결과가 동일하게 구현되도록 합니다.
- 값을 직접 쓰지 않고 참조 구조(Base → Semantic)로 관리해 스타일 변경을 일관되게 적용할 수 있습니다.
- 디자이너와 개발자가 같은 이름으로 소통해 커뮤니케이션 오차를 줄입니다.

## 구조

토큰은 **Base → Semantic** 두 계층으로 구성됩니다.

| 레이어 | 접근 | 역할 |
|--------|------|------|
| Base | `internal` | 원시값 정의. 직접 사용 불가 (spacing 제외) |
| Semantic | `public` | 사용 목적과 맥락을 담은 실사용 API |

**Semantic 토큰만 직접 참조(사용)할 수 있습니다.** 예외적으로 spacing은 Base 토큰 사용이 가능합니다.

- Semantic 토큰은 사용 목적을 이름에 담고 있어 일관된 스타일을 유지할 수 있습니다.
- Base 토큰은 원시값에 단순 이름만 붙인 것이라 값이 변경될 때 영향 범위를 추적하기 어렵습니다.
- Spacing은 다양한 해상도 환경에 유연하게 대응해야 하고 적용 맥락이 광범위해, 의미보다 수치 기반 시스템으로 범용성을 확보합니다.

---

## Color

### Base token

서비스에서 활용할 수 있는 원시 색상 값을 정의합니다.

```
color.base.{palette}{level}
```

| Base token | Raw value |
|------------|-----------|
| color.base.gray0 | #FFFFFF |
| color.base.orange400 | #F77234 |

### Semantic token

UI에 직접 사용되는 의미 기반 색상입니다.

```
color.{target}.{role}.{emphasis}.{state}
```

| 레벨 | 설명 | 값 |
|------|------|-----|
| target | 적용 대상 | `bg` / `fg` / `stroke` |
| role | 의미 역할 | `brand` / `secondary` / `neutral` / `success` / `attention` / `danger` / `information` / `dim` |
| emphasis | 강조 수준 | `bold` / `default` / `subtle` / `ghost` / `inverse` |
| state | 상태 (선택) | `hover` / `pressed` / `focused` / `disabled` |

**state만 선택적으로 사용할 수 있으며, 나머지 레벨은 모두 필수입니다.**

#### target

- `bg`: 컴포넌트나 페이지의 면을 채우는 배경색
- `fg`: 배경 위에 올라가는 텍스트, 아이콘 색상
- `stroke`: 보더, 구분선 등 외곽선 색상

#### role

- `brand`: 서비스 아이덴티티를 나타내는 브랜드 색상
- `secondary`: 브랜드 다음 위계의 색상
- `neutral`: 일반 정보나 UI 전반에 사용되는 무채색
- `success`: 완료, 긍정적인 결과를 나타내는 색상
- `attention`: 주의, 경고 등 사용자 확인이 필요한 정보
- `danger`: 경고, 삭제 등 위험도가 높은 상태
- `information`: 안내, 팁 등 정보성 맥락
- `dim`: modal 뒤에 깔리는 오버레이

#### emphasis

- `bold`: 가장 높은 대비, 강한 시선 집중
- `default` → `subtle` → `ghost` 순으로 강도 감소
- `inverse`: 배경색과 반전된 색상

| Base token | Semantic token | Raw value |
|------------|---------------|-----------|
| color.base.orange400 | color.bg.brand.default | #F77234 |

---

## Typography

### Base token

weight, size, lineHeight, letterSpacing을 각각 분리 관리합니다.

#### weight

```
typography.base.weight.{level}
```

| Base token | Raw value |
|------------|-----------|
| typography.base.weight.bold | 700 |
| typography.base.weight.semibold | 600 |
| typography.base.weight.regular | 400 |

#### size

```
typography.base.size.t{level}
```

| Base token | Raw value |
|------------|-----------|
| typography.base.size.t12 | 12px |
| typography.base.size.t16 | 16px |

#### lineHeight

```
typography.base.lineHeight.t{level}
```

| Base token | Raw value |
|------------|-----------|
| typography.base.lineHeight.t16 | 16px |
| typography.base.lineHeight.t24 | 24px |

#### letterSpacing

```
typography.base.letterSpacing.{level}
```

| Base token | Raw value |
|------------|-----------|
| typography.base.letterSpacing.wide | -1.5% |
| typography.base.letterSpacing.default | -2.0% |

> weight와 letterSpacing은 수치 대신 의미 기반 이름(bold, wide 등)을 사용합니다. 수치 자체보다 상대적인 역할과 사용 의도를 더 직관적으로 전달하기 위함입니다.

### Semantic token

Base 토큰의 weight, size, lineHeight, letterSpacing을 묶어 하나의 텍스트 스타일로 정의합니다.

```
typography.{role}{level}
```

- `heading`: 페이지의 핵심 제목
- `title`: 섹션이나 컴포넌트의 제목
- `body`: 본문 텍스트
- `label`: 버튼, 태그, 입력 필드 등 UI 요소에 부착되는 짧은 텍스트

level은 동일 role 안에서의 시각적 위계를 의미하며, 숫자가 작을수록 더 높은 강조 수준입니다.

| Semantic token | Base token | Raw value |
|----------------|------------|-----------|
| typography.heading1 | typography.base.weight.bold | 700 |
| | typography.base.size.t32 | 32px |
| | typography.base.lineHeight.t48 | 48px |
| | typography.base.letterSpacing.default | -2% |

---

## Spacing

### Base token

여백과 간격 값을 수치 기반으로 체계화합니다.

```
spacing.base.size.s{level}
```

| Base token | Raw value |
|------------|-----------|
| spacing.base.size.s0 | 0px |
| spacing.base.size.s8 | 8px |
| spacing.base.size.s16 | 16px |

**토큰 외 임의 수치(13px, 22px 등)는 사용하지 않습니다.** 디바이스 환경, 요소 간 관계, 시각적 위계를 기준으로 값을 선택합니다.

- 같은 그룹 내 인접 요소 → 작은 값
- 컴포넌트 내부 패딩 → 중간 값
- 섹션 간 구분, 레이아웃 여백 → 큰 값

Spacing은 별도의 Semantic 토큰 없이 Base 토큰을 직접 참조합니다.

---

## 네이밍 컨벤션 정리

| 구분 | 패턴 | 예시 |
|------|------|------|
| Base Color | `color.base.{palette}{level}` | `color.base.orange400` |
| Semantic Color | `color.{target}.{role}.{emphasis}.{state}` | `color.bg.brand.default` |
| Base Typography | `typography.base.{category}.{level}` | `typography.base.size.t16` |
| Semantic Typography | `typography.{role}{level}` | `typography.heading1` |
| Base Spacing | `spacing.base.size.s{level}` | `spacing.base.size.s8` |
