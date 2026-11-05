//
//  CheckboxMenuViewController.swift
//  MDSStoryBook
//

import UIKit
import MDS

final class CheckboxMenuViewController: MenuCatalogViewController {

    private let selectionLabel = makeSelectionLabel(text: "체크된 항목: []")

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Checkbox Menu"
        setupSections()
    }

    private func setupSections() {
        let multiple = MDSCheckboxMenu(
            items: (1...5).map { MDSCheckboxMenu.Item(title: "Label \($0)") }
        )
        multiple.onSelect = { [weak self, weak multiple] index in
            guard let multiple else { return }
            let checked = multiple.checkedIndices.sorted().map { "Label \($0 + 1)" }
            self?.selectionLabel.text = "체크된 항목: \(checked)\n(마지막 탭: Label \(index + 1))"
        }

        let initial = MDSCheckboxMenu(items: [
            .init(title: "Label", isChecked: true),
            .init(title: "Label"),
            .init(title: "Label", isChecked: true),
        ])

        let programmatic = MDSCheckboxMenu(items: (1...3).map { MDSCheckboxMenu.Item(title: "Label \($0)") })
        let button = UIButton(type: .system)
        button.setTitle("setChecked(true, at: 1) — onSelect 호출 안 됨", for: .normal)
        button.addAction(UIAction { [weak programmatic] _ in
            programmatic?.setChecked(true, at: 1)
        }, for: .touchUpInside)

        addSection(
            title: "다중 선택 (onSelect / checkedIndices)",
            caption: "행 전체가 터치 영역(높이 40)이에요. 길게 누르면 행 전체에 Hover 배경이 보이고, 손을 떼면 체크가 토글돼요.",
            rows: [wrapLeading(multiple), selectionLabel]
        )
        addSection(
            title: "체크 초기값",
            caption: "Item.isChecked로 처음부터 체크된 상태로 시작할 수 있어요.",
            rows: [wrapLeading(initial)]
        )
        addSection(
            title: "setChecked",
            caption: "코드로 체크를 바꿀 수 있고 onSelect는 호출되지 않아요.",
            rows: [wrapLeading(programmatic), button]
        )
    }
}
