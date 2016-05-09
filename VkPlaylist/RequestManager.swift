//
//  RequestManager.swift
//  VkPlaylist
//
//  Created by Илья Халяпин on 02.05.16.
//  Copyright © 2016 Ilya Khalyapin. All rights reserved.
//

import UIKit
import SwiftyVK

/// Отвечает за обработку запросов на загрузку данных с сервера VK

class RequestManager {
    
    private struct Static {
        static var onceToken: dispatch_once_t = 0 // Ключ идентифицирующий жизненынный цикл приложения
        static var instance: RequestManager? = nil
    }
    
    class var sharedInstance : RequestManager {
        dispatch_once(&Static.onceToken) { // Для указанного токена выполняет блок кода только один раз за время жизни приложения
            Static.instance = RequestManager()
        }
        
        return Static.instance!
    }
    
    
    private init() {
        activeRequests = [:]
        
        getAudio = GetAudio(defaultState: .NotSearchedYet, defaultError: .None, key: requestKeys.GetAudio)
        searchAudio = SearchAudio(defaultState: .NotSearchedYet, defaultError: .None, key: requestKeys.SearchAudio)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    // MARK: Работа с активными запросами
    
    var activeRequests: [String : Request]
    
    // Отмена запросов при деавторизации
    func cancelRequestInCaseOfDeavtorization() {
        getAudio.cancel()
        searchAudio.cancel()
    }
    
    
    // Получение личных аудиозаписей
    let getAudio: RequestManagerObject
    
    // Получение искомых аудиозаписей
    let searchAudio: RequestManagerObject
    
}


// MARK: Типы данных

private typealias RequestManagerDataTypes = RequestManager
extension RequestManagerDataTypes {
    
    // Ключи для запросов
    struct requestKeys {
        static let GetAudio = "getAudio" // Ключ на получение личных аудиозаписей
        static let SearchAudio = "searchAudio" // Ключ на получение искомых аудиозаписей
    }
    
}