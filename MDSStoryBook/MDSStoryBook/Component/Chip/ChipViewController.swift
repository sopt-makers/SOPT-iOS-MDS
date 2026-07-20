//
//  ChipViewController.swift
//  MDSStoryBook
//

import UIKit
import MDS

final class ChipViewController: UIViewController {

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
        title = "CHIP"
        view.backgroundColor = .systemGroupedBackground
        setupLayout()
        setupChips()
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

    private func setupChips() {
        let sections: [(title: String, size: MDSChip.Size)] = [
            ("Small", .small),
            ("Medium", .medium),
        ]

        sections.forEach { section in
            contentStack.addArrangedSubview(makeSection(title: section.title, size: section.size))
        }
    }

    private func makeSection(title: String, size: MDSChip.Size) -> UIView {
        let sectionTitle = UILabel()
        sectionTitle.text = title
        sectionTitle.font = .systemFont(ofSize: 13, weight: .semibold)
        sectionTitle.textColor = .secondaryLabel

        let card = UIView()
        card.backgroundColor = SemanticColor.Bg.Dim.default
        card.layer.cornerRadius = 12

        let cardStack = UIStackView()
        cardStack.axis = .horizontal
        cardStack.distribution = .fillEqually
        cardStack.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(cardStack)

        NSLayoutConstraint.activate([
            cardStack.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            cardStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -20),
            cardStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            cardStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
        ])

        cardStack.addArrangedSubview(makeChipItem(size: size, variant: .interactive))
        cardStack.addArrangedSubview(makeChipItem(size: size, variant: .selected))
        cardStack.addArrangedSubview(makeChipItem(size: size, variant: .disabled))

        let sectionStack = UIStackView()
        sectionStack.axis = .vertical
        sectionStack.spacing = 8
        sectionStack.addArrangedSubview(sectionTitle)
        sectionStack.addArrangedSubview(card)
        return sectionStack
    }

    private enum ChipVariant {
        case interactive
        case selected
        case disabled
    }

    private func makeChipItem(size: MDSChip.Size, variant: ChipVariant) -> UIView {
        let itemStack = UIStackView()
        itemStack.axis = .vertical
        itemStack.spacing = 12
        itemStack.alignment = .center

        let descriptionLabel = UILabel()
        descriptionLabel.font = .systemFont(ofSize: 11)
        descriptionLabel.textColor = SemanticColor.Fg.Neutral.subtle
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center

        let chip = MDSChip(size: size)
        chip.chipTitle = "Chip"

        switch variant {
        case .interactive:
            descriptionLabel.text = "탭하여 선택 상태 변경"
            chip.addTarget(self, action: #selector(chipTapped(_:)), for: .touchUpInside)
        case .selected:
            chip.isSelected = true
            chip.isUserInteractionEnabled = false
            descriptionLabel.text = "항상 Selected 상태"
        case .disabled:
            chip.isEnabled = false
            chip.isUserInteractionEnabled = false
            descriptionLabel.text = "항상 Disabled 상태"
        }

        itemStack.addArrangedSubview(chip)
        itemStack.addArrangedSubview(descriptionLabel)
        return itemStack
    }

    @objc private func chipTapped(_ sender: MDSChip) {
        sender.isSelected.toggle()
    }
}
