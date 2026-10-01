//
//  MDSSnackBarType.swift
//  MDS
//
//  Created by 최주리 on 10/1/26.
//

import UIKit

extension MDSSnackBar {
    public enum Style: String, CaseIterable {
        case `default`
        case success
        case alert
        case error
    }

    struct IconToken {
        let icon: MDSIcon?
        let color: UIColor

        init(style: Style) {
            switch style {
            case .default:
                icon = nil
                color = .clear
            case .success:
                icon = .checkCircleFilled
                color = SemanticColor.Fg.Success.default
            case .alert:
                icon = .alertCircleFilled
                color = SemanticColor.Fg.Attention.default
            case .error:
                icon = .alertCircleFilled
                color = SemanticColor.Fg.Danger.default
            }
        }
    }
}
