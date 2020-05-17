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
        case .nilDataError: return "Получено пустое значение"
        case .requestError(let error): return "Ошибка в запросе: \(error)"
        case .responseError: return "Ошибка в отклике"
        case .serverError(let status): return "Ошибка от сервера: \(status)"
        case .getMineError: return "Не получен MIME тип"
        case .wrongMineError(let mine): return "Неправильный MIME тип: \(mine)"
        case .jsonError(let error): return "Ошибка JSON: \(error)"
        }
    }
}
