//
//  UILabel+Typography.swift
//  MDS
//

import UIKit

extension UILabel {
    /// `style`의 font/lineHeight/letterSpacing을 attributedText로 반영합니다.
    /// attributedText가 설정되면 이후 별도의 textColor 대입은 무시되므로, 색은 textColor 파라미터로 전달합니다.
    /// 호출 시 self.textColor도 함께 갱신되어 다음 호출에서 textColor를 생략하면 이 값이 fallback으로 쓰입니다.
    /// text/lineHeight/kerning은 호출할 때마다 새로 지정되는 값이라 text가 바뀔 때마다 다시 호출해야 합니다.
    public func setTypography(_ style: MDSFont, textColor: UIColor? = nil) {
        let resolvedColor = textColor ?? self.textColor ?? UIColor.label
        self.textColor = resolvedColor

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = style.lineHeight
        paragraphStyle.maximumLineHeight = style.lineHeight

        let attributes: [NSAttributedString.Key: Any] = [
            .font: style.font,
            .kern: style.letterSpacing,
            .foregroundColor: resolvedColor,
            .paragraphStyle: paragraphStyle,
            .baselineOffset: (style.lineHeight - style.font.lineHeight) / 2
        ]

        attributedText = NSAttributedString(string: text ?? "", attributes: attributes)
    }
}
