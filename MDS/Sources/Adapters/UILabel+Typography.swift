//
//  UILabel+Typography.swift
//  MDS
//

import UIKit

extension UILabel {
    /// `style`의 font, lineHeight, letterSpacing을 attributedText로 반영합니다.
    /// textColor를 생략하면 현재 textColor를, alignment는 현재 textAlignment를 그대로 유지합니다.
    /// `paragraphStyle`은 만들어진 paragraph style을 넘겨받아 lineBreakMode 등을 추가로 지정할 때 씁니다.
    /// `label.lineBreakMode`는 이 호출 전에 설정하면 덮이고, 호출 후에 설정하면 다음 호출 때까지만 유지됩니다.
    /// 말줄임(`.byTruncatingTail`) 등은 순서와 재호출에 상관없이 적용되는 이 클로저로 지정하는 것을 권장합니다.
    /// attributedText를 통째로 새로 만드는 방식이라 text가 바뀌면 다시 호출해야 합니다.
    public func setTypography(
        _ style: MDSFont,
        textColor: UIColor? = nil,
        paragraphStyle configure: ((NSMutableParagraphStyle) -> Void)? = nil
    ) {
        applyTypography(style, textColor: textColor, alignment: textAlignment, configure: configure)
    }

    @available(*, deprecated, message: "alignment 파라미터는 제거될 예정입니다. label.textAlignment를 설정한 뒤 호출하거나 paragraphStyle 클로저에서 지정하세요.")
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
        let resolvedColor = textColor ?? self.textColor ?? UIColor.label
        self.textColor = resolvedColor

        let attributes = style.attributedStringAttributes(
            foregroundColor: resolvedColor,
            alignment: alignment,
            paragraphStyle: configure
        )

        attributedText = NSAttributedString(string: text ?? "", attributes: attributes)
    }
}
