//
//  MDSIconMenuType.swift
//  MDS
//

public extension MDSIconMenu {
    struct Item {
        public var title: String
        public var icon: MDSIcon?

        public init(title: String, icon: MDSIcon? = nil) {
            self.title = title
            self.icon = icon
        }
    }
}
