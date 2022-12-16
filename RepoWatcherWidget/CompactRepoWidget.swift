//
//  RepoWatcherWidget.swift
//  RepoWatcherWidget
//
//  Created by Deonte Kilgore on 12/14/22.
//

import WidgetKit
import SwiftUI

struct CompactRepoProvider: TimelineProvider {
    func placeholder(in context: Context) -> CompactRepoEntry {
        CompactRepoEntry(date: Date(), repo: MockData.repoOne, bottomRepo: MockData.repoTwo)
    }

    func getSnapshot(in context: Context, completion: @escaping (CompactRepoEntry) -> ()) {
        let entry = CompactRepoEntry(date: Date(), repo: MockData.repoOne, bottomRepo: MockData.repoTwo)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            let nextUpdate = Date().addingTimeInterval(43200) // 12 hours in seconds
         
            do {
                // Get top repo
                var repoOne = try await NetworkManager.shared.getRepo(atUrl: RepoURL.swiftNews)
                let avatarImageDataOne = await NetworkManager.shared.downloadImageData(from: repoOne.owner.avatarUrl)
                repoOne.avatarData = avatarImageDataOne ?? Data()
                
                var bottomRepo: Repository?
                if context.family == .systemLarge {
                    bottomRepo = try await NetworkManager.shared.getRepo(atUrl: RepoURL.publish)
                    let avatarImageDataTwo = await NetworkManager.shared.downloadImageData(from: bottomRepo!.owner.avatarUrl)
                    bottomRepo!.avatarData = avatarImageDataTwo ?? Data()
                }
                
                // Create entry and timeline
                let entry = CompactRepoEntry(date: .now, repo: repoOne, bottomRepo: bottomRepo)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
                
            } catch {
                print("❌ Error: - \(error.localizedDescription)")
            }
        }
    }
}

struct CompactRepoEntry: TimelineEntry {
    let date: Date
    let repo: Repository
    let bottomRepo: Repository?
}

struct CompactRepoEntryView : View {
    var entry: CompactRepoEntry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemMedium:
            RepoMediumView(repo: entry.repo)
        case .systemLarge:
            VStack(spacing: 36) {
                RepoMediumView(repo: entry.repo)
                if let repoTwo = entry.bottomRepo {
                    RepoMediumView(repo: repoTwo)
                }
            }
        case .systemSmall, .systemExtraLarge, .accessoryCircular, .accessoryRectangular, .accessoryInline:
            EmptyView()
        @unknown default:
            EmptyView()
        }
    }
}

struct CompactRepoWidget: Widget {
    let kind: String = "CompactRepoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CompactRepoProvider()) { entry in
            CompactRepoEntryView(entry: entry)
        }
        .configurationDisplayName("Repo Watcher")
        .description("Keep an eye on one or two Github repositories.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

struct CompactRepoWidget_Previews: PreviewProvider {
    static var previews: some View {
        CompactRepoEntryView(entry: CompactRepoEntry(date: Date(),
                                                    repo: MockData.repoOne,
                                                    bottomRepo: MockData.repoTwo))
        .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
