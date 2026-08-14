//
//  MDSDialogType.swift
//  MDS
//
//  Created by 최주리 on 7/6/26.
//

import UIKit

public extension MDSDialog {
    enum Variant {
        case `default`(
            primaryButtonTitle: String,
            primaryButtonPrefixIcon: MDSIcon?,
            primaryButtonSuffixIcon: MDSIcon?,
            secondaryButtonTitle: String,
            secondaryButtonPrefixIcon: MDSIcon?,
            secondaryButtonSuffixIcon: MDSIcon?
        )
        case information(
            primaryButtonTitle: String,
            primaryButtonPrefixIcon: MDSIcon?,
            primaryButtonSuffixIcon: MDSIcon?
        )
        case danger(
            primaryButtonTitle: String,
            primaryButtonPrefixIcon: MDSIcon?,
            primaryButtonSuffixIcon: MDSIcon?,
            secondaryButtonTitle: String,
            secondaryButtonPrefixIcon: MDSIcon?,
            secondaryButtonSuffixIcon: MDSIcon?
        )
    }
}
