//
//  NavigationBarUsageViewController.swift
//  MDSStoryBook
//

import UIKit
import MDS

/// 일반 VC처럼 push로 진입하는 예시입니다. 각 화면이 시스템 바를 숨기고 `MDSNavigationBar`를 subview로 직접 가집니다.

/// 목록 화면: 뒤로가기 + 로고
final class NavigationBarUsageHomeViewController: UIViewController {

    private let posts = (1...5).map { "게시글 \($0)" }

    private let navigationBar = MDSNavigationBar(title: .logo)

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // 바 배경과 맞춰 상태바 영역까지 색이 이어지게 합니다.
        view.backgroundColor = SemanticColor.Bg.Layer.basement

        navigationBar.onLeftIconTap = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PostCell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension NavigationBarUsageHomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        cell.backgroundColor = .clear
        cell.textLabel?.text = posts[indexPath.row]
        cell.textLabel?.textColor = SemanticColor.Fg.Neutral.bold
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detail = NavigationBarUsageDetailViewController(postTitle: posts[indexPath.row])
        navigationController?.pushViewController(detail, animated: true)
    }
}

/// 하위 화면: 뒤로가기 + 타이틀 + 우측 액션
final class NavigationBarUsageDetailViewController: UIViewController {

    private let postTitle: String
    private let navigationBar: MDSNavigationBar

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(postTitle: String) {
        self.postTitle = postTitle
        self.navigationBar = MDSNavigationBar(
            title: .title(postTitle),
            rightIcons: [.heartOutlined],
            rightButton: .actionButton("완료")
        )
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = SemanticColor.Bg.Layer.basement

        navigationBar.onLeftIconTap = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        navigationBar.onRightIconTap = { index in
            print("right icon tap: \(index)")
        }
        navigationBar.onRightButtonTap = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)
        view.addSubview(scrollView)
        scrollView.addSubview(bodyLabel)
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            scrollView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            bodyLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            bodyLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            bodyLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            bodyLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            bodyLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40),
        ])

        bodyLabel.text = "\(postTitle)의 본문입니다."
        bodyLabel.setTypography(Typography.body1, textColor: SemanticColor.Fg.Neutral.bold)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
