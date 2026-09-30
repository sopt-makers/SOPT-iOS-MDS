//
//  UITextField+Typography.swift
//  MDS
//

import UIKit

extension UITextField {
    /// `style`의 font, lineHeight, letterSpacing을 defaultTextAttributes에 반영합니다.
    /// 커서 높이와 입력 텍스트가 style.lineHeight를 따르게 되며, textColor는 생략 시 현재 값을, alignment는 현재 textAlignment를 유지합니다.
    public func setTypography(
        _ style: MDSFont,
        textColor: UIColor? = nil
    ) {
        applyTypography(style, textColor: textColor, alignment: textAlignment)
    }

    @available(*, deprecated, message: "alignment 파라미터는 제거될 예정입니다. textField.textAlignment를 설정한 뒤 호출하세요.")
    public func setTypography(
        _ style: MDSFont,
        textColor: UIColor? = nil,
        alignment: NSTextAlignment?
    ) {
        applyTypography(style, textColor: textColor, alignment: alignment ?? textAlignment)
    }

    private func applyTypography(
        _ style: MDSFont,
        textColor: UIColor?,
        alignment: NSTextAlignment
    ) {
        let resolvedColor = textColor ?? self.textColor ?? .label
        self.textColor = resolvedColor
        defaultTextAttributes = style.attributedStringAttributes(
            foregroundColor: resolvedColor,
            alignment: alignment
        )
    }
}
