//
//  MDSFont.swift
//  MDS
//

import UIKit

/// `@unchecked` Sendable conformance: UIFont는 불변 객체로서 Apple 문서에서 명시적으로
/// 다중 스레드 안전성을 보장하며, 모든 저장 프로퍼티(UIFont, CGFloat)는 불변입니다.
public struct MDSFont: @unchecked Sendable {
    public let font: UIFont
    public let lineHeight: CGFloat
    public let letterSpacing: CGFloat

    /// font, lineHeight, letterSpacing을 모두 반영한 NSAttributedString.Key 속성을 반환합니다.
    /// UILabel이 아닌 곳(UIButton.Configuration.attributedTitle 등)에서 typography를 적용할 때 사용합니다.
    public func attributedStringAttributes(
        foregroundColor: UIColor,
        alignment: NSTextAlignment = .natural
    ) -> [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        paragraphStyle.alignment = alignment

        return [
            .font: font,
            .kern: letterSpacing,
            .foregroundColor: foregroundColor,
            .paragraphStyle: paragraphStyle,
            .baselineOffset: (lineHeight - font.lineHeight) / 2
        ]
    }
}
