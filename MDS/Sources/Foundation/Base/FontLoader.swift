//
//  FontLoader.swift
//  MDS
//
//  Created by 강윤서 on 5/3/26.
//

import CoreText
import UIKit

internal enum FontLoader {
    private static let register: Void = {
        let fontNames = [
            "SUIT-Thin",
            "SUIT-ExtraLight",
            "SUIT-Light",
            "SUIT-Regular",
            "SUIT-Medium",
            "SUIT-SemiBold",
            "SUIT-Bold",
            "SUIT-ExtraBold",
            "SUIT-Heavy",
        ]

        fontNames.forEach { name in
            guard let url = Bundle.module.url(forResource: name, withExtension: "otf") else { return }
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }()

    static func font(name: String, size: CGFloat, fallbackWeight: UIFont.Weight) -> UIFont {
        _ = register
        return UIFont(name: name, size: size) ?? .systemFont(ofSize: size, weight: fallbackWeight)
    }
}
