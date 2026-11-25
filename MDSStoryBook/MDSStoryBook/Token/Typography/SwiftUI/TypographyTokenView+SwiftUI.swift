//
//  TypographyTokenView+SwiftUI.swift
//  MDSStoryBook
//
//  Created by 이나연 on 11/16/26.
//

import SwiftUI
import MDS

struct TypographyTokenView: View {
    private let sections = TypographyTokenDataSource.sections

    var body: some View {
        List {
            ForEach(sections, id: \.title) { section in
                Section {
                    ForEach(section.items, id: \.name) { item in
                        TypographyTokenRow(item: item)
                    }
                } header: {
                    Text(section.title)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Typography")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct TypographyTokenRow: View {
    let item: TypographyTokenItem

    private let sample = "다람쥐 헌 쳇바퀴에\n타고파"

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(item.name)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.secondary)

            Text(sample)
                .typography(item.mdsFont)
                .padding(.top, 4)

            Text(item.mdsFont.catalogDescription)
                .font(.system(size: 11, design: .monospaced))
                .foregroundStyle(.tertiary)
                .padding(.top, 6)
        }
        .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
    }
}
