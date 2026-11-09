//
//  MenuLayoutToken.swift
//  MDS
//

import UIKit

/// Menu 4종이 공유하는 레이아웃 값. 타입마다 다른 값(아이콘 크기, 아바타 크기, 안쪽 padding 등)은 각 아이템이 가진다.
enum MenuLayoutToken {
    // 컨테이너
    static let containerRadius = BaseRadius.Base.r12
    static let containerPadding = BaseSpacing.Base.s8

    // 아이템
    static let itemRadius = BaseRadius.Base.r8
    static let itemMinWidth: CGFloat = 80
}
