//
//  ReactionButtonViewController.swift
//  MDSStoryBook
//
//  Created by 최주리 on 6/4/26.
//

import UIKit
import MDS

final class ReactionButtonViewController: UIViewController {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delaysContentTouches = false
        return scrollView
    }()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 24, left: 20, bottom: 40, right: 20)
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Reaction Button"
        view.backgroundColor = .systemGroupedBackground
        setupLayout()
        setupContent()
    }

    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }

    private func setupContent() {
        let sizes: [(title: String, size: MDSReactionButton.Size)] = [
            ("XSmall", .xsmall),
            ("Small", .small),
            ("Medium", .medium),
            ("Large", .large),
        ]

        sizes.forEach { item in
            contentStackView.addArrangedSubview(makeSizeSection(title: item.title, size: item.size))
        }
    }
}

private extension ReactionButtonViewController {

    func makeSizeSection(title: String, size: MDSReactionButton.Size) -> UIView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .label

        let sectionStack = UIStackView()
        sectionStack.axis = .vertical
        sectionStack.spacing = 10
        sectionStack.addArrangedSubview(titleLabel)
        sectionStack.addArrangedSubview(makeRow(label: "Default", size: size, isEnabled: true, isSelected: false))
        sectionStack.addArrangedSubview(makeRow(label: "Selected", size: size, isEnabled: true, isSelected: true))
        sectionStack.addArrangedSubview(makeRow(label: "Disabled", size: size, isEnabled: false, isSelected: false))

        return sectionStack
    }

    func makeRow(
        label: String,
        size: MDSReactionButton.Size,
        isEnabled: Bool,
        isSelected: Bool
    ) -> UIView {
        let buttons = [
            makeButton(
                size: size,
                isEnabled: isEnabled,
                icon: MDSIcon.plusOutlined.image,
                trailingIcon: MDSIcon.chevronRightOutlined.image,
                title: "button",
                count: 12,
                isSelected: isSelected
            ),
            makeButton(
                size: size,
                isEnabled: isEnabled,
                icon: MDSIcon.plusOutlined.image,
                trailingIcon: nil,
                title: "button",
                count: nil,
                isSelected: isSelected
            ),
            makeButton(
                size: size,
                isEnabled: isEnabled,
                icon: nil,
                trailingIcon: MDSIcon.chevronRightOutlined.image,
                title: "button",
                isSelected: isSelected
            ),
        ]

        return makeCardRow(label: label, buttons: buttons)
    }

    func makeButton(
        size: MDSReactionButton.Size,
        isEnabled: Bool,
        icon: UIImage?,
        trailingIcon: UIImage?,
        title: String,
        count: Int? = nil,
        isSelected: Bool
    ) -> MDSReactionButton {
        let button = MDSReactionButton(
            size: size,
            icon: icon,
            trailingIcon: trailingIcon,
            title: title,
            count: count,
            isSelected: isSelected
        )
        button.addTarget(self, action: #selector(reactionButtonTapped(_:)), for: .touchUpInside)
        button.isEnabled = isEnabled
        return button
    }

    func makeCardRow(label: String, buttons: [MDSReactionButton]) -> UIView {
        let stateLabel = UILabel()
        stateLabel.text = label
        stateLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        stateLabel.textColor = .secondaryLabel

        let card = UIView()
        card.backgroundColor = SemanticColor.Bg.Dim.default
        card.layer.cornerRadius = 12

        let buttonStack = UIStackView()
        buttonStack.axis = .vertical
        buttonStack.spacing = 12
        buttonStack.alignment = .leading
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        buttonStack.isLayoutMarginsRelativeArrangement = true
        card.addSubview(buttonStack)

        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: card.topAnchor),
            buttonStack.bottomAnchor.constraint(equalTo: card.bottomAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            buttonStack.trailingAnchor.constraint(equalTo: card.trailingAnchor),
        ])

        buttons.forEach { buttonStack.addArrangedSubview($0) }

        let rowStack = UIStackView()
        rowStack.axis = .vertical
        rowStack.spacing = 6
        rowStack.addArrangedSubview(stateLabel)
        rowStack.addArrangedSubview(card)
        return rowStack
    }
}

private extension ReactionButtonViewController {

    @objc func reactionButtonTapped(_ sender: MDSReactionButton) {
        sender.isSelected.toggle()
    }
}
