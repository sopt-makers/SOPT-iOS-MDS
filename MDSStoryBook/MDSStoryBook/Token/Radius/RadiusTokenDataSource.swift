//
//  RadiusTokenDataSource.swift
//  MDSStoryBook
//
//  Created by Codex on 5/24/26.
//

import Foundation
import MDS

enum RadiusTokenDataSource {
    static let items: [(name: String, value: CGFloat)] = [
        ("r0", BaseRadius.Base.r0),
        ("r2", BaseRadius.Base.r2),
        ("r4", BaseRadius.Base.r4),
        ("r6", BaseRadius.Base.r6),
        ("r8", BaseRadius.Base.r8),
        ("r10", BaseRadius.Base.r10),
        ("r12", BaseRadius.Base.r12),
        ("r14", BaseRadius.Base.r14),
        ("r16", BaseRadius.Base.r16),
        ("r20", BaseRadius.Base.r20),
        ("r24", BaseRadius.Base.r24),
        ("r32", BaseRadius.Base.r32),
        ("full", BaseRadius.Base.full),
    ]
}
