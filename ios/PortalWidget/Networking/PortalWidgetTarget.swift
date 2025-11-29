//
//  PortalWidgetTarget.swift
//  PortalWidgetExtension
//
//  Created by 하정우 on 11/29/25.
//

import Foundation
import Moya

func readCookie() -> String {
  let userDefaults = UserDefaults(suiteName: "group.org.sparcs.new-ara-app")
  let cookie = userDefaults?.string(forKey: "user_cookie") ?? ""
  
  return cookie
}

enum PortalWidgetTarget {
  case fetchPostsByKeyword(keyword: String)
  case fetchPostsByBoardId(boardId: Int)
  case fetchTrendingPosts
  case fetchNoticeByPostId(postId: Int)
}

extension PortalWidgetTarget: TargetType {
  var baseURL: URL {
    #if DEBUG
    URL(string: "https://newara.dev.sparcs.org/api")!
    #else
    URL(string: "https://newara.sparcs.org/api")!
    #endif
  }
  
  var path: String {
    switch self {
    case .fetchPostsByKeyword:
      return "/articles"
    case .fetchPostsByBoardId:
      return "/kaist/portal_notice"
    case .fetchTrendingPosts:
      return "/kaist/portal_notice/trending"
    case .fetchNoticeByPostId:
      return "/kaist/portal_notice/by_article"
    }
  }
  
  var method: Moya.Method {
    .get
  }
  
  var task: Task {
    switch self {
    case .fetchPostsByKeyword(keyword: let keyword):
      return .requestParameters(parameters: ["main_search__contains": keyword, "parent_board": 1, "page": 1, "page_size": 5], encoding: URLEncoding.default)
    case .fetchPostsByBoardId(boardId: let boardId):
      return .requestParameters(parameters: ["board": boardId, "page": 1, "page_size": 5], encoding: URLEncoding.default)
    case .fetchTrendingPosts:
      return .requestPlain
    case .fetchNoticeByPostId(postId: let postId):
      return .requestParameters(parameters: ["ara_article": postId], encoding: URLEncoding.default)
    }
  }
  
  var headers: [String : String]? {
    ["Cookie": readCookie()]
  }
}
