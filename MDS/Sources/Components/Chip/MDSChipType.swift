//
//  MDSChipType.swift
//  MDS
//

import UIKit

extension MDSChip {

    public enum ChipType {
        case outlined
        case solid
    }

    public enum Size {
        case small
        case medium

        var contentInsets: NSDirectionalEdgeInsets {
            switch self {
            case .small:
                return NSDirectionalEdgeInsets(
                    top: 9,
                    leading: BaseSpacing.Base.s14,
                    bottom: 9,
                    trailing: BaseSpacing.Base.s14
                )
            case .medium:
                return NSDirectionalEdgeInsets(
                    top: BaseSpacing.Base.s10,
                    leading: BaseSpacing.Base.s20,
                    bottom: BaseSpacing.Base.s10,
                    trailing: BaseSpacing.Base.s20
                )
            }
        }

        var iconGap: CGFloat {
            BaseSpacing.Base.s4
        }

        var iconSize: CGFloat {
            switch self {
            case .small:  return 16
            case .medium: return 20
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
