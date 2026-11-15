//
//  BaseTypographyView+SwiftUI.swift
//  MDSStoryBook
//
//  Created by 이나연 on 11/16/26.
//

import SwiftUI
@_spi(MDSCatalog) import MDS

struct BaseTypographyView: View {
    private let groups = BaseTypographyCatalogData.groups
    
    var body: some View {
        List {
            ForEach(groups.indices, id: \.self) { index in
                let group = groups[index]
                Section {
                    ForEach(group.entries, id: \.name) { entry in
                        BaseTypographyRow(entry: entry, category: group.categoryName)
                    }
                } header: {
                    Text(group.categoryName)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Base Typography")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct BaseTypographyRow: View {
    let entry: BaseTypographyCatalogEntry
    let category: String
    
    private let sample = "다람쥐 헌 쳇바퀴에 타고파"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(entry.name)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.secondary)
            
            preview
                .padding(.top, 4)
            
            Text(subtitle)
                .font(.system(size: 11, design: .monospaced))
                .foregroundStyle(.tertiary)
                .padding(.top, 6)
        }
        .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
    }
    
    private var subtitle: String {
        switch category {
        case "weight":        return "\(Int(entry.value))"
        case "letterSpacing": return "\(entry.value)%"
        default:              return "\(Int(entry.value))px"
        }
    }
    
    @ViewBuilder
    private var preview: some View {
        switch category {
        case "weight":
            Text(sample)
                .font(.system(size: 17, weight: weight))

        case "size":
            Text(sample)
                .font(.system(size: entry.value))

        case "lineHeight":
            let fontLineHeight = UIFont.systemFont(ofSize: 14).lineHeight
            let extra = max(entry.value - fontLineHeight, 0)
            Text("다람쥐 헌 쳇바퀴에\n타고파")
                .font(.system(size: 14))
                .lineSpacing(extra)
                .padding(.top, extra)

        case "letterSpacing":
            let fontSize: CGFloat = 17
            Text(sample)
                .font(.system(size: fontSize))
                .kerning(fontSize * (entry.value / 100))
            
        default:
            Text(sample)
        }
    }
    
    private var weight: Font.Weight {
        switch Int(entry.value) {
        case 700: return .bold
        case 600: return .semibold
        default:  return .regular
        }
    }
}
