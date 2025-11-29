//
//  PortalWidgetAPI.swift
//  PortalWidgetExtension
//
//  Created by 하정우 on 11/29/25.
//

import Foundation
import Moya

class PortalWidgetAPI {
  let provider = MoyaProvider<PortalWidgetTarget>()
  
  func fetchPostsByKeyword(_ keyword: String) async -> [Post] {
    do {
      let response = try await provider.request(.fetchPostsByKeyword(keyword: keyword))
      let _ = try response.filterSuccessfulStatusCodes()
      
      let posts = try response.map(ResultDTO.self).results.compactMap { $0.toModel(reason: .keyword(word: keyword)) }
      
      return posts
    } catch {
      return []
    }
  }
  
  func fetchPostsByBoardId(_ board: Board) async -> [Post] {
    do {
      let response = try await provider.request(.fetchPostsByBoardId(boardId: board.rawValue))
      let _ = try response.filterSuccessfulStatusCodes()
      
      let posts = try response.map(ResultDTO.self).results.compactMap { $0.toModel(reason: .board(selectedBoard: board)) }
      
      return posts
    } catch {
      return []
    }
  }
  
  func fetchTrendingPosts() async -> [Post] {
    do {
      let response = try await provider.request(.fetchTrendingPosts)
      let _ = try response.filterSuccessfulStatusCodes()
      
      let posts = try response.map([PostDTO].self).compactMap { $0.toModel(reason: .trending) }
      
      return posts
    } catch {
      return []
    }
  }
  
  func fetchPosts(for configuration: PortalWidgetConfigurationIntent) async -> [Post]{
    var result: [Post] = []
    
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
      await result.append(contentsOf: fetchTrendingPosts())
    }
    
    if let keywords {
      for keyword in keywords {
        await result.append(contentsOf: fetchPostsByKeyword(keyword))
      }
    }
    
    if let selectedBoard {
      await result.append(contentsOf: fetchPostsByBoardId(selectedBoard))
    }
    
    return result.sorted { $0.date > $1.date }
  }
}
