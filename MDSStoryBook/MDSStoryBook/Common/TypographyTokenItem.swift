//
//  TypographyTokenItem.swift
//  MDSStoryBook
//
//  Created by 강윤서 on 5/8/26.
//

import MDS

struct TypographyTokenItem {
    let name: String
    let mdsFont: MDSFont
}

struct TypographyTokenSection {
    let title: String
    let items: [TypographyTokenItem]
}
