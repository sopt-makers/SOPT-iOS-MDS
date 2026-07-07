//
//  UITextView+Typography.swift
//  MDS
//

import UIKit

extension UITextView {
    /// `style`의 font/lineHeight/letterSpacing을 typingAttributes와 기존 텍스트에 반영합니다.
    /// 커서 높이와 줄간격이 style.lineHeight를 따르게 됩니다.
    /// 텍스트를 코드로 교체한 뒤에는 다시 호출해야 합니다.
    public func setTypography(_ style: MDSFont, textColor: UIColor? = nil) {
        let attributes = style.attributedStringAttributes(
            foregroundColor: textColor ?? self.textColor ?? .label
        )
        typingAttributes = attributes
        if let text, !text.isEmpty {
            attributedText = NSAttributedString(string: text, attributes: attributes)
        }
    }
}
