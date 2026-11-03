//
//  MDSCheckboxMenuType.swift
//  MDS
//

public extension MDSCheckboxMenu {
    struct Item {
        public var title: String
        public var isChecked: Bool

        public init(title: String, isChecked: Bool = false) {
            self.title = title
            self.isChecked = isChecked
        }
    }
}
