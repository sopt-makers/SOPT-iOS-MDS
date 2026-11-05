//
//  MDSIconMenuType.swift
//  MDS
//

public extension MDSIconMenu {
    struct Item {
        public var title: String
        public var description: String?
        public var icon: MDSIcon?

        public init(title: String, description: String? = nil, icon: MDSIcon? = nil) {
            self.title = title
            self.description = description
            self.icon = icon
        }
    }
}
