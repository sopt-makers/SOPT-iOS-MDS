//
//  AvatarViewController.swift
//  MDSStoryBook
//

import UIKit
import MDS

final class AvatarViewController: UIViewController {

    private struct Variant {
        let title: String
        let hasStroke: Bool
        let hasImage: Bool
    }

    private let variants: [Variant] = [
        Variant(title: "Fallback", hasStroke: false, hasImage: false),
        Variant(title: "Fallback + Stroke", hasStroke: true, hasImage: false),
        Variant(title: "Image", hasStroke: false, hasImage: true),
        Variant(title: "Image + Stroke", hasStroke: true, hasImage: true),
    ]

    private let recommendedSizes: [CGFloat] = [24, 32, 48, 56, 72, 80, 120, 180]

    private let rainbowColors: [UIColor] = [
        SemanticColor.Stroke.Brand.default,
        SemanticColor.Stroke.Brand.subtle,
        SemanticColor.Stroke.Danger.default,
        SemanticColor.Stroke.Information.subtle,
        SemanticColor.Stroke.Neutral.default,
        SemanticColor.Stroke.Neutral.ghost,
        SemanticColor.Stroke.Neutral.inverse,
        SemanticColor.Stroke.Neutral.subtle,
    ]

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
        title = "Avatar"
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
        for variant in variants {
            contentStack.addArrangedSubview(makeVariantSection(variant: variant, sizes: recommendedSizes))
        }

        contentStack.addArrangedSubview(makeSectionHeader("커스텀 사이즈"))
        contentStack.addArrangedSubview(makeCard(sizes: [44], hasStroke: false, hasImage: false))
        contentStack.addArrangedSubview(makeCard(sizes: [44], hasStroke: true, hasImage: true))
    }

    private func makeVariantSection(variant: Variant, sizes: [CGFloat]) -> UIView {
        let header = makeSectionHeader(variant.title)
        let card = makeCard(sizes: sizes, hasStroke: variant.hasStroke, hasImage: variant.hasImage)

        let sectionStack = UIStackView()
        sectionStack.axis = .vertical
        sectionStack.spacing = 8
        sectionStack.addArrangedSubview(header)
        sectionStack.addArrangedSubview(card)
        return sectionStack
    }

    private func makeCard(sizes: [CGFloat], hasStroke: Bool, hasImage: Bool) -> UIView {
        let card = UIView()
        card.backgroundColor = SemanticColor.Bg.Dim.default
        card.layer.cornerRadius = 12

        let cardStack = UIStackView()
        cardStack.axis = .vertical
        cardStack.spacing = 20
        cardStack.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        cardStack.isLayoutMarginsRelativeArrangement = true
        cardStack.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(cardStack)

        NSLayoutConstraint.activate([
            cardStack.topAnchor.constraint(equalTo: card.topAnchor),
            cardStack.bottomAnchor.constraint(equalTo: card.bottomAnchor),
            cardStack.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            cardStack.trailingAnchor.constraint(equalTo: card.trailingAnchor),
        ])

        for (index, size) in sizes.enumerated() {
            let strokeColor: UIColor = hasStroke
                ? rainbowColors[index % rainbowColors.count]
                : SemanticColor.Stroke.Secondary.default
            cardStack.addArrangedSubview(
                makeSizeRow(size: size, hasStroke: hasStroke, hasImage: hasImage, strokeColor: strokeColor)
            )
        }

        return card
    }

    private func makeSizeRow(size: CGFloat, hasStroke: Bool, hasImage: Bool, strokeColor: UIColor) -> UIView {
        let rowStack = UIStackView()
        rowStack.axis = .horizontal
        rowStack.alignment = .center
        rowStack.spacing = 16

        let sizeLabel = UILabel()
        sizeLabel.text = "\(Int(size))pt"
        sizeLabel.font = .monospacedDigitSystemFont(ofSize: 12, weight: .medium)
        sizeLabel.textColor = SemanticColor.Fg.Neutral.subtle
        sizeLabel.textAlignment = .right
        sizeLabel.translatesAutoresizingMaskIntoConstraints = false
        sizeLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true

        let avatar = MDSAvatar(
            size: size,
            image: hasImage ? makeSampleImage(size: size) : nil,
            hasStroke: hasStroke,
            strokeColor: strokeColor
        )

        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)

        rowStack.addArrangedSubview(sizeLabel)
        rowStack.addArrangedSubview(avatar)
        rowStack.addArrangedSubview(spacer)

        return rowStack
    }

    private func makeSectionHeader(_ title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }

    private func makeSampleImage(size: CGFloat) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        return renderer.image { ctx in
            UIColor.systemBlue.withAlphaComponent(0.4).setFill()
            ctx.fill(CGRect(x: 0, y: 0, width: size, height: size))
            let iconSize = size * 0.5
            let iconRect = CGRect(
                x: (size - iconSize) / 2,
                y: (size - iconSize) / 2,
                width: iconSize,
                height: iconSize
            )
            let config = UIImage.SymbolConfiguration(pointSize: iconSize * 0.6, weight: .regular)
            if let icon = UIImage(systemName: "photo.fill", withConfiguration: config) {
                UIColor.white.setFill()
                icon.draw(in: iconRect)
            }
        }
    }
}
