//
//  UILabel+Typography.swift
//  MDS
//

import UIKit

extension UILabel {
    /// `style`의 font/lineHeight/letterSpacing을 attributedText로 반영합니다.
    /// attributedText가 설정되면 UILabel.textColor는 무시되므로, textColor를 명시적으로 전달하거나
    /// 호출 전에 self.textColor를 먼저 설정해야 합니다. text가 바뀔 때마다 다시 호출해야 합니다.
    public func setTypography(_ style: MDSFont, textColor: UIColor? = nil) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = style.lineHeight
        paragraphStyle.maximumLineHeight = style.lineHeight

        let attributes: [NSAttributedString.Key: Any] = [
            .font: style.font,
            .kern: style.letterSpacing,
            .foregroundColor: textColor ?? self.textColor ?? UIColor.label,
            .paragraphStyle: paragraphStyle,
            .baselineOffset: (style.lineHeight - style.font.lineHeight) / 2
        ]

        attributedText = NSAttributedString(string: text ?? "", attributes: attributes)
    }
}
