//
//  JsonUtils.swift
//  HseTimetable
//
//  Created by Pavel on 19.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import Foundation

func parseJson<T: Decodable>(data: Data) -> (T?, Error?) {
    var model: T?
    var error: Error?
    do {
        let decoder = JSONDecoder()
        model = try decoder.decode(T.self, from: data)
    } catch DecodingError.dataCorrupted(let context) {
        error = DecodingError.dataCorrupted(context)
    } catch DecodingError.keyNotFound(let key, let context) {
        error = DecodingError.keyNotFound(key,context)
    } catch DecodingError.typeMismatch(let type, let context) {
        error = DecodingError.typeMismatch(type,context)
    } catch DecodingError.valueNotFound(let value, let context) {
        error = DecodingError.valueNotFound(value,context)
    } catch let jsonError{
        error = jsonError
    }
    return (model, error)
}
