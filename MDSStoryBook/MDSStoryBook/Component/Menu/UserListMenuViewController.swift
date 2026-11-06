//
//  UserListMenuViewController.swift
//  MDSStoryBook
//

import UIKit
import MDS

final class UserListMenuViewController: MenuCatalogViewController {

    private let selectionLabel = makeSelectionLabel(text: "선택한 항목: 없음")

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UserList Menu"
        setupSections()
    }

    private func setupSections() {
        let selectable = MDSUserListMenu(
            items: (1...5).map { MDSUserListMenu.Item(title: "User\($0)", description: "description...") }
        ) { [weak self] index in
            self?.selectionLabel.text = "선택한 항목: User\(index + 1) (index \(index))"
        }

        let sampleColors: [UIColor] = [.systemPink, .systemTeal, .systemOrange]
        let withImages = MDSUserListMenu(
            items: sampleColors.enumerated().map { index, color in
                MDSUserListMenu.Item(
                    title: "User\(index + 1)",
                    description: "description...",
                    image: Self.makeSampleImage(color: color)
                )
            }
        )

        addSection(
            title: "onSelect",
            caption: "이미지가 없으면 fallback 아이콘이 보여요. 항목을 길게 누르면 Hover 배경이 보이고, 손을 떼면 onSelect가 호출돼요.",
            rows: [wrapLeading(selectable), selectionLabel]
        )
        addSection(
            title: "이미지 있음",
            caption: "Item.image에 UIImage를 넘기면 아바타에 표시돼요. (샘플은 단색 이미지)",
            rows: [wrapLeading(withImages)]
        )
        addSection(
            title: "설명 없음",
            caption: "description이 nil이면 제목만 세로 가운데에 보여요.",
            rows: [wrapLeading(MDSUserListMenu(items: (1...5).map { MDSUserListMenu.Item(title: "User\($0)") }))]
        )
    }

    private static func makeSampleImage(color: UIColor) -> UIImage {
        let size = CGSize(width: 64, height: 64)
        return UIGraphicsImageRenderer(size: size).image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
}
