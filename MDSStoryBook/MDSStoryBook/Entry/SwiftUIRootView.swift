//
//  SwiftUIRootView.swift
//  MDSStoryBook
//
//  Created by 이나연 on 11/16/26.
//

import SwiftUI

enum HomeRoute: Hashable {
    case token
    case component
}

struct SwiftUIRootView: View {
    var body: some View {
        NavigationStack {
            HomeView()
                .navigationDestination(for: HomeRoute.self) { route in
                    switch route {
                    case .token: TokenCategoryView()
                    case .component: Text("Component")
                    }
                }
        }
    }
}
