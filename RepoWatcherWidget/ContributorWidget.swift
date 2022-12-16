//
//  ContributorWidget.swift
//  RepoWatcherWidgetExtension
//
//  Created by Deonte Kilgore on 12/15/22.
//

import SwiftUI
import WidgetKit

struct ContributorProvider: TimelineProvider {

    func placeholder(in context: Context) -> ContributorEntry {
        ContributorEntry(date: .now, repo: MockData.repoOne)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ContributorEntry) -> Void) {
        let entry = ContributorEntry(date: .now, repo: MockData.repoTwo)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ContributorEntry>) -> Void) {
        Task {
            let nextUpdate = Date().addingTimeInterval(43200) // 12 hours in seconds
            
            do {
                // Get Repo
                let repoToShow = RepoURL.swiftNews
                var repo = try await NetworkManager.shared.getRepo(atUrl: repoToShow)
                let avatarImageDataOne = await NetworkManager.shared.downloadImageData(from: repo.owner.avatarUrl)
                repo.avatarData = avatarImageDataOne ?? Data()
                
                // Get Contributors
                let contributors = try await NetworkManager.shared.getContributors(atUrl: repoToShow + "/contributors")
                
                // Filter to just top 4
                var topFour = Array(contributors.prefix(4))
                
                // Download Top Four Avatars
                for i in topFour.indices {
                    let avatarData = await NetworkManager.shared.downloadImageData(from: topFour[i].avatarUrl)
                    topFour[i].avatarData = avatarData ?? Data()
                }
                
                repo.contributors = topFour
                
                // Create Entry & Timeline
                let entry = ContributorEntry(date: .now, repo: repo)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            } catch {
                print("❌ Error: - \(error.localizedDescription)")
            }
            
            
        }
    }
    
}

struct ContributorEntry: TimelineEntry {
    var date: Date
    let repo: Repository
}

struct ContributorRepoEntryView : View {
    var entry: ContributorEntry
    
    var body: some View {
        VStack {
            RepoMediumView(repo: entry.repo)
            ContributorMediumView(repo: entry.repo)
        }
    }
}

struct ContributorRepoWidget: Widget {
    let kind: String = "ContributorRepoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ContributorProvider()) { entry in
            ContributorRepoEntryView(entry: entry)
        }
        .configurationDisplayName("Contributors")
        .description("Keep an eye on one or two Github repositories.")
        .supportedFamilies([.systemLarge])
    }
}

struct ContributorRepoWidget_Previews: PreviewProvider {
    static var previews: some View {
        ContributorRepoEntryView(entry: ContributorEntry(date: .now, repo: MockData.repoOne))
        .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
