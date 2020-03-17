//
//  UrlConstructor.swift
//  simpleHttp
//
//  Created by Senthilvel Palanisamy on 28/12/19.
//

import Foundation

class UrlConstructor {
    
    var urlComponent : URLComponents
    
    init(domain:String){
        urlComponent = URLComponents(string: domain)!
    }
    
    func addPath(path:String) {
        urlComponent.path = "/\(path)"
    }
    
    func addQuery(query:String) {
        urlComponent.query = query
    }
    
    func addQueryItems(query:Dictionary<String,String>) {
        var quertItems: [URLQueryItem] = []
        query.forEach({ items in
            quertItems.append(URLQueryItem(name: items.key, value: items.value))
        })
        urlComponent.queryItems = quertItems
    }
    
    func getConstructedURL()->URL {
        return urlComponent.url!
    }
    
}
