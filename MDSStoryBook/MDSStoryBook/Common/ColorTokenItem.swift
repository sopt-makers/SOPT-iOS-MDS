//
//  ColorTokenItem.swift
//  MDSStoryBook
//
//  Created by 강윤서 on 5/8/26.
//

import UIKit

struct ColorTokenItem {
    let name: String
    let color: UIColor
}

struct ColorTokenSection {
    let title: String
    let items: [ColorTokenItem]
}
