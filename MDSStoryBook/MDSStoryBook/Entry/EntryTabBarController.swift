//
//  EntryTabBarController.swift
//  MDSStoryBook
//
//  Created by 이나연 on 11/18/26.
//

import UIKit

/// UIKit / SwiftUI 카탈로그를 탭으로 전환합니다.
final class EntryTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [makeUIKitTab(), makeSwiftUITab()]
    }

    private func makeUIKitTab() -> UIViewController {
        let navigationController = UINavigationController(rootViewController: HomeViewController())
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.tabBarItem = UITabBarItem(
            title: "UIKit",
            image: UIImage(systemName: "square.stack.3d.up"),
            selectedImage: UIImage(systemName: "square.stack.3d.up.fill")
        )
        return navigationController
    }

    private func makeSwiftUITab() -> UIViewController {
        let hostingController = SwiftUIRootHostingController()
        hostingController.tabBarItem = UITabBarItem(
            title: "SwiftUI",
            image: UIImage(systemName: "swift"),
            selectedImage: UIImage(systemName: "swift")
        )
        return hostingController
    }
}
