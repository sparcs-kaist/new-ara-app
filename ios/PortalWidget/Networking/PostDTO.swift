//
//  PostDTO.swift
//  PortalWidgetExtension
//
//  Created by 하정우 on 11/29/25.
//

import Foundation
import Moya

struct ResultDTO: Codable {
  var results: [PostDTO]
}

struct PostDTO: Codable {
  var id: Int
  var title: String
  var araID: Int
  var author: String
  var date: String
  
  enum CodingKeys: String, CodingKey {
    case id
    case title
    case araID = "ara_article"
    case author = "writer_department"
    case date = "registered_at"
  }
}

struct KeywordListDTO: Codable {
  var id: Int
  var title: String
}

extension PostDTO {
  func toModel(reason: DisplayReason) -> Post {
    Post(
      id: self.id,
      title: self.title,
      author: self.author,
      reason: reason,
      date: date.date ?? Date.distantPast
    )
  }
}

extension KeywordListDTO {
  func getPost(keyword: String) async -> Post? {
    let provider = MoyaProvider<PortalWidgetTarget>()
    
    do {
      let response = try await provider.request(.fetchNoticeByPostId(postId: self.id))
      let _ = try response.filterSuccessfulStatusCodes()
      
      let data = try response.map(PostDTO.self).toModel(reason: .keyword(word: keyword))
      return data
    } catch {
      return nil
    }
  }
}
