//
//  MDSNavigationBarType.swift
//  MDS
//
//  Created by 최주리 on 11/3/26.
//

import UIKit

public extension MDSNavigationBar {
    
    /// Slot 영역(높이 40)에 자유롭게 UI를 넣습니다. 좌측 정렬, 세로 중앙 정렬되며 Slot 너비를 넘지 않습니다.
    enum TitleSlot {
        case title(String)
        case logo
        case custom(UIView)
    }

    enum RightButton {
        case textButton(String)
        case actionButton(String)
    }
}
