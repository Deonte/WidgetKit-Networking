//
//  RepoWatcherWidgets.swift
//  RepoWatcherWidget
//
//  Created by Deonte Kilgore on 12/14/22.
//

import WidgetKit
import SwiftUI

@main
struct RepoWatcherWidgets: WidgetBundle {
    var body: some Widget {
        CompactRepoWidget()
        ContributorRepoWidget()
    }
}
