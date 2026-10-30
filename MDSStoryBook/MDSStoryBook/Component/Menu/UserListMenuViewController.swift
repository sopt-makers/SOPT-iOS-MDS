//
//  UserListMenuViewController.swift
//  MDSStoryBook
//

import UIKit
import MDS

final class UserListMenuViewController: UIViewController {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 32
        stack.layoutMargins = UIEdgeInsets(top: 24, left: 20, bottom: 24, right: 20)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let selectionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = SemanticColor.Fg.Neutral.default
        label.numberOfLines = 0
        label.text = "선택한 항목: 없음"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UserList Menu"
        view.backgroundColor = .systemGroupedBackground
        setupLayout()
        setupSections()
    }

    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
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

        contentStack.addArrangedSubview(makeSection(
            title: "onSelect",
            caption: "이미지가 없으면 fallback 아이콘이 보여요. 항목을 길게 누르면 Hover 배경이 보이고, 손을 떼면 onSelect가 호출돼요.",
            rows: [wrap(selectable), selectionLabel]
        ))
        contentStack.addArrangedSubview(makeSection(
            title: "이미지 있음",
            caption: "Item.image에 UIImage를 넘기면 아바타에 표시돼요. (샘플은 단색 이미지)",
            rows: [wrap(withImages)]
        ))
        contentStack.addArrangedSubview(makeSection(
            title: "설명 없음",
            caption: "description이 nil이면 제목만 세로 가운데에 보여요.",
            rows: [wrap(MDSUserListMenu(items: (1...5).map { MDSUserListMenu.Item(title: "User\($0)") }))]
        ))
    }

    private static func makeSampleImage(color: UIColor) -> UIImage {
        let size = CGSize(width: 64, height: 64)
        return UIGraphicsImageRenderer(size: size).image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }

    // 메뉴는 내용 폭에 맞춰지므로 왼쪽 정렬로 감싼다.
    private func wrap(_ menu: UIView) -> UIView {
        let container = UIView()
        menu.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(menu)
        NSLayoutConstraint.activate([
            menu.topAnchor.constraint(equalTo: container.topAnchor),
            menu.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            menu.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            menu.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor),
        ])
        return container
    }

    private func makeSection(title: String, caption: String, rows: [UIView]) -> UIView {
        let sectionTitle = UILabel()
        sectionTitle.text = title
        sectionTitle.font = .systemFont(ofSize: 13, weight: .semibold)
        sectionTitle.textColor = .secondaryLabel

        let captionLabel = UILabel()
        captionLabel.text = caption
        captionLabel.font = .systemFont(ofSize: 12, weight: .medium)
        captionLabel.textColor = SemanticColor.Fg.Neutral.subtle
        captionLabel.numberOfLines = 0

        let card = UIStackView(arrangedSubviews: [captionLabel] + rows)
        card.axis = .vertical
        card.spacing = 16
        card.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        card.isLayoutMarginsRelativeArrangement = true
        card.backgroundColor = SemanticColor.Bg.Layer.basement
        card.layer.cornerRadius = 12
        card.clipsToBounds = true

        let sectionStack = UIStackView(arrangedSubviews: [sectionTitle, card])
        sectionStack.axis = .vertical
        sectionStack.spacing = 8
        return sectionStack
    }
}
