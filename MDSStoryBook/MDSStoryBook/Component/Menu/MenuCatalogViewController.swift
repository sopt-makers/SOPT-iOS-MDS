//
//  MenuCatalogViewController.swift
//  MDSStoryBook
//

import UIKit
import MDS

/// Menu 카탈로그 화면의 공통 베이스. 스크롤 + 세로 스택 레이아웃과 섹션 구성 헬퍼를 제공한다.
/// 서브클래스는 `viewDidLoad`에서 `super.viewDidLoad()` 뒤에 `title`을 정하고 `addSection`으로 섹션을 추가한다.
class MenuCatalogViewController: UIViewController {

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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        setupLayout()
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

    // MARK: - Section

    /// 제목, 설명(옵션), 예시 뷰들로 이뤄진 섹션을 화면 맨 아래에 추가한다.
    func addSection(title: String, caption: String? = nil, rows: [UIView]) {
        let sectionTitle = UILabel()
        sectionTitle.text = title
        sectionTitle.font = .systemFont(ofSize: 13, weight: .semibold)
        sectionTitle.textColor = .secondaryLabel

        let captionLabel = caption.map { caption in
            let label = UILabel()
            label.text = caption
            label.font = .systemFont(ofSize: 12, weight: .medium)
            label.textColor = SemanticColor.Fg.Neutral.subtle
            label.numberOfLines = 0
            return label
        }

        let card = UIStackView(arrangedSubviews: [captionLabel].compactMap { $0 } + rows)
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
        contentStack.addArrangedSubview(sectionStack)
    }

    // MARK: - Helpers

    /// 메뉴는 내용 폭에 맞춰지므로 왼쪽 정렬로 감싼다.
    func wrapLeading(_ menu: UIView) -> UIView {
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

    /// `onSelect` 결과를 보여주는 라벨.
    static func makeSelectionLabel(text: String) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = SemanticColor.Fg.Neutral.default
        label.numberOfLines = 0
        label.text = text
        return label
    }
}
