//
//  TextMenuViewController.swift
//  MDSStoryBook
//

import UIKit
import MDS

final class TextMenuViewController: UIViewController {

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
        title = "Text Menu"
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

        contentStack.addArrangedSubview(makeSection(
            title: "다중 선택 (onSelect / checkedIndices)",
            caption: "탭하면 체크가 토글되고 여러 개를 동시에 체크할 수 있어요. 길게 누르면 Hover 배경이 보여요.",
            rows: [wrap(multiple), selectionLabel]
        ))
        contentStack.addArrangedSubview(makeSection(
            title: "단일 선택처럼 쓰기",
            caption: "onSelect에서 나머지 체크를 setChecked(false)로 풀어줘요.",
            rows: [wrap(single)]
        ))
        contentStack.addArrangedSubview(makeSection(
            title: "설명 없음",
            caption: "description이 nil이면 제목만 보여요.",
            rows: [wrap(MDSTextMenu(items: (1...5).map { MDSTextMenu.Item(title: "Menu \($0)") }))]
        ))
        contentStack.addArrangedSubview(makeSection(
            title: "체크 초기값 / 폭 고정",
            caption: "체크 여부와 상관없이 체크 아이콘 자리가 확보돼서 탭해도 폭이 변하지 않아요.",
            rows: [wrap(MDSTextMenu(items: [
                .init(title: "Menu", description: "description...", isChecked: true),
                .init(title: "Menu", description: "description..."),
                .init(title: "Menu", isChecked: true),
            ]))]
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
