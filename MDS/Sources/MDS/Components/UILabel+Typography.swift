//
//  UILabel+Typography.swift
//  MDS
//

import UIKit

extension UILabel {
    public func setTypography(_ style: MDSFont) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = style.lineHeight
        paragraphStyle.maximumLineHeight = style.lineHeight

        let attributes: [NSAttributedString.Key: Any] = [
            .font: style.font,
            .kern: style.letterSpacing,
            .paragraphStyle: paragraphStyle,
            .baselineOffset: (style.lineHeight - style.font.lineHeight) / 4
        ]

        attributedText = NSAttributedString(string: text ?? "", attributes: attributes)
    }
}
