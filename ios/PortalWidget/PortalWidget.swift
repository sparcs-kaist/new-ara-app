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
  
  private var portalWidgetAPI = PortalWidgetAPI()
  
  func placeholder(in context: Context) -> PostEntry {
    .mock
  }
 
  func getSnapshot(for configuration: PortalWidgetConfigurationIntent, in context: Context, completion: @escaping (PostEntry) -> ()) {
    let entry = PostEntry(date: Date(), posts: Post.mockList, configuration: configuration)
    completion(entry)
  }

  func getTimeline(for configuration: PortalWidgetConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    Task {
      let entry = await PostEntry(
        date: Date(),
        posts: portalWidgetAPI.fetchPosts(for: configuration),
        configuration: configuration
      )
      let currentDate = Date()
      let refreshDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
      
      let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
      completion(timeline)
    }
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
          Link(destination: URL(string: "newara://post/\(post.id)")!) {
            PostRow(post: post)
          }
          
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
