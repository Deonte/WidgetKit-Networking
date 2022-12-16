//
//  MockData.swift
//  RepoWatcherWidgetExtension
//
//  Created by Deonte Kilgore on 12/15/22.
//

import Foundation

struct MockData {
    
    static let repoOne = Repository(name: "Repository 1",
                                    owner: Owner(avatarUrl: ""),
                                    hasIssues: true,
                                    forks: 1452,
                                    watchers: 189,
                                    openIssues: 32,
                                    pushedAt: "2022-09-26T19:06:43Z",
                                    avatarData: Data(),
                                    contributors: [
                                        Contributor(login: "Deonte", avatarUrl: "", contributions: 70, avatarData: Data()),
                                        Contributor(login: "Deonte", avatarUrl: "", contributions: 70, avatarData: Data()),
                                        Contributor(login: "Deonte", avatarUrl: "", contributions: 70, avatarData: Data()),
                                        Contributor(login: "Deonte", avatarUrl: "", contributions: 70, avatarData: Data())]
                )
    
    static let repoTwo = Repository(name: "Repository 2",
                                    owner: Owner(avatarUrl: ""),
                                    hasIssues: true,
                                    forks: 20,
                                    watchers: 28,
                                    openIssues: 15,
                                    pushedAt: "2022-11-26T19:06:43Z",
                                    avatarData: Data())
}
