//
//  MDSRadioGroup.swift
//  MDS
//

import UIKit

@MainActor
public final class MDSRadioGroup {

    // MARK: - Properties

    public var onSelectionChanged: ((Int) -> Void)?

    private var buttons: [MDSRadioButton] = []

    // MARK: - Init

    public init() {}

    // MARK: - Interface

    public func add(_ button: MDSRadioButton) {
        buttons.append(button)
        button.addAction(UIAction { [weak self] _ in
            self?.radioTapped(button)
        }, for: .valueChanged)
    }

    public func add(_ buttons: [MDSRadioButton]) {
        buttons.forEach { add($0) }
    }

    // MARK: - Action

    private func radioTapped(_ sender: MDSRadioButton) {
        buttons.forEach { $0.isSelected = ($0 === sender) }
        guard let index = buttons.firstIndex(where: { $0 === sender }) else { return }
        onSelectionChanged?(index)
    }
}
