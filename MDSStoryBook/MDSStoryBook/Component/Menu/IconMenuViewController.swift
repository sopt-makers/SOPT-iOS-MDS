//
//  IconMenuViewController.swift
//  MDSStoryBook
//

import UIKit
import MDS

final class IconMenuViewController: UIViewController {

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
        title = "Icon Menu"
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

        contentStack.addArrangedSubview(makeSection(
            title: "onSelect",
            caption: "항목을 길게 누르면 Hover 배경이 보이고, 손을 떼면 onSelect가 호출돼요.",
            rows: [wrap(selectable), selectionLabel]
        ))
        contentStack.addArrangedSubview(makeSection(
            title: "Icon 없음",
            caption: "icon이 nil이면 텍스트만 보여요.",
            rows: [wrap(MDSIconMenu(items: textItems))]
        ))
        contentStack.addArrangedSubview(makeSection(
            title: "Icon 혼합",
            caption: "항목마다 icon 유무와 종류를 다르게 줄 수 있어요.",
            rows: [wrap(MDSIconMenu(items: mixedItems))]
        ))
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
