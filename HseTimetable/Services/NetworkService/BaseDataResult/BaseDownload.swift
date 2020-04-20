//
//  BaseDownload.swift
//  HseTimetable
//
//  Created by Pavel on 19.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import Foundation

struct BaseDownload {
    
    static func downloadTask(request: URLRequest,
                             session: URLSession,
                             completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else { return completion(nil, DownloadTaskError.nilDataError) }
            guard error == nil else { return completion(data, DownloadTaskError.requestError(error: error!)) }
            guard let res = response as? HTTPURLResponse else { return completion(data, DownloadTaskError.responseError) }
            guard (200...299).contains(res.statusCode) else { return completion(data, DownloadTaskError.serverError(status: res.statusCode)) }
            guard let mime = res.mimeType else { return completion(data, DownloadTaskError.getMineError) }
            guard mime == "application/json" else { return completion(data, DownloadTaskError.wrongMineError(mine: mime)) }
            
            do {
                _ = try JSONSerialization.jsonObject(with: data, options: [])
                completion(data, nil)
            } catch {
                completion(data, DownloadTaskError.jsonError(error: error.localizedDescription))
            }
        }
        task.resume()
    }
}

enum DownloadTaskError: Error {
    case nilDataError
    case requestError(error: Error)
    case responseError
    case serverError(status: Int)
    case getMineError
    case wrongMineError(mine: String)
    case jsonError(error: String)
}

extension DownloadTaskError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .nilDataError: return "DownloadTaskError - Data is nil!!!"
        case .requestError(let error): return "DownloadTaskError - Request error: \(error)!!!"
        case .responseError: return "DownloadTaskError - Response error!!!"
        case .serverError(let status): return "DownloadTaskError - Server error: \(status)!!!"
        case .getMineError: return "DownloadTaskError - Could not get MIME type!!!"
        case .wrongMineError(let mine): return "DownloadTaskError - Wrong MIME type: \(mine)!!!"
        case .jsonError(let error): return "DownloadTaskError - JSON error: \(error)!!!"
        }
    }
}
