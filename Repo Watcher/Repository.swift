//
//  Repository.swift
//  Repo Watcher
//
//  Created by Deonte Kilgore on 12/14/22.
//

import Foundation

struct Repository: Decodable {
    let name: String
    let owner: Owner
    let hasIssues: Bool
    let forks: Int
    let watchers: Int
    let openIssues: Int
    let pushedAt: String
    
    static let placeholder = Repository(name: "Your Repo", owner: Owner(avatarUrl: ""), hasIssues: true, forks: 65, watchers: 123, openIssues: 64, pushedAt: "2022-01-26T19:06:43Z")
}

struct Owner: Decodable {
    let avatarUrl: String
}
