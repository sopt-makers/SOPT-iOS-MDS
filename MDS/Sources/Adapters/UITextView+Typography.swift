//
//  UITextView+Typography.swift
//  MDS
//

import UIKit

extension UITextView {
    /// `style`의 font, lineHeight, letterSpacing을 typingAttributes와 기존 텍스트에 반영합니다.
    /// 커서 높이와 줄간격이 style.lineHeight를 따르게 되며, textColor는 생략 시 현재 값을, alignment는 현재 textAlignment를 유지합니다.
    /// 텍스트를 코드로 교체한 뒤에는 다시 호출해야 합니다.
    public func setTypography(
        _ style: MDSFont,
        textColor: UIColor? = nil
    ) {
        applyTypography(style, textColor: textColor, alignment: textAlignment)
    }

    @available(*, deprecated, message: "alignment 파라미터는 제거될 예정입니다. textView.textAlignment를 설정한 뒤 호출하세요.")
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
        let attributes = style.attributedStringAttributes(
            foregroundColor: resolvedColor,
            alignment: alignment
        )
        typingAttributes = attributes
        if let text, !text.isEmpty {
            // attributedText 교체는 커서/선택(selectedRange)을 초기화하므로 저장 후 복원한다.
            let selection = selectedRange
            attributedText = NSAttributedString(string: text, attributes: attributes)
            let length = (text as NSString).length
            let location = min(selection.location, length)
            selectedRange = NSRange(location: location, length: min(selection.length, length - location))
        }
    }
}
