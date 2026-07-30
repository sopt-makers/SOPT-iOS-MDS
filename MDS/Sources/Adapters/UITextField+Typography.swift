//
//  UITextField+Typography.swift
//  MDS
//

import UIKit

extension UITextField {
    /// `style`의 font/lineHeight/letterSpacing을 defaultTextAttributes에 반영합니다.
    /// 커서 높이와 입력 텍스트가 style.lineHeight를 따르게 됩니다.
    public func setTypography(_ style: MDSFont, textColor: UIColor? = nil) {
        let resolvedColor = textColor ?? self.textColor ?? .label
        self.textColor = resolvedColor
        defaultTextAttributes = style.attributedStringAttributes(foregroundColor: resolvedColor)
    }
}
