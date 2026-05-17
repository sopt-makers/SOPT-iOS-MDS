//
//  SpacingTokenDataSource.swift
//  MDSStoryBook
//
//  Created by 강윤서 on 5/17/26.
//

import MDS
import Foundation

enum SpacingTokenDataSource {
    static let items: [(name: String, value: CGFloat)] = [
        ("s0",   BaseSpacing.Base.s0),   ("s2",   BaseSpacing.Base.s2),
        ("s4",   BaseSpacing.Base.s4),   ("s6",   BaseSpacing.Base.s6),
        ("s8",   BaseSpacing.Base.s8),   ("s10",  BaseSpacing.Base.s10),
        ("s12",  BaseSpacing.Base.s12),  ("s14",  BaseSpacing.Base.s14),
        ("s16",  BaseSpacing.Base.s16),  ("s20",  BaseSpacing.Base.s20),
        ("s24",  BaseSpacing.Base.s24),  ("s28",  BaseSpacing.Base.s28),
        ("s32",  BaseSpacing.Base.s32),  ("s36",  BaseSpacing.Base.s36),
        ("s40",  BaseSpacing.Base.s40),  ("s48",  BaseSpacing.Base.s48),
        ("s64",  BaseSpacing.Base.s64),  ("s72",  BaseSpacing.Base.s72),
        ("s80",  BaseSpacing.Base.s80),  ("s120", BaseSpacing.Base.s120),
        ("s160", BaseSpacing.Base.s160),
    ]
}
