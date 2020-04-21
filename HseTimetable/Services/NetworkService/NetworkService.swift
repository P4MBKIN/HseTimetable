//
//  NetworkService.swift
//  HseTimetable
//
//  Created by Pavel on 19.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import Foundation

class NetworkService: NetworkServiceProtocol {
    
    func lessonsGet<Model: Decodable, ErrorModel: Decodable>(studentId: Int,
                                                             daysOffset: Int,
                                                             dateFrom: Date,
                                                             completion: @escaping ((Model?, ErrorModel?, Error?) -> Void)) {
        var params = [String: String]()
        params["studnet"] = String(studentId)
        params["offset"] = String(daysOffset)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        params["start"] = formatter.string(from: dateFrom)
        
        BaseDataResult.lessons.requestDataResult(params: params, addHeaders: nil) { (data, error) in
            guard let data = data else { return completion(nil, nil, BaseResultError.nilDataError) }
            guard error == nil else {
                let (errorModel, _): (ErrorModel?, Error?) = parseJson(data: data)
                return completion(nil, errorModel, error)
            }
            let (model, parseError): (Model?, Error?) = parseJson(data: data)
            if model != nil { return completion(model, nil, nil) }
            else { return completion(nil, nil, parseError) }
        }
    }
}

enum BaseResultError: Error {
    case nilDataError
}

extension BaseResultError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .nilDataError: return "Data is nil!!!"
        }
    }
}