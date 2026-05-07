//
//  FontLoader.swift
//  MDS
//
//  Created by 강윤서 on 5/3/26.
//

import CoreText
import Foundation

internal enum FontLoader {
    private static var isRegistered = false

    static func registerIfNeeded() {
        guard !isRegistered else { return }
        isRegistered = true

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
    }
}
