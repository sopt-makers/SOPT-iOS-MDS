//
//  UILabel+Typography.swift
//  MDS
//

import UIKit

extension UILabel {
    /// `style`의 font, lineHeight, letterSpacing, alignment를 attributedText로 반영합니다.
    /// textColor, alignment를 생략하면 현재 textColor, textAlignment를 그대로 유지합니다.
    /// attributedText를 통째로 새로 만드는 방식이라 text가 바뀌면 다시 호출해야 합니다.
    public func setTypography(
        _ style: MDSFont,
        textColor: UIColor? = nil,
        alignment: NSTextAlignment? = nil
    ) {
        let resolvedColor = textColor ?? self.textColor ?? UIColor.label
        self.textColor = resolvedColor

        attributedText = NSAttributedString(
            string: text ?? "",
            attributes: style.attributedStringAttributes(
                foregroundColor: resolvedColor,
                alignment: alignment ?? textAlignment
            )
        )
    }
}
