//
//  RequestHeaders.swift
//  simpleHttp
//
//  Created by Senthilvel Palanisamy on 22/12/19.
//

import Foundation

public struct RequestHeaders {
    var  _headers: Dictionary<String,Any> = [:]
    var  headers: Dictionary<String,Any> {
        get {
            return _headers
        }
        set(headerParams) {
          _headers = headerParams
        }
    }
}
