//
//  TypographyTokenItem.swift
//  MDSStoryBook
//
//  Created by 강윤서 on 5/8/26.
//

import UIKit
import MDS

struct TypographyTokenItem {
    let name: String
    let mdsFont: MDSFont
}

struct TypographyTokenSection {
    let title: String
    let items: [TypographyTokenItem]
}

extension MDSFont {
    var catalogDescription: String {
        // letterSpacing을 % 로 역산
        let letterSpacingPercent = font.pointSize > 0
            ? letterSpacing / font.pointSize * 100
            : 0
        let weightName = (font.fontDescriptor.object(forKey: .face) as? String)
            ?? font.fontName.components(separatedBy: "-").last
            ?? ""

        return String(
            format: "size: %.0fpx   weight: %@   lineHeight: %.0fpx\nletterSpacing: %.1f%%",
            font.pointSize,
            weightName,
            lineHeight,
            letterSpacingPercent
        )
    }
}
