//
//  Auth.swift
//  HseTimetable
//
//  Created by Pavel on 13.05.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import Foundation

struct AdditionalAuthInfo: Decodable {
    
    let groupName: String?
    let group: Int?
    let email: String?
    
    enum CodingKeys: String, CodingKey {
        case group_name
        case group
        case email
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.groupName = try container.decode(String?.self, forKey: .group_name)
        self.group = try container.decode(Int?.self, forKey: .group)
        self.email = try container.decode(String?.self, forKey: .email)
    }
}

struct Auth: Decodable {
    
    let aditionalId: String?
    let studentId: Int?
    let label: String?
    let description: String?
    let type: String?
    let additional: AdditionalAuthInfo?
    
    enum CodingKeys: String, CodingKey {
        case _id
        case id
        case label
        case description
        case type
        case additional
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.aditionalId = try container.decode(String?.self, forKey: ._id)
        self.studentId = try container.decode(Int?.self, forKey: .id)
        self.label = try container.decode(String?.self, forKey: .label)
        self.description = try container.decode(String?.self, forKey: .description)
        self.type = try container.decode(String?.self, forKey: .type)
        self.additional = try container.decode(AdditionalAuthInfo?.self, forKey: .additional)
    }
}
