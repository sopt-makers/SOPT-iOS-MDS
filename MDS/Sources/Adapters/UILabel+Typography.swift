//
//  UILabel+Typography.swift
//  MDS
//

import UIKit

extension UILabel {
    /// `style`의 font, lineHeight, letterSpacing, alignment를 attributedText로 반영합니다.
    /// textColor, alignment를 생략하면 현재 textColor, textAlignment를 그대로 유지합니다.
    /// `paragraphStyle`은 만들어진 paragraph style을 넘겨받아 lineBreakMode 등을 추가로 지정할 때 씁니다.
    /// attributedText의 paragraph style이 `label.lineBreakMode`보다 우선하므로, 말줄임(`.byTruncatingTail`) 등은
    /// `label.lineBreakMode`가 아니라 이 클로저에서 지정해야 적용됩니다.
    /// attributedText를 통째로 새로 만드는 방식이라 text가 바뀌면 다시 호출해야 합니다.
    public func setTypography(
        _ style: MDSFont,
        textColor: UIColor? = nil,
        alignment: NSTextAlignment? = nil,
        paragraphStyle configure: ((NSMutableParagraphStyle) -> Void)? = nil
    ) {
        let resolvedColor = textColor ?? self.textColor ?? UIColor.label
        self.textColor = resolvedColor

        let attributes = style.attributedStringAttributes(
            foregroundColor: resolvedColor,
            alignment: alignment ?? textAlignment
        )
        if let configure, let paragraphStyle = attributes[.paragraphStyle] as? NSMutableParagraphStyle {
            configure(paragraphStyle)
        }

        attributedText = NSAttributedString(string: text ?? "", attributes: attributes)
    }
}
