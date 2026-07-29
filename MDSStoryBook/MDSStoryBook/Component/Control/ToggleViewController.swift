import UIKit
import MDS

final class ToggleViewController: UIViewController {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 40
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Toggle"
        view.backgroundColor = .systemGroupedBackground
        setupLayout()
        addToggles()
    }

    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
    }

    private func addToggles() {
        addSection(title: "Large")
        addToggleRow(size: .large)

        addSection(title: "Small")
        addToggleRow(size: .small)
    }

    private func addSection(title: String) {
        let label = UILabel()
        label.text = title
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .bold)
        stackView.addArrangedSubview(label)
    }

    private func addToggleRow(size: MDSToggle.Size) {
        let horizontalStack = UIStackView()
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 20
        horizontalStack.alignment = .center
        horizontalStack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        horizontalStack.isLayoutMarginsRelativeArrangement = true
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false

        // Off
        let offToggle = MDSToggle(size: size)
        offToggle.isOn = false
        horizontalStack.addArrangedSubview(offToggle)

        // On
        let onToggle = MDSToggle(size: size)
        onToggle.isOn = true
        horizontalStack.addArrangedSubview(onToggle)

        // Disabled Off
        let disabledOffToggle = MDSToggle(size: size)
        disabledOffToggle.isOn = false
        disabledOffToggle.isEnabled = false
        horizontalStack.addArrangedSubview(disabledOffToggle)

        // Disabled On
        let disabledOnToggle = MDSToggle(size: size)
        disabledOnToggle.isOn = true
        disabledOnToggle.isEnabled = false
        horizontalStack.addArrangedSubview(disabledOnToggle)

        let card = UIView()
        card.backgroundColor = SemanticColor.Bg.Dim.default
        card.layer.cornerRadius = 12
        card.addSubview(horizontalStack)

        NSLayoutConstraint.activate([
            horizontalStack.topAnchor.constraint(equalTo: card.topAnchor),
            horizontalStack.bottomAnchor.constraint(equalTo: card.bottomAnchor),
            horizontalStack.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            horizontalStack.trailingAnchor.constraint(lessThanOrEqualTo: card.trailingAnchor),
        ])

        stackView.addArrangedSubview(card)
    }
}
