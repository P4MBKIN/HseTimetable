//
//  LessonsError.swift
//  HseTimetable
//
//  Created by Pavel on 21.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import Foundation

struct ErrorDetail: Decodable {
    
    let name: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case message
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String?.self, forKey: .name)
        self.message = try container.decode(String?.self, forKey: .message)
    }
}

struct LessonsError: Decodable, Error {
    
    let error: ErrorDetail?
    
    enum CodingKeys: String, CodingKey {
        case error
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.error = try container.decode(ErrorDetail?.self, forKey: .error)
    }
}

extension LessonsError: CustomStringConvertible {
    
    var description: String {
        return  """
                LessonsError!!!
                name: \(self.error?.name ?? "")
                message: \(self.error?.message ?? "")
                """
    }
}

extension LessonsError: LocalizedError {
    
    var errorDescription: String? { return self.description }
}
