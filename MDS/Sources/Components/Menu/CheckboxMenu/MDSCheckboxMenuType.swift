//
//  MDSCheckboxMenuType.swift
//  MDS
//

public extension MDSCheckboxMenu {
    struct Item {
        public var title: String
        public var description: String?
        public var isChecked: Bool

        public init(title: String, description: String? = nil, isChecked: Bool = false) {
            self.title = title
            self.description = description
            self.isChecked = isChecked
        }
    }
}
