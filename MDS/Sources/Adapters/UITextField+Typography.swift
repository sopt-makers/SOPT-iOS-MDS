//
//  UITextField+Typography.swift
//  MDS
//

import UIKit

extension UITextField {
    /// `style`의 font, lineHeight, letterSpacing을 defaultTextAttributes에 반영합니다.
    /// textColor는 생략 시 현재 값을, alignment는 현재 textAlignment를 유지합니다.
    /// `paragraphStyle`로 문단 속성을 추가할 수 있습니다. (행간 속성은 바꾸지 마세요)
    public func setTypography(
        _ style: MDSFont,
        textColor: UIColor? = nil,
        paragraphStyle configure: ((NSMutableParagraphStyle) -> Void)? = nil
    ) {
        applyTypography(style, textColor: textColor, alignment: textAlignment, configure: configure)
    }

    @available(*, deprecated, message: "alignment 파라미터는 제거될 예정입니다. textField.textAlignment를 설정한 뒤 호출하세요.")
    public func setTypography(
        _ style: MDSFont,
        textColor: UIColor? = nil,
        alignment: NSTextAlignment?
    ) {
        applyTypography(style, textColor: textColor, alignment: alignment ?? textAlignment, configure: nil)
    }

    private func applyTypography(
        _ style: MDSFont,
        textColor: UIColor?,
        alignment: NSTextAlignment,
        configure: ((NSMutableParagraphStyle) -> Void)?
    ) {
        let resolvedColor = textColor ?? self.textColor ?? .label
        self.textColor = resolvedColor
        defaultTextAttributes = style.attributedStringAttributes(
            foregroundColor: resolvedColor,
            alignment: alignment,
            paragraphStyle: configure
        )
    }
}
