//
//  TextMenuViewController.swift
//  MDSStoryBook
//

import UIKit
import MDS

final class TextMenuViewController: MenuCatalogViewController {

    private let selectionLabel = makeSelectionLabel(text: "체크된 항목: []")

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Text Menu"
        setupSections()
    }

    private func setupSections() {
        let multiple = MDSTextMenu(
            items: (1...5).map { MDSTextMenu.Item(title: "Menu \($0)", description: "description...") }
        )
        multiple.onSelect = { [weak self, weak multiple] index in
            guard let multiple else { return }
            let checked = multiple.checkedIndices.sorted().map { "Menu \($0 + 1)" }
            self?.selectionLabel.text = "체크된 항목: \(checked)\n(마지막 탭: Menu \(index + 1))"
        }

        let single = MDSTextMenu(
            items: (1...5).map {
                MDSTextMenu.Item(title: "Menu \($0)", description: "description...", isChecked: $0 == 1)
            }
        )
        single.onSelect = { [weak single] index in
            guard let single else { return }
            // 단일 선택으로 쓰려면 onSelect에서 나머지 체크를 풀어준다.
            (0..<5).filter { $0 != index }.forEach { single.setChecked(false, at: $0) }
            single.setChecked(true, at: index)
        }

        addSection(
            title: "다중 선택 (onSelect / checkedIndices)",
            caption: "탭하면 체크가 토글되고 여러 개를 동시에 체크할 수 있어요. 길게 누르면 Hover 배경이 보여요.",
            rows: [wrapLeading(multiple), selectionLabel]
        )
        addSection(
            title: "단일 선택처럼 쓰기",
            caption: "onSelect에서 나머지 체크를 setChecked(false)로 풀어줘요.",
            rows: [wrapLeading(single)]
        )
        addSection(
            title: "설명 없음",
            caption: "description이 nil이면 제목만 보여요.",
            rows: [wrapLeading(MDSTextMenu(items: (1...5).map { MDSTextMenu.Item(title: "Menu \($0)") }))]
        )
        addSection(
            title: "체크 초기값 / 폭 고정",
            caption: "체크 여부와 상관없이 체크 아이콘 자리가 확보돼서 탭해도 폭이 변하지 않아요.",
            rows: [wrapLeading(MDSTextMenu(items: [
                .init(title: "Menu", description: "description...", isChecked: true),
                .init(title: "Menu", description: "description..."),
                .init(title: "Menu", isChecked: true),
            ]))]
        )
    }
}
