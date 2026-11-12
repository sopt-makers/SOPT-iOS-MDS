//
//  SingleSelectViewController.swift
//  MDSStoryBook
//

import UIKit
import MDS

final class SingleSelectViewController: MenuCatalogViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Single Select"
        setupSections()
    }

    private func setupSections() {
        let textItems = (1...5).map { MDSTextMenu.Item(title: "Menu \($0)", description: "description...") }
        let text = MDSSelect(type: .single(.text(textItems)), placeholder: "Placeholder")
        let textLabel = Self.makeSelectionLabel(text: "선택: 없음")
        bindSelection(text, to: textLabel, titles: textItems.map(\.title))

        let iconItems = (1...3).map { MDSIconMenu.Item(title: "Menu \($0)", icon: .sendOutlined) }
        let icon = MDSSelect(type: .single(.icon(iconItems)), placeholder: "Icon")
        let iconLabel = Self.makeSelectionLabel(text: "선택: 없음")
        bindSelection(icon, to: iconLabel, titles: iconItems.map(\.title))

        let userItems = (1...3).map { MDSUserListMenu.Item(title: "User\($0)", description: "description...") }
        let userList = MDSSelect(type: .single(.userList(userItems)), placeholder: "@User")
        let userListLabel = Self.makeSelectionLabel(text: "선택: 없음")
        bindSelection(userList, to: userListLabel, titles: userItems.map(\.title))

        let fixedWidth = MDSSelect(type: .single(.text(textItems)), placeholder: "menuWidth 240", menuWidth: 240)

        addSection(
            title: "Text",
            rows: [wrapSelect(text), textLabel]
        )
        addSection(
            title: "Icon",
            rows: [wrapSelect(icon), iconLabel]
        )
        addSection(
            title: "UserList",
            rows: [wrapSelect(userList), userListLabel]
        )
        addSection(
            title: "menuWidth",
            rows: [wrapSelect(fixedWidth)]
        )
    }
}
