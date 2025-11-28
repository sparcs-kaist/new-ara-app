//
//  PostEntry.swift
//  PortalWidgetExtension
//
//  Created by 하정우 on 11/28/25.
//

import WidgetKit
import SwiftUICore

enum DisplayReason: Equatable, Hashable {
  case trending
  case keyword(word: String)
  case board(selectedBoard: Board)
}

extension DisplayReason {
  var localizedString: LocalizedStringKey {
    switch self {
    case .trending:
      return LocalizedStringKey("Trending")
    case .keyword(let word):
      return LocalizedStringKey("Keyword \"\(word)\" detected")
    case .board(let selectedBoard):
      return LocalizedStringKey("Notice in \(selectedBoard.localizedString)")
    }
  }
}

struct Post: Hashable, Identifiable {
  var id: String
  var title: String
  var author: String
  var reason: DisplayReason
  var date: Date
}

extension Post {
  static var mock: Post {
    .init(id: UUID().uuidString, title: "Trending Post", author: "Admission Dept.", reason: .trending, date: Date())
  }
  
  static var mockList: [Post] =
    [
      .init(id: "1", title: "Trending Post", author: "Admission Dept.", reason: .trending, date: Date()),
      .init(id: "2", title: "Trending Post", author: "Admission Dept.", reason: .board(selectedBoard: .affiliates), date: Date()),
      .init(id: "3", title: "Trending Post", author: "Admission Dept.", reason: .board(selectedBoard: .affiliates), date: Date()),
      .init(id: "4", title: "Trending Post", author: "Admission Dept.", reason: .keyword(word: "Post"), date: Date()),
      .init(id: "5", title: "Trending Post", author: "Admission Dept.", reason: .keyword(word: "Trending"), date: Date()),
    ]
}

struct PostEntry: TimelineEntry {
  let date: Date
  let posts: [Post]
  let configuration: PortalWidgetConfigurationIntent
}

extension PostEntry {
  static var mock: PostEntry {
    .init(
      date: Date(),
      posts: Post.mockList,
      configuration: PortalWidgetConfigurationIntent()
    )
  }
}

// Since AppIntents are not supported on iOS 15, we have to translate `Board` enum and PortalWidgetConfiguration separately.
extension Board {
  var localizedString: String {
    switch self {
    case .generalNotice: return String(localized: "General Notice")
    case .intlComm: return String(localized: "International Community")
    case .intlCoop: return String(localized: "International Opportunities/Collaboration")
    case .itService: return String(localized: "IT Services")
    case .familyEvents: return String(localized: "Family Events")
    case .facultyClub: return String(localized: "Faculty Clubs")
    case .workStudyScholarship: return String(localized: "Work-Study Scholarship")
    case .newsLetter: return String(localized: "Newsletter")
    case .seminarAndEvent: return String(localized: "Seminars & Events")
    case .workManual: return String(localized: "Work Manual")
    case .studentCouncilNotice: return String(localized: "Student Council Notice")
    case .maintenanceNotice: return String(localized: "Maintenance Notice")
    case .affiliates: return String(localized: "Affiliates")
    case .startup: return String(localized: "Start-ups")
    case .sportsAndHealth: return String(localized: "Sports & Health Care")
    case .employment: return String(localized: "Employment")
    case .covid19: return String(localized: "COVID-19")
    case .studentClubs: return String(localized: "Student Clubs")
    case .curriculumChanges: return String(localized: "Curriculum Changes")
    case .leadershipAndInternship: return String(localized: "Leadership/Internship/Counseling")
    case .dormitory: return String(localized: "Dormitory")
    case .courseAndThesis: return String(localized: "Course/Academic Record/Thesis")
    case .scholarshipAndWelfare: return String(localized: "Scholarship & Welfare")
    case .researchPersonnel: return String(localized: "Technical Research Personnel")
    case .teachingAndLearning: return String(localized: "Teaching & Learning Board")
    case .library: return String(localized: "Library")
    case .unknown: return ""
    }
  }
}
