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
        stack.distribution = .fillEqually
        stack.spacing = 32
        stack.layoutMargins = UIEdgeInsets(top: 24, left: 20, bottom: 24, right: 20)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chip"
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
        let types: [(title: String, type: MDSChip.ChipType)] = [
            ("Outlined", .outlined),
            ("Solid", .solid),
        ]
        let iconCombinations: [(title: String, prefix: MDSIcon?, suffix: MDSIcon?)] = [
            ("No Icon", nil, nil),
            ("Prefix + Suffix", .plusOutlined, .chevronRightOutlined),
        ]

        types.forEach { typeItem in
            iconCombinations.forEach { iconItem in
                let items: [UIView] = [
                    makeChipItem(type: typeItem.type, size: .medium, prefixIcon: iconItem.prefix, suffixIcon: iconItem.suffix, variant: .interactive),
                    makeChipItem(type: typeItem.type, size: .medium, prefixIcon: iconItem.prefix, suffixIcon: iconItem.suffix, variant: .selected),
                    makeChipItem(type: typeItem.type, size: .medium, prefixIcon: iconItem.prefix, suffixIcon: iconItem.suffix, variant: .disabled),
                ]
                contentStack.addArrangedSubview(makeSection(
                    title: "\(typeItem.title) / \(iconItem.title)",
                    items: items
                ))
            }
        }

        contentStack.addArrangedSubview(makeSection(
            title: "Size",
            items: [
                makeSizeItem(title: "Small", size: .small),
                makeSizeItem(title: "Medium", size: .medium),
            ]
        ))
    }

    private func makeSection(title: String, items: [UIView]) -> UIView {
        let sectionTitle = UILabel()
        sectionTitle.text = title
        sectionTitle.font = .systemFont(ofSize: 13, weight: .semibold)
        sectionTitle.textColor = .secondaryLabel

        let sectionStack = UIStackView()
        sectionStack.axis = .vertical
        sectionStack.spacing = 8
        sectionStack.addArrangedSubview(sectionTitle)
        sectionStack.addArrangedSubview(makeCard(items: items))
        return sectionStack
    }

    private func makeCard(items: [UIView]) -> UIView {
        let card = UIView()
        card.backgroundColor = SemanticColor.Bg.Dim.default
        card.layer.cornerRadius = 12

        let cardScroll = UIScrollView()
        cardScroll.showsHorizontalScrollIndicator = false
        cardScroll.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(cardScroll)

        let cardStack = UIStackView()
        cardStack.axis = .horizontal
        cardStack.distribution = .fill
        cardStack.spacing = 16
        cardStack.translatesAutoresizingMaskIntoConstraints = false
        cardScroll.addSubview(cardStack)

        NSLayoutConstraint.activate([
            cardScroll.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            cardScroll.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -20),
            cardScroll.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            cardScroll.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),

            cardStack.topAnchor.constraint(equalTo: cardScroll.topAnchor),
            cardStack.bottomAnchor.constraint(equalTo: cardScroll.bottomAnchor),
            cardStack.leadingAnchor.constraint(equalTo: cardScroll.leadingAnchor),
            cardStack.trailingAnchor.constraint(equalTo: cardScroll.trailingAnchor),
            cardStack.heightAnchor.constraint(equalTo: cardScroll.heightAnchor),
            cardStack.widthAnchor.constraint(greaterThanOrEqualTo: cardScroll.widthAnchor),
        ])

        items.forEach { cardStack.addArrangedSubview($0) }
        return card
    }

    private enum ChipVariant {
        case interactive
        case selected
        case disabled
    }

    private func makeChipItem(type: MDSChip.ChipType, size: MDSChip.Size, prefixIcon: MDSIcon?, suffixIcon: MDSIcon?, variant: ChipVariant) -> UIView {
        let itemStack = UIStackView()
        itemStack.axis = .vertical
        itemStack.spacing = 12
        itemStack.alignment = .center

        let descriptionLabel = UILabel()
        descriptionLabel.font = .systemFont(ofSize: 11)
        descriptionLabel.textColor = SemanticColor.Fg.Neutral.subtle
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center

        let chip = MDSChip(size: size, type: type, prefixIcon: prefixIcon, suffixIcon: suffixIcon)
        chip.chipTitle = "CHIP"

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

    private func makeSizeItem(title: String, size: MDSChip.Size) -> UIView {
        let itemStack = UIStackView()
        itemStack.axis = .vertical
        itemStack.spacing = 12
        itemStack.alignment = .center

        let descriptionLabel = UILabel()
        descriptionLabel.font = .systemFont(ofSize: 11)
        descriptionLabel.textColor = SemanticColor.Fg.Neutral.subtle
        descriptionLabel.text = title

        let chip = MDSChip(size: size, type: .outlined)
        chip.chipTitle = "Chip"
        chip.isUserInteractionEnabled = false

        itemStack.addArrangedSubview(chip)
        itemStack.addArrangedSubview(descriptionLabel)
        return itemStack
    }

    @objc private func chipTapped(_ sender: MDSChip) {
        sender.isSelected.toggle()
    }
}
