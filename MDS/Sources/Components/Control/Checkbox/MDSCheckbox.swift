//
//  MDSCheckbox.swift
//  MDS
//
//  Created by 최주리 on 6/6/26.
//

import UIKit

public final class MDSCheckbox: UIControl {

    // MARK: - Properties

    public override var isSelected: Bool {
        didSet { updateAppearance() }
    }

    public override var isEnabled: Bool {
        didSet { updateAppearance() }
    }
    
    public var title: String? {
        didSet { setTitle(title: title) }
    }

    private let checkboxSize: Size

    // MARK: - UI Components

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    /// 박스보다 한 단계 큰 바깥 영역. 레이아웃 크기와 터치 영역을 맡고, 박스는 이 안에서 가운데에 놓인다.
    private let boxContainerView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let boxView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = BaseRadius.Base.r4
        view.layer.borderWidth = 1
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = MDSIcon.checkOutlined.image.withRenderingMode(.alwaysTemplate)
        imageView.isUserInteractionEnabled = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Init

    public init(size: Size = .large, title: String? = nil) {
        self.checkboxSize = size
        
        super.init(frame: .zero)
        
        setup()
        setTitle(title: title)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        setupHierarchy()
        setupLayout()
        setupAction()
        updateAppearance()
    }

    private func setupHierarchy() {
        addSubview(contentStackView)
        contentStackView.addArrangedSubview(boxContainerView)
        contentStackView.addArrangedSubview(titleLabel)
        boxContainerView.addSubview(boxView)
        boxView.addSubview(checkImageView)
    }

    private func setupLayout() {
        let sizeToken = SizeToken(size: checkboxSize)

        contentStackView.spacing = sizeToken.padding

        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor),

            boxContainerView.widthAnchor.constraint(equalToConstant: sizeToken.containerSize),
            boxContainerView.heightAnchor.constraint(equalToConstant: sizeToken.containerSize),

            boxView.centerXAnchor.constraint(equalTo: boxContainerView.centerXAnchor),
            boxView.centerYAnchor.constraint(equalTo: boxContainerView.centerYAnchor),
            boxView.widthAnchor.constraint(equalToConstant: sizeToken.boxSize),
            boxView.heightAnchor.constraint(equalToConstant: sizeToken.boxSize),

            checkImageView.centerXAnchor.constraint(equalTo: boxView.centerXAnchor),
            checkImageView.centerYAnchor.constraint(equalTo: boxView.centerYAnchor),
            checkImageView.widthAnchor.constraint(equalToConstant: sizeToken.iconSize),
            checkImageView.heightAnchor.constraint(equalToConstant: sizeToken.iconSize),
        ])
    }
    
    private func setTitle(title: String?) {
        if let title {
            self.titleLabel.isHidden = false
            self.titleLabel.text = title
            self.titleLabel.setTypography(SizeToken(size: checkboxSize).font)
        } else {
            self.titleLabel.isHidden = true
        }
    }

    private func setupAction() {
        addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }

    @objc private func handleTap() {
        isSelected.toggle()
        sendActions(for: .valueChanged)
    }

    // MARK: - Appearance

    private func updateAppearance() {
        let colorToken = ColorToken(isEnabled: isEnabled, isSelected: isSelected)
        
        boxView.backgroundColor = colorToken.backgroundColor
        boxView.layer.borderColor = colorToken.borderColor.cgColor
        checkImageView.tintColor = colorToken.iconColor
        checkImageView.isHidden = !isSelected

        titleLabel.setTypography(SizeToken(size: checkboxSize).font, textColor: colorToken.textColor)
    }
}

// MARK: - Size Token

/// `MDSCheckboxMenuItem`이 체크박스 크기를 사용하도록 internal로 관리
extension MDSCheckbox {
    struct SizeToken {
        let iconSize: CGFloat
        let boxSize: CGFloat
        /// 박스를 감싸는 바깥 영역(레이아웃 + 터치 영역) 크기
        let containerSize: CGFloat
        let font: MDSFont
        /// 바깥 영역과 제목 사이 가로 간격
        let padding: CGFloat

        init(size: Size) {
            switch size {
            case .small:
                iconSize = 12
                boxSize = 16
                containerSize = 20
                font = Typography.label3
                padding = BaseSpacing.Base.s4
            case .large:
                iconSize = 14
                boxSize = 20
                containerSize = 24
                font = Typography.label2
                padding = BaseSpacing.Base.s8
            }
        }
    }
}

// MARK: - Color Token

private extension MDSCheckbox {
    struct ColorToken {
        let backgroundColor: UIColor
        let borderColor: UIColor
        let iconColor: UIColor
        let textColor: UIColor

        init(isEnabled: Bool, isSelected: Bool) {
            switch (isEnabled, isSelected) {
            case (true, true):
                backgroundColor = SemanticColor.Fg.Secondary.default
                borderColor = .clear
                iconColor = SemanticColor.Fg.Neutral.bold
                textColor = SemanticColor.Fg.Neutral.bold
            case (true, false):
                backgroundColor = .clear
                borderColor = SemanticColor.Stroke.Neutral.default
                iconColor = .clear
                textColor = SemanticColor.Fg.Neutral.bold
            case (false, true):
                backgroundColor = SemanticColor.Fg.Neutral.Ghost.disabled
                borderColor = .clear
                iconColor = SemanticColor.Fg.Neutral.ghost
                textColor = SemanticColor.Fg.Neutral.Default.disabled
            case (false, false):
                backgroundColor = .clear
                borderColor = SemanticColor.Stroke.Neutral.Default.disabled
                iconColor = .clear
                textColor = SemanticColor.Fg.Neutral.Default.disabled
            }
        }
    }
}
