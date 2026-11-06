//
//  CheckboxMenuViewController.swift
//  MDSStoryBook
//

import UIKit
import MDS

final class CheckboxMenuViewController: UIViewController {

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
        label.text = "체크된 항목: []"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Checkbox Menu"
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

        contentStack.addArrangedSubview(makeSection(
            title: "다중 선택 (onSelect / checkedIndices)",
            caption: "행 전체가 터치 영역(높이 40)이에요. 길게 누르면 행 전체에 Hover 배경이 보이고, 손을 떼면 체크가 토글돼요.",
            rows: [wrap(multiple), selectionLabel]
        ))
        contentStack.addArrangedSubview(makeSection(
            title: "체크 초기값",
            caption: "Item.isChecked로 처음부터 체크된 상태로 시작할 수 있어요.",
            rows: [wrap(initial)]
        ))
        contentStack.addArrangedSubview(makeSection(
            title: "setChecked",
            caption: "코드로 체크를 바꿀 수 있고 onSelect는 호출되지 않아요.",
            rows: [wrap(programmatic), button]
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
