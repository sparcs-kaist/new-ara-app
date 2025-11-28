//
//  PostRow.swift
//  PortalWidgetExtension
//
//  Created by 하정우 on 11/28/25.
//

import SwiftUI

struct PostRow: View {
  let post: Post
  
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      HStack(alignment: .center) {
        Text(post.title)
          .font(.headline)
        
        Spacer()
        
        Text(post.author)
          .foregroundStyle(.secondary)
          .font(.caption)
      }
      
      Label(post.reason.localizedString, systemImage: reasonImage(reason: post.reason))
      .foregroundStyle(.secondary)
      .font(.caption)
    }
    .lineLimit(1)
  }
  
  func reasonImage(reason: DisplayReason) -> String {
    switch reason {
    case .trending:
      "chart.line.uptrend.xyaxis"
    case .board:
      "filemenu.and.selection"
    case .keyword:
      "tag"
    }
  }
}
