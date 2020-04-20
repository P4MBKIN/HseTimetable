//
//  BaseRequest.swift
//  HseTimetable
//
//  Created by Pavel on 19.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import Foundation

enum BaseRequest {
    
    case lessons
    
    func returnType(params: [String: String]?, addHeaders: [String: String]?) -> URLRequest {
        switch self {
        case .lessons:
            var url = BaseUrl.init(scheme: .https, host: .hseApi, path: .lessons)
            
            var headers = [String: String]()
            let baseHeaders = BaseHeaders.lessons.returnType()
            baseHeaders?.forEach {
                headers[$0.key] = $0.value
            }
            addHeaders?.forEach {
                headers[$0.key] = $0.value
            }
            
            let baseParams = BaseParams.lessons.returnType()
            params?.forEach {
                url.queryParams.updateValue($0.value, forKey: $0.key)
            }
            baseParams?.forEach {
                url.queryParams.updateValue($0.value, forKey: $0.key)
            }
            
            var request = URLRequest(url: url.urlConfigList())
            request.httpMethod = BaseMethod.lessons.rawValue
            request.allHTTPHeaderFields = headers
            request.timeoutInterval = 60
            return request
        }
    }
}
