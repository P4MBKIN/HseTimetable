//
//  BaseSession.swift
//  HseTimetable
//
//  Created by Pavel on 19.04.2020.
//  Copyright © 2020 Hse. All rights reserved.
//

import Foundation

enum BaseSession {
    
    case main
    
    func returnType() -> URLSession {
        switch self {
        case .main:
            // qos для сессии
            let delegateQueue = OperationQueue()
            delegateQueue.qualityOfService = .utility
            let session = URLSession.init(configuration: .default, delegate: nil, delegateQueue: delegateQueue)
            // Устанавливать соединение по сотовой сети
            session.configuration.allowsCellularAccess = true
            // Интервал ожидания дополнительных данных
            session.configuration.timeoutIntervalForRequest = 3
            // Максимальное количество времени, которое может потребоваться для запроса ресурса
            session.configuration.timeoutIntervalForResource = 3
            // Должен ли сеанс ждать, пока подключение станет доступным, или немедленно завершится неудачей
            if #available(iOS 11.0, *) {
                session.configuration.waitsForConnectivity = false
            }
            // Должны ли TCP-соединения оставаться открытыми, когда приложение переходит в фоновый режим
            if #available(iOS 9.0, *) {
                session.configuration.shouldUseExtendedBackgroundIdleMode = true
            }
            // Тип сервиса, который определяет полиику соединения TCP для передачи данных яерез WiFi и сотовые интерфейсы
            // ключ handover - многопутевая служба TCP, обеспечивающая бесшовную передачу обслуживания между WiFi и сотовой связью, сохраняя соединение
            if #available(iOS 11.0, *) {
                session.configuration.multipathServiceType = .handover
            }
            // Должны ли задачи в сеансах использовать конвеерную передачу HTTP
            // session.configuration.httpShouldUsePipelining = true
            // Может ли система использовать соединение которое считает "дорогим"
            if #available(iOS 13.0, *) {
                session.configuration.allowsExpensiveNetworkAccess = true
            }
            // Могут ли приложения использовать сеть, когда пользователь указал режим малого потребления трафика
            if #available(iOS 13.0, *) {
                session.configuration.allowsExpensiveNetworkAccess = true
            }
            return session
        }
    }
}
