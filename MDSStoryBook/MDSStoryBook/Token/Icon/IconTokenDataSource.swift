//
//  IconTokenDataSource.swift
//  MDSStoryBook
//
//  Created by 최주리 on 5/20/26.
//

import MDS

enum IconTokenDataSource {
    static func items() -> [IconTokenItem] {
        MDSIcon.allCases
            .map {
                IconTokenItem(
                    name: $0.rawValue,
                    icon: $0
                )
            }
    }
}
