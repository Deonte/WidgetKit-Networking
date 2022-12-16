//
//  Contributor.swift
//  Repo Watcher
//
//  Created by Deonte Kilgore on 12/15/22.
//

import Foundation

struct Contributor: Identifiable {
    let id = UUID()
    let login: String
    let avatarUrl: String
    let contributions: Int
    var avatarData: Data
    
    struct CodingData: Decodable {
        let login: String
        let avatarUrl: String
        let contributions: Int
        
        var contributor: Contributor {
            Contributor(login: login, avatarUrl: avatarUrl, contributions: contributions, avatarData: Data())
        }
    }
}
