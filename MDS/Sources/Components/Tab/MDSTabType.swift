//
//  MDSTabType.swift
//  MDS
//
//  Created by yungu0010 on 9/30/26.
//

public extension MDSTab {
    enum Variant {
        case hug, fill
    }

    enum Size {
        case small, medium, large
    }

    struct Tag {
        public var text: String
        public var icon: MDSIcon?
        public var style: MDSTag.Style

        public init(text: String, icon: MDSIcon? = nil, style: MDSTag.Style = .subtle) {
            self.text = text
            self.icon = icon
            self.style = style
        }
    }
}
