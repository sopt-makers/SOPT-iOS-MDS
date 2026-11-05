//
//  IconMenuViewController.swift
//  MDSStoryBook
//

import UIKit
import MDS

final class IconMenuViewController: MenuCatalogViewController {

    private let selectionLabel = makeSelectionLabel(text: "선택한 항목: 없음")

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Icon Menu"
        setupSections()
    }

    private func setupSections() {
        let iconItems = (1...5).map { MDSIconMenu.Item(title: "Menu \($0)", icon: .heartFilled) }
        let textItems = (1...5).map { MDSIconMenu.Item(title: "Menu \($0)") }
        let mixedItems = [
            MDSIconMenu.Item(title: "알림", icon: .bellOutlined),
            MDSIconMenu.Item(title: "공유", icon: .sendOutlined),
            MDSIconMenu.Item(title: "아이콘 없는 항목"),
        ]

        let selectable = MDSIconMenu(items: iconItems) { [weak self] index in
            self?.selectionLabel.text = "선택한 항목: Menu \(index + 1) (index \(index))"
        }

        addSection(
            title: "onSelect",
            caption: "항목을 길게 누르면 Hover 배경이 보이고, 손을 떼면 onSelect가 호출돼요.",
            rows: [wrapLeading(selectable), selectionLabel]
        )
        addSection(
            title: "Icon 없음",
            caption: "icon이 nil이면 텍스트만 보여요.",
            rows: [wrapLeading(MDSIconMenu(items: textItems))]
        )
        addSection(
            title: "Icon 혼합",
            caption: "항목마다 icon 유무와 종류를 다르게 줄 수 있어요.",
            rows: [wrapLeading(MDSIconMenu(items: mixedItems))]
        )
    }
}
