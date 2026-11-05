//
//  MDSNavigationBar.swift
//  MDS
//
//  Created by 최주리 on 11/3/26.
//

import UIKit

public final class MDSNavigationBar: UIView {

    // MARK: - Properties

    public var leftIcon: Bool {
        didSet { updateLeftIcon() }
    }

    public var title: TitleSlot? {
        didSet { updateTitle() }
    }

    /// 앞에서부터 순서대로 채워지며 최대 3개까지 노출되고, 초과분은 무시됩니다.
    public var rightIcons: [MDSIcon] {
        didSet { updateRightIcons() }
    }

    public var rightButton: RightButton? {
        didSet { updateRightButton() }
    }

    public var onLeftIconTap: (() -> Void)?
    /// 탭한 우측 아이콘의 `rightIcons` index를 전달합니다.
    public var onRightIconTap: ((Int) -> Void)?
    public var onRightButtonTap: (() -> Void)?

    private static let maxRightIconCount = 3
    private static let iconButtonSize: CGFloat = 40
    private static let foregroundColor = SemanticColor.Fg.Neutral.bold

    // MARK: - Subviews

    private let containerStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = BaseSpacing.Base.s16
        view.isLayoutMarginsRelativeArrangement = true
        view.insetsLayoutMarginsFromSafeArea = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let leftStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = BaseSpacing.Base.s2
        return view
    }()

    private let rightStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.alignment = .center
        return view
    }()

    private lazy var leftIconButton: UIButton = makeIconButton(icon: .chevronLeftOutlined)

    private let titleContainerView = UIView()

    /// `.custom`으로 넣은 뷰. title이 바뀌면 제거합니다.
    private weak var customTitleView: UIView?

    private let titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let logoImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "image.sopt.logo", in: .module, compatibleWith: nil))
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// 우측 버튼 좌우 8pt 여백을 위한 래퍼
    private let rightButtonContainerView: UIStackView = {
        let view = UIStackView()
        view.isLayoutMarginsRelativeArrangement = true
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 0,
            leading: BaseSpacing.Base.s8,
            bottom: 0,
            trailing: BaseSpacing.Base.s8
        )
        return view
    }()

    // MARK: - Init

    public init(
        leftIcon: Bool = true,
        title: TitleSlot? = nil,
        rightIcons: [MDSIcon] = [],
        rightButton: RightButton? = nil
    ) {
        self.leftIcon = leftIcon
        self.title = title
        self.rightIcons = rightIcons
        self.rightButton = rightButton
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        backgroundColor = SemanticColor.Bg.Layer.basement
        setupHierarchy()
        setupLayout()
        updateTitle()
        updateLeftIcon()
        updateRightIcons()
        updateRightButton()
    }

    private func setupHierarchy() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(leftStackView)
        containerStackView.addArrangedSubview(rightStackView)

        leftStackView.addArrangedSubview(leftIconButton)
        leftStackView.addArrangedSubview(titleContainerView)

        titleContainerView.addSubview(titleLabel)
        titleContainerView.addSubview(logoImageView)

        rightStackView.addArrangedSubview(rightButtonContainerView)

        leftIconButton.addAction(UIAction { [weak self] _ in
            self?.onLeftIconTap?()
        }, for: .touchUpInside)
    }

    private func setupLayout() {
        // 우측 콘텐츠가 우선 공간을 차지하고, 타이틀이 남는 영역을 채운 뒤 말줄임됩니다.
        leftStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        leftStackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        rightStackView.setContentHuggingPriority(.required, for: .horizontal)
        rightStackView.setContentCompressionResistancePriority(.required, for: .horizontal)

        // 공간이 부족하면 우측 콘텐츠와 겹치지 않도록 로고가 비율을 유지한 채 줄어듭니다.
        let logoWidthConstraint = logoImageView.widthAnchor.constraint(equalToConstant: 65)
        logoWidthConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 44),

            containerStackView.topAnchor.constraint(equalTo: topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),

            titleContainerView.heightAnchor.constraint(equalToConstant: 40),

            titleLabel.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: titleContainerView.trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: titleContainerView.centerYAnchor),

            logoImageView.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor, constant: BaseSpacing.Base.s4),
            logoImageView.trailingAnchor.constraint(lessThanOrEqualTo: titleContainerView.trailingAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: titleContainerView.centerYAnchor),
            logoWidthConstraint,
            logoImageView.heightAnchor.constraint(equalToConstant: 22.38),
        ])
    }

    // MARK: - Appearance

    private func updateTitle() {
        // titleContainerView는 숨기지 않습니다. 남는 가로 공간을 흡수해 우측 콘텐츠를 오른쪽 끝에 붙이는 역할을 합니다.
        customTitleView?.removeFromSuperview()

        switch title {
        case nil:
            titleLabel.isHidden = true
            logoImageView.isHidden = true
        case .custom(let view):
            titleLabel.isHidden = true
            logoImageView.isHidden = true
            addCustomTitleView(view)
        case .title(let text):
            titleLabel.isHidden = false
            logoImageView.isHidden = true
            titleLabel.text = text
            titleLabel.setTypography(Typography.title4, textColor: Self.foregroundColor)
            titleLabel.lineBreakMode = .byTruncatingTail
        case .logo:
            titleLabel.isHidden = true
            logoImageView.isHidden = false
        }
    }

    private func addCustomTitleView(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        titleContainerView.addSubview(view)
        customTitleView = view

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor),
            view.trailingAnchor.constraint(lessThanOrEqualTo: titleContainerView.trailingAnchor),
            view.centerYAnchor.constraint(equalTo: titleContainerView.centerYAnchor),
            view.topAnchor.constraint(greaterThanOrEqualTo: titleContainerView.topAnchor),
        ])
    }

    private func updateLeftIcon() {
        leftIconButton.isHidden = !leftIcon
        containerStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: BaseSpacing.Base.s2,
            leading: leftIcon ? BaseSpacing.Base.s12 : BaseSpacing.Base.s20,
            bottom: BaseSpacing.Base.s2,
            trailing: BaseSpacing.Base.s12
        )
    }

    private func updateRightIcons() {
        rightStackView.arrangedSubviews
            .filter { $0 !== rightButtonContainerView }
            .forEach { $0.removeFromSuperview() }

        rightIcons.prefix(Self.maxRightIconCount).enumerated().forEach { index, icon in
            let button = makeIconButton(icon: icon)
            button.addAction(UIAction { [weak self] _ in
                self?.onRightIconTap?(index)
            }, for: .touchUpInside)
            rightStackView.insertArrangedSubview(button, at: index)
        }
    }

    private func updateRightButton() {
        rightButtonContainerView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        guard let rightButton else {
            rightButtonContainerView.isHidden = true
            return
        }

        let button: UIControl
        switch rightButton {
        case .textButton(let title):
            button = MDSTextButton(variant: .emphasis, size: .medium, title: title)
        case .actionButton(let title):
            button = MDSActionButton(variant: .primary, size: .small, title: title)
        }
        button.addAction(UIAction { [weak self] _ in
            self?.onRightButtonTap?()
        }, for: .touchUpInside)

        rightButtonContainerView.addArrangedSubview(button)
        rightButtonContainerView.isHidden = false
    }

    private func makeIconButton(icon: MDSIcon) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(icon.image.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = Self.foregroundColor
        button.translatesAutoresizingMaskIntoConstraints = false

        // 숨겨지면 UIStackView가 너비 0 제약을 추가하므로 충돌하지 않도록 우선순위를 낮춥니다.
        let widthConstraint = button.widthAnchor.constraint(equalToConstant: Self.iconButtonSize)
        widthConstraint.priority = .required - 1

        NSLayoutConstraint.activate([
            widthConstraint,
            button.heightAnchor.constraint(equalToConstant: Self.iconButtonSize),
        ])
        return button
    }
}
