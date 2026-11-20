//
//  TokenCategoryView+SwiftUI.swift
//  MDSStoryBook
//
//  Created by 이나연 on 11/16/26.
//

import SwiftUI

enum TokenCategory: String, CaseIterable, Identifiable {
    case color = "Color"
    case typography = "Typography"
    case spacing = "Spacing"
    case radius = "Radius"
    case icon = "Icon"
    case baseColor = "Base Color"
    case baseTypography = "Base Typography"
    
    var id: Self { self }
}

struct TokenCategoryView: View {
    var body: some View {
        List(TokenCategory.allCases) { category in
            NavigationLink(value: category) {
                Text(category.rawValue)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Token")
        .navigationDestination(for: TokenCategory.self) { category in
            switch category {
            case .typography: TypographyTokenView()
            case .baseTypography: BaseTypographyView()
            default: Text(category.rawValue)
            }
        }
    }
}
