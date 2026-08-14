//
//  UITextField+Typography.swift
//  MDS
//

import UIKit

extension UITextField {
    /// `style`의 font/lineHeight/letterSpacing/alignment를 defaultTextAttributes에 반영합니다.
    /// 커서 높이와 입력 텍스트가 style.lineHeight를 따르게 되며, textColor/alignment는 생략 시 현재 값을 유지합니다.
    public func setTypography(
        _ style: MDSFont,
        textColor: UIColor? = nil,
        alignment: NSTextAlignment? = nil
    ) {
        let resolvedColor = textColor ?? self.textColor ?? .label
        self.textColor = resolvedColor
        defaultTextAttributes = style.attributedStringAttributes(
            foregroundColor: resolvedColor,
            alignment: alignment ?? textAlignment
        )
    }
}
