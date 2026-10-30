//
//  MDSUserListMenuType.swift
//  MDS
//

import UIKit

public extension MDSUserListMenu {
    struct Item {
        public var title: String
        public var description: String?
        public var image: UIImage?

        public init(title: String, description: String? = nil, image: UIImage? = nil) {
            self.title = title
            self.description = description
            self.image = image
        }
    }
}
