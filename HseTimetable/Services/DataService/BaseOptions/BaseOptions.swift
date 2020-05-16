//
//  BaseOptions.swift
//  HseTimetable
//
//  Created by Pavel on 21.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import RealmSwift
import Foundation

struct BaseOptions<Model: Object> {
    
}

// MARK:- Base Get Protocol methods
extension BaseOptions: BaseGetProtocol {
    
    typealias TG = Model
    
    func get(filter: String?, sortedByKeyPath: String?, ascending: Bool?) -> ([Model]?, Error?) {
        do {
            let realm = try Realm()
            var results = realm.objects(Model.self)
            if let key = sortedByKeyPath, let ascending = ascending { results = results.sorted(byKeyPath: key, ascending: ascending)}
            if let filter = filter { results = results.filter(filter) }
            return (results.map{ $0 }, nil)
        } catch let error {
            return (nil, error)
        }
    }
}

// MARK:- Base Delete Protocol methods
extension BaseOptions: BaseDeleteProtocol {
    
    typealias TD = Model
    
    func delete(filter: String?) -> Error? {
        var error: Error? = nil
        
        let closure: (String?) -> Error? = { filter in
            do {
                let realm = try Realm()
                var results = realm.objects(Model.self)
                if let filter = filter { results = results.filter(filter) }
                realm.beginWrite()
                realm.delete(results)
                try realm.commitWrite()
                return nil
            } catch let error {
                return error
            }
        }
        
        if Thread.isMainThread { error = closure(filter) }
        else { DispatchQueue.main.sync { error = closure(filter) }}
        
        return error
    }
}

// MARK:- Base Put Protocol methods
extension BaseOptions: BasePutProtocol {
    
    typealias TP = Model
    
    func put(object: Model) -> Error? {
        var error: Error? = nil
        
        let closure: (Model) -> Error? = { object in
            do {
                let realm = try Realm()
                realm.beginWrite()
                realm.add(object, update: .all)
                realm.add(object)
                try realm.commitWrite()
                return nil
            } catch let error {
                return error
            }
        }

        if Thread.isMainThread { error = closure(object) }
        else { DispatchQueue.main.sync { error = closure(object) }}
        
        return error
    }
    
    func put(objects: [Model]) -> Error? {
        var error: Error? = nil
        
        let closure: ([Model]) -> Error? = { objects in
            do {
                let realm = try Realm()
                realm.beginWrite()
                realm.add(objects, update: .all)
                try realm.commitWrite()
                return nil
            } catch let error {
                return error
            }
        }
        
        if Thread.isMainThread { error = closure(objects) }
        else { DispatchQueue.main.sync { error = closure(objects) }}
        
        return error
    }
}
