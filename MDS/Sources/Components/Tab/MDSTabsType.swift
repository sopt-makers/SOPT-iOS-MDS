//
//  MDSTabsType.swift
//  MDS
//

public extension MDSTabs {
    enum Variant {
        case scrollable, fixed
    }

    typealias Size = MDSTab.Size

    struct Item {
        public var title: String
        public var tag: MDSTab.Tag?
        public var isEnabled: Bool

        public init(title: String, tag: MDSTab.Tag? = nil, isEnabled: Bool = true) {
            self.title = title
            self.tag = tag
            self.isEnabled = isEnabled
        }
    }
}
