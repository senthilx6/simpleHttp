//
//  RequestCreator.swift
//  simpleHttp
//
//  Created by Senthilvel Palanisamy on 22/12/19.
//

import Foundation


public class RequestCreator {
    
    var request:URLRequest;
    
    init(url:URL) {
        request = URLRequest(url: url)
    }
    
    
    func addRequestHeaders(requestHeader:RequestHeaders) {
        for (key,value) in requestHeader.headers {
            self.request.addValue(value as! String, forHTTPHeaderField: key)
        }
    }
    
    func setRequestMethod(method:String) {
        self.request.httpMethod = method
    }
    
    func setRequestBody(values:Data) {
        self.request.httpBody = values
    }
    
    func getRequest()->URLRequest {
        self.request
    }
   
}
