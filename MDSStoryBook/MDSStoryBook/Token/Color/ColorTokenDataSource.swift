//
//  ColorTokenDataSource.swift
//  MDSStoryBook
//
//  Created by 강윤서 on 5/8/26.
//

import MDS

enum ColorTokenDataSource {
    static let sections: [ColorTokenSection] = [
        ColorTokenSection(title: "Bg / Neutral", items: [
            ColorTokenItem(name: "inverse", color: SemanticColor.Bg.Neutral.inverse),
            ColorTokenItem(name: "bold",    color: SemanticColor.Bg.Neutral.bold),
            ColorTokenItem(name: "default", color: SemanticColor.Bg.Neutral.`default`),
            ColorTokenItem(name: "subtle",  color: SemanticColor.Bg.Neutral.subtle),
            ColorTokenItem(name: "ghost",   color: SemanticColor.Bg.Neutral.ghost),
        ]),
        ColorTokenSection(title: "Bg / Neutral (States)", items: [
            ColorTokenItem(name: "inverse · hover",    color: SemanticColor.Bg.Neutral.Inverse.hover),
            ColorTokenItem(name: "inverse · pressed",  color: SemanticColor.Bg.Neutral.Inverse.pressed),
            ColorTokenItem(name: "bold · disabled",    color: SemanticColor.Bg.Neutral.Bold.disabled),
            ColorTokenItem(name: "default · hover",    color: SemanticColor.Bg.Neutral.Default.hover),
            ColorTokenItem(name: "default · pressed",  color: SemanticColor.Bg.Neutral.Default.pressed),
            ColorTokenItem(name: "default · disabled", color: SemanticColor.Bg.Neutral.Default.disabled),
            ColorTokenItem(name: "subtle · hover",     color: SemanticColor.Bg.Neutral.Subtle.hover),
            ColorTokenItem(name: "subtle · pressed",   color: SemanticColor.Bg.Neutral.Subtle.pressed),
            ColorTokenItem(name: "ghost · hover",      color: SemanticColor.Bg.Neutral.Ghost.hover),
            ColorTokenItem(name: "ghost · pressed",    color: SemanticColor.Bg.Neutral.Ghost.pressed),
        ]),
        ColorTokenSection(title: "Bg / Brand", items: [
            ColorTokenItem(name: "default", color: SemanticColor.Bg.Brand.`default`),
            ColorTokenItem(name: "subtle",  color: SemanticColor.Bg.Brand.subtle),
            ColorTokenItem(name: "ghost",   color: SemanticColor.Bg.Brand.ghost),
        ]),
        ColorTokenSection(title: "Bg / Secondary", items: [
            ColorTokenItem(name: "default",           color: SemanticColor.Bg.Secondary.`default`),
            ColorTokenItem(name: "subtle",            color: SemanticColor.Bg.Secondary.subtle),
            ColorTokenItem(name: "ghost",             color: SemanticColor.Bg.Secondary.ghost),
            ColorTokenItem(name: "default · hover",   color: SemanticColor.Bg.Secondary.Default.hover),
            ColorTokenItem(name: "default · pressed", color: SemanticColor.Bg.Secondary.Default.pressed),
        ]),
        ColorTokenSection(title: "Bg / Danger", items: [
            ColorTokenItem(name: "default",           color: SemanticColor.Bg.Danger.`default`),
            ColorTokenItem(name: "ghost",             color: SemanticColor.Bg.Danger.ghost),
            ColorTokenItem(name: "default · hover",   color: SemanticColor.Bg.Danger.Default.hover),
            ColorTokenItem(name: "default · pressed", color: SemanticColor.Bg.Danger.Default.pressed),
        ]),
        ColorTokenSection(title: "Bg / Information", items: [
            ColorTokenItem(name: "ghost", color: SemanticColor.Bg.Information.ghost),
        ]),
        ColorTokenSection(title: "Bg / Success", items: [
            ColorTokenItem(name: "ghost", color: SemanticColor.Bg.Success.ghost),
        ]),
        ColorTokenSection(title: "Bg / Dim", items: [
            ColorTokenItem(name: "default", color: SemanticColor.Bg.Dim.`default`),
        ]),
        ColorTokenSection(title: "Fg / Neutral", items: [
            ColorTokenItem(name: "bold",              color: SemanticColor.Fg.Neutral.bold),
            ColorTokenItem(name: "default",           color: SemanticColor.Fg.Neutral.`default`),
            ColorTokenItem(name: "subtle",            color: SemanticColor.Fg.Neutral.subtle),
            ColorTokenItem(name: "ghost",             color: SemanticColor.Fg.Neutral.ghost),
            ColorTokenItem(name: "inverse",           color: SemanticColor.Fg.Neutral.inverse),
            ColorTokenItem(name: "default · disabled",color: SemanticColor.Fg.Neutral.Default.disabled),
        ]),
        ColorTokenSection(title: "Fg / Brand", items: [
            ColorTokenItem(name: "default", color: SemanticColor.Fg.Brand.`default`),
        ]),
        ColorTokenSection(title: "Fg / Secondary", items: [
            ColorTokenItem(name: "default", color: SemanticColor.Fg.Secondary.`default`),
        ]),
        ColorTokenSection(title: "Fg / Success", items: [
            ColorTokenItem(name: "bold",    color: SemanticColor.Fg.Success.bold),
            ColorTokenItem(name: "default", color: SemanticColor.Fg.Success.`default`),
            ColorTokenItem(name: "subtle",  color: SemanticColor.Fg.Success.subtle),
        ]),
        ColorTokenSection(title: "Fg / Danger", items: [
            ColorTokenItem(name: "bold",    color: SemanticColor.Fg.Danger.bold),
            ColorTokenItem(name: "default", color: SemanticColor.Fg.Danger.`default`),
            ColorTokenItem(name: "subtle",  color: SemanticColor.Fg.Danger.subtle),
        ]),
        ColorTokenSection(title: "Fg / Attention", items: [
            ColorTokenItem(name: "bold",    color: SemanticColor.Fg.Attention.bold),
            ColorTokenItem(name: "default", color: SemanticColor.Fg.Attention.`default`),
            ColorTokenItem(name: "subtle",  color: SemanticColor.Fg.Attention.subtle),
        ]),
        ColorTokenSection(title: "Fg / Information", items: [
            ColorTokenItem(name: "default", color: SemanticColor.Fg.Information.`default`),
            ColorTokenItem(name: "subtle",  color: SemanticColor.Fg.Information.subtle),
        ]),
        ColorTokenSection(title: "Stroke / Neutral", items: [
            ColorTokenItem(name: "default",            color: SemanticColor.Stroke.Neutral.`default`),
            ColorTokenItem(name: "inverse",            color: SemanticColor.Stroke.Neutral.inverse),
            ColorTokenItem(name: "subtle",             color: SemanticColor.Stroke.Neutral.subtle),
            ColorTokenItem(name: "ghost",              color: SemanticColor.Stroke.Neutral.ghost),
            ColorTokenItem(name: "default · focused",  color: SemanticColor.Stroke.Neutral.Default.focused),
            ColorTokenItem(name: "default · disabled", color: SemanticColor.Stroke.Neutral.Default.disabled),
        ]),
        ColorTokenSection(title: "Stroke / Brand", items: [
            ColorTokenItem(name: "default", color: SemanticColor.Stroke.Brand.`default`),
            ColorTokenItem(name: "subtle",  color: SemanticColor.Stroke.Brand.subtle),
        ]),
        ColorTokenSection(title: "Stroke / Secondary", items: [
            ColorTokenItem(name: "default", color: SemanticColor.Stroke.Secondary.`default`),
            ColorTokenItem(name: "subtle",  color: SemanticColor.Stroke.Secondary.subtle),
        ]),
        ColorTokenSection(title: "Stroke / Information", items: [
            ColorTokenItem(name: "subtle", color: SemanticColor.Stroke.Information.subtle),
        ]),
        ColorTokenSection(title: "Stroke / Danger", items: [
            ColorTokenItem(name: "default", color: SemanticColor.Stroke.Danger.`default`),
        ]),
    ]
}
