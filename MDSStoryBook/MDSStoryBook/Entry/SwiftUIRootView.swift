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
    var onClose: () -> Void
    
    var body: some View {
        NavigationStack {
            HomeView()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: onClose) {
                            Image(systemName: "chevron.left")
                        }
                    }
                }
                .navigationDestination(for: HomeRoute.self) { route in
                    switch route {
                    case .token: TokenCategoryView()
                    case .component: Text("Component")
                    }
                }
        }
    }
}
