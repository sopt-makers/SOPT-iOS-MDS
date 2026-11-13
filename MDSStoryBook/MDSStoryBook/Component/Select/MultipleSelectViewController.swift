//
//  MultipleSelectViewController.swift
//  MDSStoryBook
//

import UIKit
import MDS

final class MultipleSelectViewController: MenuCatalogViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Multiple Select"
        setupSections()
    }

    private func setupSections() {
        let textItems = (1...5).map { MDSTextMenu.Item(title: "Menu \($0)", description: "description...") }
        let text = MDSSelect(type: .multiple(.text(textItems)), placeholder: "Placeholder")
        let textLabel = Self.makeSelectionLabel(text: "선택: 없음")
        bindSelection(text, to: textLabel, titles: textItems.map(\.title))

        let checkboxItems = (1...6).map { MDSCheckboxMenu.Item(title: "Label \($0)") }
        let checkbox = MDSSelect(type: .multiple(.checkbox(checkboxItems)), placeholder: "Placeholder")
        let checkboxLabel = Self.makeSelectionLabel(text: "선택: 없음")
        bindSelection(checkbox, to: checkboxLabel, titles: checkboxItems.map(\.title))

        let filled = MDSSelect(
            type: .multiple(.checkbox((1...5).map { MDSCheckboxMenu.Item(title: "Label \($0)", isChecked: $0 == 2 || $0 == 4) })),
            placeholder: "Placeholder"
        )

        let scrolling = MDSSelect(
            type: .multiple(.checkbox((1...20).map { MDSCheckboxMenu.Item(title: "Label \($0)") })),
            placeholder: "menuMaxHeight 160",
            menuMaxHeight: 160
        )

        addSection(
            title: "Text",
            rows: [wrapSelect(text), textLabel]
        )
        addSection(
            title: "Checkbox",
            rows: [wrapSelect(checkbox), checkboxLabel]
        )
        addSection(
            title: "Filled (isChecked)",
            rows: [wrapSelect(filled)]
        )
        addSection(
            title: "menuMaxHeight",
            rows: [wrapSelect(scrolling)]
        )
    }
}
