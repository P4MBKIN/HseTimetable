//
//  BaseDataResult.swift
//  HseTimetable
//
//  Created by Pavel on 19.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import Foundation

enum BaseDataResult {
    
    case lessons
    
    func requestDataResult(params: [String: String]?, addHeaders: [String: String]?, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        switch self {
        case .lessons:
            BaseDownload.downloadTask(
                request: BaseRequest.lessons.returnType(params: params, addHeaders: addHeaders),
                session: BaseSession.main.returnType()) { (data, error) in
                    completion(data, error)
            }
        }
    }
}
