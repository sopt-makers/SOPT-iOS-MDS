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
}
