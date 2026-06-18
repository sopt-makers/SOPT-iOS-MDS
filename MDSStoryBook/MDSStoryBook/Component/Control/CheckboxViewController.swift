import UIKit
import MDS

final class CheckboxViewController: UIViewController {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 40
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Checkbox"
        view.backgroundColor = SemanticColor.Bg.Layer.basement
        setupLayout()
        addCheckboxes()
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

    private func addCheckboxes() {
        addSection(title: "Large Size (24)")
        addCheckboxRow(size: .large)

        addSection(title: "Small Size (20)")
        addCheckboxRow(size: .small)
    }

    private func addSection(title: String) {
        let label = UILabel()
        label.text = title
        label.textColor = SemanticColor.Fg.Neutral.bold
        label.font = Typography.title1.font
        stackView.addArrangedSubview(label)
    }

    private func addCheckboxRow(size: MDSCheckbox.Size) {
        let rowStack = UIStackView()
        rowStack.axis = .vertical
        rowStack.spacing = 16
        rowStack.alignment = .leading

        // Unselected
        let unselected = MDSCheckbox(size: size, title: "Label")
        unselected.isSelected = false
        rowStack.addArrangedSubview(unselected)

        // Selected
        let selected = MDSCheckbox(size: size, title: "Label")
        selected.isSelected = true
        rowStack.addArrangedSubview(selected)

        // Disabled Unselected
        let disabledUnselected = MDSCheckbox(size: size, title: "Label")
        disabledUnselected.isSelected = false
        disabledUnselected.isEnabled = false
        rowStack.addArrangedSubview(disabledUnselected)

        // Disabled Selected
        let disabledSelected = MDSCheckbox(size: size, title: "Label")
        disabledSelected.isSelected = true
        disabledSelected.isEnabled = false
        rowStack.addArrangedSubview(disabledSelected)

        stackView.addArrangedSubview(rowStack)
    }
}
