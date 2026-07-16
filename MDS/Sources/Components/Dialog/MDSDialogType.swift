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
            primaryButtonPrefixImage: UIImage?,
            primaryButtonSuffixImage: UIImage?,
            secondaryButtonTitle: String,
            secondaryButtonPrefixImage: UIImage?,
            secondaryButtonSuffixImage: UIImage?
        )
        case information(
            primaryButtonTitle: String,
            primaryButtonPrefixImage: UIImage?,
            primaryButtonSuffixImage: UIImage?
        )
        case danger(
            primaryButtonTitle: String,
            primaryButtonPrefixImage: UIImage?,
            primaryButtonSuffixImage: UIImage?,
            secondaryButtonTitle: String,
            secondaryButtonPrefixImage: UIImage?,
            secondaryButtonSuffixImage: UIImage?
        )
    }
}
