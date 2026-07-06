//
//  MDSDialogType.swift
//  MDS
//
//  Created by 최주리 on 7/6/26.
//

public extension MDSDialog {
    enum Variant {
        case `default`(primaryButtonTitle: String, disableButtonTitle: String)
        case information(primaryButtonTitle: String)
        case danger(primaryButtonTitle: String, disableButtonTitle: String)
    }
}
