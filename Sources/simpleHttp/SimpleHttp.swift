import Foundation


open class SimpleHttpClinet {
    

    var urlHelper:UrlConstructor
    var headerobj:RequestHeaders
    public init (hostname:String,headers:Dictionary<String,Any>){
        urlHelper = UrlConstructor(domain: hostname)
        headerobj =  RequestHeaders()
        headerobj.headers = headers
    }
    
    
    
    open func post(path:String,postdata:Data?)->[String: Any] {
        urlHelper.addPath(path: path)
        let requestCreator = RequestCreator(url:urlHelper.getConstructedURL())
        requestCreator.setRequestMethod(method: "POST")
        requestCreator.addRequestHeaders(requestHeader:headerobj)
        if postdata != nil{
            requestCreator.setRequestBody(values: postdata!)
            }
        return getResponse(request:requestCreator.getRequest())
    }

    open func get(path:String,query:Dictionary<String,String>)->[String: Any] {
        urlHelper.addPath(path: path)
        urlHelper.addQueryItems(query: query)
        let requestCreator = RequestCreator(url:urlHelper.getConstructedURL())
        requestCreator.setRequestMethod(method: "GET")
        requestCreator.addRequestHeaders(requestHeader:headerobj)
        return getResponse(request:requestCreator.getRequest())
    }
    
    open func get(path:String,query:String)->[String: Any] {
        urlHelper.addPath(path: path)
        urlHelper.addQuery(query: query)
        let requestCreator = RequestCreator(url:urlHelper.getConstructedURL())
        requestCreator.setRequestMethod(method: "GET")
        requestCreator.addRequestHeaders(requestHeader:headerobj)
        return getResponse(request:requestCreator.getRequest())
    }
    
    open func get(path:String)->[String: Any] {
        urlHelper.addPath(path: path)
        let requestCreator = RequestCreator(url:urlHelper.getConstructedURL())
        requestCreator.setRequestMethod(method: "GET")
        requestCreator.addRequestHeaders(requestHeader:headerobj)
        return getResponse(request:requestCreator.getRequest())
    }

    open func put(path:String,postdata:Data?)->[String: Any] {
        urlHelper.addPath(path: path)
        let requestCreator = RequestCreator(url:urlHelper.getConstructedURL())
        requestCreator.setRequestMethod(method: "PUT")
        requestCreator.addRequestHeaders(requestHeader:headerobj)
        if postdata != nil{
            requestCreator.setRequestBody(values: postdata!)
            }
        return getResponse(request:requestCreator.getRequest())
    }


    open func delete(path:String)->[String: Any] {
        urlHelper.addPath(path: path)
        let requestCreator = RequestCreator(url:urlHelper.getConstructedURL())
        requestCreator.setRequestMethod(method: "DELETE")
        requestCreator.addRequestHeaders(requestHeader:headerobj)
       return getResponse(request:requestCreator.getRequest())
    }
    
    open func head(path:String)->[String: Any] {
        urlHelper.addPath(path: path)
        let requestCreator = RequestCreator(url:urlHelper.getConstructedURL())
        requestCreator.setRequestMethod(method: "HEAD")
        requestCreator.addRequestHeaders(requestHeader:headerobj)
       return getResponse(request:requestCreator.getRequest())
    }
    
    
    private func getResponseHeaders(request:URLRequest)->[AnyHashable : Any]  {
       let session = URLSession.shared
        var temp = 0;
        var serverResponse: [AnyHashable : Any] = [:]
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                return
            }
            do {
                //create json object from data
                let httpResponse:HTTPURLResponse = response as! HTTPURLResponse
                serverResponse =  httpResponse.allHeaderFields
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        while(serverResponse.isEmpty) {
            sleep(5)
            if(temp>10){
                break
            }
           temp+=1
        }
        return serverResponse
    }

    open func resetCookie(){
      HTTPCookieStorage.shared.cookies?.forEach(HTTPCookieStorage.shared.deleteCookie)
    }


    private func getResponse(request:URLRequest)->[String: Any]  {
        let session = URLSession.shared
        var temp = 0;
        var serverResponse: Dictionary<String,Any> = [:]
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    serverResponse = json
                    let httpResponse:HTTPURLResponse = response as! HTTPURLResponse
                    serverResponse["status code"] = httpResponse.statusCode
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        while(serverResponse.isEmpty) {
            sleep(5)
            if(temp>10){
                break
            }
           temp+=1
        }
        return serverResponse
    }
    
    
}
