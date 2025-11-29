//
//  String+Extensions.swift
//  PortalWidgetExtension
//
//  Created by 하정우 on 11/29/25.
//

import Foundation

extension String {
  var date: Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    
    return formatter.date(from: self)
  }
}
