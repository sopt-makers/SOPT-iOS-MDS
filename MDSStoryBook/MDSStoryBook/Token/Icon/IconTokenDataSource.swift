//
//  IconTokenDataSource.swift
//  MDSStoryBook
//
//  Created by 최주리 on 5/20/26.
//

import MDS

enum IconTokenDataSource {
    static func sections() -> [(title: String, items: [IconTokenItem])] {
        [
            ("Communication", MDSIcon.Communication.all),
            ("Editor", MDSIcon.Editor.all),
            ("Feedback", MDSIcon.Feedback.all),
            ("Files", MDSIcon.Files.all),
            ("General", MDSIcon.General.all),
            ("Interaction", MDSIcon.Interaction.all),
            ("Media", MDSIcon.Media.all),
            ("Time", MDSIcon.Time.all),
            ("Users", MDSIcon.Users.all),
            ("Logo", MDSIcon.Logo.all),
        ].map { title, icons in
            (
                title: title,
                items: icons.map {
                    IconTokenItem(
                        name: $0.rawValue,
                        icon: $0
                    )
                }
            )
        }
    }
}
