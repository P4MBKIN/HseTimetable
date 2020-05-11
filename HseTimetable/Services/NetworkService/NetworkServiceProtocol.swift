//
//  NetworkServiceProtocol.swift
//  HseTimetable
//
//  Created by Pavel on 19.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import Foundation

protocol NetworkLessonsServiceProtocol: class {
    func lessonsGet<Model: Decodable, ErrorModel: Decodable>(studentId: Int,
                                                             daysOffset: Int,
                                                             dateFrom: Date,
                                                             completion: @escaping ((Model?, ErrorModel?, Error?) -> Void))
}

protocol NetworkAuthServiceProtocol: class {
    func studentGet<Model: Decodable, ErrorModel: Decodable>(email: String,
                                                             completion: @escaping ((Model?, ErrorModel?, Error?) -> Void))
}
