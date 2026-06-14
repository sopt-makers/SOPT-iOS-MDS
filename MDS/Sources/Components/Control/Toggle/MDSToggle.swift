//
//  MDSToggle.swift
//  MDS
//
//  Created by 최주리 on 6/14/26.
//

import UIKit

public final class MDSToggle: UIControl {

    // MARK: - Properties

    public var isOn: Bool = false {
        didSet {
            updateAppearance(animated: true)
        }
    }

    public override var isEnabled: Bool {
        didSet {
            updateAppearance(animated: false)
        }
    }

    private let toggleSize: Size

    // MARK: - UI Components

    private let trackView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        return view
    }()

    private let thumbView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isUserInteractionEnabled = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 2
        return view
    }()

    // MARK: - Init

    public init(size: Size = .large) {
        self.toggleSize = size
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        setupHierarchy()
        setupLayout()
        setupAction()
        updateAppearance(animated: false)
    }

    private func setupHierarchy() {
        addSubview(trackView)
        trackView.addSubview(thumbView)
    }

    private func setupLayout() {
        let sizeToken = SizeToken(size: toggleSize)
        
        trackView.translatesAutoresizingMaskIntoConstraints = false
        thumbView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            trackView.topAnchor.constraint(equalTo: topAnchor),
            trackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            trackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            trackView.widthAnchor.constraint(equalToConstant: sizeToken.width),
            trackView.heightAnchor.constraint(equalToConstant: sizeToken.height),

            thumbView.centerYAnchor.constraint(equalTo: trackView.centerYAnchor),
            thumbView.leadingAnchor.constraint(equalTo: trackView.leadingAnchor, constant: 2),
            thumbView.widthAnchor.constraint(equalToConstant: sizeToken.thumbSize),
            thumbView.heightAnchor.constraint(equalToConstant: sizeToken.thumbSize)
        ])

        trackView.layer.cornerRadius = sizeToken.height / 2
        thumbView.layer.cornerRadius = sizeToken.thumbSize / 2
    }

    private func setupAction() {
        addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }

    @objc private func handleTap() {
        isOn.toggle()
        sendActions(for: .valueChanged)
    }

    // MARK: - Appearance

    private func updateAppearance(animated: Bool) {
        let sizeToken = SizeToken(size: toggleSize)
        let trackColor = getTrackColor()

        if animated {
            UIView.animate(withDuration: 0.2) {
                self.trackView.backgroundColor = trackColor
                self.layoutIfNeeded()
            }
        } else {
            trackView.backgroundColor = trackColor
        }
    }

    private func getTrackColor() -> UIColor {
        if !isEnabled {
            return SemanticColor.Fg.Neutral.Ghost.disabled
        }
        return isOn ? SemanticColor.Fg.Secondary.default : SemanticColor.Fg.Neutral.ghost
    }
}

extension MDSToggle {
    struct SizeToken {
        let width: CGFloat
        let height: CGFloat
        let thumbSize: CGFloat
        
        init(size: Size) {
            switch size {
            case .small:
                width = 26
                height = 16
                thumbSize = 12
            case .large:
                width = 36
                height = 20
                thumbSize = 16
            }
        }
    }
}
