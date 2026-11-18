//
//  MDSFont+SwiftUI.swift
//  MDS
//
//  Created by 이나연 on 11/16/26.
//

import SwiftUI

public extension MDSFont {
    var lineSpacing: CGFloat { max(lineHeight - font.lineHeight, 0) }
}

private struct MDSTypographyModifier: ViewModifier {
    let style: MDSFont

    func body(content: Content) -> some View {
        content
            .font(Font(style.font))
            .kerning(style.letterSpacing)
            // lineSpacing은 줄 사이에만 들어가서 첫 줄 위/마지막 줄 아래에는 간격이 없다.
            // 위아래에 절반씩 padding을 더해 모든 줄이 lineHeight를 갖고 글자가 줄 중앙에 오게 한다.
            .lineSpacing(style.lineSpacing)
            .padding(.vertical, style.lineSpacing / 2)
    }
}

public extension View {
    func typography(_ style: MDSFont) -> some View {
        modifier(MDSTypographyModifier(style: style))
    }
}
