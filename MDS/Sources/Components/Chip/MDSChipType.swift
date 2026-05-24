//
//  MDSChipType.swift
//  MDS
//

import UIKit

extension MDSChip {

    public enum Size {
        case small
        case medium

        var contentInsets: NSDirectionalEdgeInsets {
            switch self {
            case .small:  return NSDirectionalEdgeInsets(top: 9, leading: 14, bottom: 9, trailing: 14)
            case .medium: return NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
            }
        }

        var typography: MDSFont {
            switch self {
            case .small:  return Typography.label3
            case .medium: return Typography.label2
            }
        }
    }
}
