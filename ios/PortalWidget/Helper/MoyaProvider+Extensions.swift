//
//  MoyaProvider+Extensions.swift
//  PortalWidgetExtension
//
//  Created by 하정우 on 11/29/25.
//

import Foundation
import Moya

extension MoyaProvider {
  func request(_ target: Target) async throws -> Response {
    return try await withCheckedThrowingContinuation { continuation in
      self.request(target) { result in
        switch result {
        case .success(let response):
          continuation.resume(returning: response)
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
}
