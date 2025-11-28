//
//  PortalWidget.swift
//  PortalWidget
//
//  Created by 하정우 on 11/28/25.
//

import WidgetKit
import SwiftUI

struct Provider: IntentTimelineProvider {
  typealias Entry = PostEntry
  typealias Intent = PortalWidgetConfigurationIntent
  
  func placeholder(in context: Context) -> PostEntry {
    .mock
  }

  func getSnapshot(for configuration: PortalWidgetConfigurationIntent, in context: Context, completion: @escaping (PostEntry) -> ()) {
    let entry = PostEntry(date: Date(), posts: Post.mockList, configuration: configuration)
    completion(entry)
  }

  func getTimeline(for configuration: PortalWidgetConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    var entries: [PostEntry] = []
    var posts: [Post] = []
    
    var showTrending: Bool {
      (configuration.showTrending ?? 0) == 1
    }
    
    var keywords: [String]? {
      guard configuration.showKeyword == 1 else { return nil }
      
      return configuration.keyword
    }
    
    var selectedBoard: Board? {
      guard configuration.showBoard == 1 else { return nil }
      
      return configuration.selectedBoard
    }
    
    if showTrending {
      // TODO: fetch trending posts
      posts.append(contentsOf: Post.mockList)
    }
    
    if let keywords {
      // TODO: fetch keyword posts
      posts.append(contentsOf: Post.mockList)
    }
    
    if let selectedBoard {
      // TODO: fetch board specific posts
      posts.append(contentsOf: Post.mockList)
    }
    
    posts.sort { $0.date > $1.date }

    let entry = PostEntry(
      date: Date(),
      posts: Array(posts.prefix(5)),
      configuration: configuration
    )
    entries.append(entry)

    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}

struct PortalWidgetEntryView : View {
  @Environment(\.widgetFamily) private var widgetFamily
  
  var entry: Provider.Entry
  
  var maxPosts: Int {
    widgetFamily == .systemMedium ? 2 : 5
  }
  
  var posts: [Post] {
    Array(entry.posts.prefix(maxPosts))
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Label("Portal Notices", systemImage: "tray.full")
        .font(.caption)
        .foregroundStyle(.accent)
        .frame(height: 10)
      Divider()
      
      if !posts.isEmpty {
        ForEach(posts) { post in
          PostRow(post: post)
          
          if post.id != posts.last?.id {
            Divider()
          }
        }
        
        if posts.count < maxPosts {
          Spacer()
        }
      } else {
        Text("No posts found")
          .foregroundStyle(.secondary)
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
      }
    }
  }
}

struct PortalWidget: Widget {
  let kind: String = "PortalWidget"

  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: PortalWidgetConfigurationIntent.self, provider: Provider()) { entry in
      if #available(iOS 17.0, *) {
        PortalWidgetEntryView(entry: entry)
          .containerBackground(.background, for: .widget)
      } else {
        PortalWidgetEntryView(entry: entry)
          .padding()
          .background()
      }
    }
    .supportedFamilies([.systemMedium, .systemLarge])
    .configurationDisplayName("Portal Notice Widget")
    .description("Widget for KAIST Portal Notice.")
  }
}

struct PortalWidget_Previews: PreviewProvider {
  static var previews: some View {
    let entry: PostEntry = .mock
    
    Group {
      Group {
        if #available(iOS 17.0, *) {
          PortalWidgetEntryView(entry: entry)
            .containerBackground(.background, for: .widget)
        } else {
          PortalWidgetEntryView(entry: entry)
              .padding()
              .background()
        }
      }
      .previewContext(WidgetPreviewContext(family: .systemMedium))
      .previewDisplayName("System Medium")
      
      Group {
        if #available(iOS 17.0, *) {
          PortalWidgetEntryView(entry: entry)
            .containerBackground(.background, for: .widget)
        } else {
          PortalWidgetEntryView(entry: entry)
              .padding()
              .background()
        }
      }
      .previewContext(WidgetPreviewContext(family: .systemLarge))
      .previewDisplayName("System Large")
    }
  }
}
