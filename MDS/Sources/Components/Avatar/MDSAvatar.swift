//
//  MDSAvatar.swift
//  MDS
//

import UIKit

public final class MDSAvatar: UIView {

    // MARK: - Private Views

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let fallbackIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Properties

    public var image: UIImage? {
        didSet { applyImageState() }
    }

    public var hasStroke: Bool {
        didSet { layer.borderWidth = hasStroke ? strokeWeight : 0 }
    }

    private let size: CGFloat

    // MARK: - Init

    /// - Parameter size: 권고 사이즈 — 24, 32, 48, 56, 72, 80, 120, 180 (단위: pt)
    public init(size: CGFloat, image: UIImage? = nil, hasStroke: Bool = false) {
        self.size = size
        self.image = image
        self.hasStroke = hasStroke
        super.init(frame: .zero)
        setupUI()
        setupLayout()
        applyImageState()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Layout

    public override var intrinsicContentSize: CGSize {
        CGSize(width: size, height: size)
    }

    // MARK: - Setup

    private func setupUI() {
        layer.cornerRadius = size / 2
        layer.borderWidth = hasStroke ? strokeWeight : 0
        layer.borderColor = SemanticColor.Stroke.Secondary.default.cgColor
        layer.masksToBounds = true

        backgroundColor = SemanticColor.Bg.Neutral.ghost

        fallbackIconView.image = MDSIcon.userFilled.image.withRenderingMode(.alwaysTemplate)
        fallbackIconView.tintColor = SemanticColor.Fg.Neutral.bold
    }

    private func setupLayout() {
        addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: topAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        addSubview(fallbackIconView)
        NSLayoutConstraint.activate([
            fallbackIconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            fallbackIconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            fallbackIconView.widthAnchor.constraint(equalToConstant: size / 2),
            fallbackIconView.heightAnchor.constraint(equalToConstant: size / 2)
        ])
    }

    // MARK: - Apply

    private func applyImageState() {
        let hasImage = image != nil
        profileImageView.image = image
        profileImageView.isHidden = !hasImage
        fallbackIconView.isHidden = hasImage
    }

    private var strokeWeight: CGFloat {
        if size < 40 { return 1 }
        if size < 64 { return 2 }
        if size < 160 { return 3 }
        return 4
    }
}
