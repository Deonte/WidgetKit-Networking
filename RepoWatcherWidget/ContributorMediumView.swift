//
//  ContributorMediumView.swift
//  Repo Watcher
//
//  Created by Deonte Kilgore on 12/15/22.
//

import SwiftUI
import WidgetKit

struct ContributorMediumView: View {
    let repo: Repository
    
    var body: some View {
        VStack {
            HStack {
                Text("Top Contributors")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
            }
            
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible()), count: 2),
                alignment: .leading,
                spacing: 20
            ) {
                ForEach(repo.contributors) { contributor in
                    HStack {
                        Image(uiImage: UIImage(data: contributor.avatarData) ?? UIImage(named: "avatar")!)
                            .resizable()
                            .frame(width: 44, height: 44)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading) {
                            Text(contributor.login)
                                .font(.caption)
                            Text("\(contributor.contributions)")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
            if repo.contributors.count < 3 {
                Spacer()
            }
        }
        .padding()
    }
}

struct ContributorMediumView_Previews: PreviewProvider {
    static var previews: some View {
        ContributorMediumView(repo: MockData.repoOne)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
