//
//  BaseUrl.swift
//  HseTimetable
//
//  Created by Pavel on 19.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import Foundation

struct BaseUrl {
    
    let scheme: BaseUrlScheme
    let host: BaseUrlHost
    let path: BaseUrlPath?
    var queryParams: [String: String] = [:]
    var urlComponents = URLComponents()
    
    mutating func urlConfigList() -> URL {
        self.urlComponents.scheme = self.scheme.rawValue
        self.urlComponents.host = self.host.rawValue
        self.urlComponents.path = self.path?.rawValue ?? ""
        self.urlComponents.setQueryItems(with: self.queryParams)
        guard let url = self.urlComponents.url else { fatalError("Could not create URL from components") }
        return url
    }
}

extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map{ URLQueryItem(name: $0.key, value: $0.value) }
    }
}
