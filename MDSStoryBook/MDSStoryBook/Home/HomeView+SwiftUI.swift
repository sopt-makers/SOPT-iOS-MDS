//
//  HomeView+SwiftUI.swift
//  MDS
//
//  Created by 이나연 on 11/16/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        List {
            NavigationLink(value: HomeRoute.token) {
                Text("Token")
            }
            NavigationLink(value: HomeRoute.component) {
                Text("Component")
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("MDS Catalog")
    }
}
