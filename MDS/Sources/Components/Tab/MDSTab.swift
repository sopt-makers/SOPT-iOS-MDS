//
//  MDSTab.swift
//  MDS
//
//  Created by yungu0010 on 9/30/26.
//

import UIKit

public final class MDSTab: UIControl {

    // MARK: - Properties

    public var title: String {
        didSet { updateAppearance() }
    }

    public var tabTag: Tag? {
        didSet { updateTag() }
    }

    public override var isSelected: Bool {
        didSet { updateAppearance() }
    }

    public override var isEnabled: Bool {
        didSet { updateAppearance() }
    }

    private let variant: Variant
    private let size: Size

    // MARK: - Subviews

    private let contentStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = BaseSpacing.Base.s4
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()

    private var tagView: MDSTag?

    private let underline: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init

    public init(
        title: String,
        variant: Variant,
        size: Size,
        tag: Tag? = nil,
        isSelected: Bool = false
    ) {
        self.title = title
        self.tabTag = tag
        self.variant = variant
        self.size = size
        super.init(frame: .zero)
        setup()
        self.isSelected = isSelected
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        setupHierarchy()
        setupLayout()
        updateAppearance()
        updateTag()
    }

    private func setupHierarchy() {
        addSubview(contentStackView)
        addSubview(underline)
        contentStackView.addArrangedSubview(titleLabel)
    }

    private func setupLayout() {
        // fill는 라벨이 남는 폭을 채우고(hugging이 태그보다 낮아야 함) 폭이 모자라면 라벨이 줄어든다.
        titleLabel.setContentHuggingPriority(variant == .hug ? .required : UILayoutPriority(249), for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(variant == .hug ? .required : .defaultLow, for: .horizontal)

        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: SizeToken.verticalPadding),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -SizeToken.verticalPadding),

            underline.heightAnchor.constraint(equalToConstant: SizeToken.underlineThickness),
            underline.leadingAnchor.constraint(equalTo: leadingAnchor),
            underline.trailingAnchor.constraint(equalTo: trailingAnchor),
            underline.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        switch variant {
        case .hug:
            NSLayoutConstraint.activate([
                contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
        case .fill:
            NSLayoutConstraint.activate([
                contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: SizeToken.fillHorizontalPadding),
                contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -SizeToken.fillHorizontalPadding),
            ])
        }
    }

    // MARK: - Appearance

    private func updateAppearance() {
        let colorToken = ColorToken(isSelected: isSelected, isEnabled: isEnabled)

        titleLabel.text = title
        titleLabel.setTypography(SizeToken(size: size).font, textColor: colorToken.foreground)

        underline.backgroundColor = colorToken.underline
        underline.isHidden = !colorToken.showsUnderline
    }

    // Tag의 shape/variant/size는 고정이고 style만 바뀌므로, 값이 바뀔 때마다 새로 만들어 교체한다.
    private func updateTag() {
        tagView?.removeFromSuperview()
        tagView = nil

        guard let tabTag, !tabTag.text.isEmpty || tabTag.icon != nil else { return }

        let tagView = MDSTag(
            text: tabTag.text,
            size: .small,
            shape: .pill,
            variant: .primary,
            style: tabTag.style,
            icon: tabTag.icon
        )
        contentStackView.addArrangedSubview(tagView)
        self.tagView = tagView
    }
}

// MARK: - Size Token

private extension MDSTab {

    struct SizeToken {
        static let verticalPadding = BaseSpacing.Base.s6
        static let fillHorizontalPadding = BaseSpacing.Base.s16
        static let underlineThickness: CGFloat = 2

        let font: MDSFont

        init(size: MDSTab.Size) {
            switch size {
            case .small:
                font = Typography.heading4
            case .medium:
                font = Typography.heading3
            case .large:
                font = Typography.heading2
            }
        }
    }
}

// MARK: - Color Token

private extension MDSTab {

    struct ColorToken {
        let underline = SemanticColor.Stroke.Neutral.inverse
        let foreground: UIColor
        let showsUnderline: Bool

        init(isSelected: Bool, isEnabled: Bool) {
            guard isEnabled else {
                foreground = SemanticColor.Fg.Neutral.Ghost.disabled
                showsUnderline = false
                return
            }
            foreground = isSelected ? SemanticColor.Fg.Neutral.bold : SemanticColor.Fg.Neutral.ghost
            showsUnderline = isSelected
        }
    }
}
