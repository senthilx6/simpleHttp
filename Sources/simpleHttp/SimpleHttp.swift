import Foundation


open class SimpleHttpClient {
    
    
    var urlHelper:UrlConstructor
    var headerobj:RequestHeaders
    var boundary:String
    public init (hostname:String,headers:Dictionary<String,Any>) {
        urlHelper = UrlConstructor(domain: hostname)
        headerobj =  RequestHeaders()
        headerobj.headers = headers
        self.boundary = ""
    }
    
    public init (hostname:String,headers:Dictionary<String,Any>,boundary:String){
        urlHelper = UrlConstructor(domain: hostname)
        headerobj =  RequestHeaders()
        headerobj.headers = headers
        self.boundary = boundary
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
             let httpResponse:HTTPURLResponse = response as! HTTPURLResponse
            guard error == nil else {
                return
            }
            guard let data = data else {
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    serverResponse = json
                    serverResponse["status code"] = httpResponse.statusCode
                }
            } catch let error {
                let decodeString = String(decoding: data, as: UTF8.self)
                serverResponse["respose"] = decodeString
                serverResponse["status code"] = httpResponse.statusCode
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
    
    open func postFile(path:String,formdata:Dictionary<String,String>,filedata:Dictionary<String,String>)->[String:Any] {
        urlHelper.addPath(path: path)
        let requestCreator = RequestCreator(url:urlHelper.getConstructedURL())
        requestCreator.setRequestMethod(method: "POST")
        requestCreator.addRequestHeaders(requestHeader:headerobj)
        let imageData = NSData(contentsOfFile: filedata["path"]!)
        let body = createBody(parameters: formdata,data: imageData as! Data ,mimeType: filedata["type"]!,filename: filedata["file_name"]!)
        requestCreator.setRequestBody(values: body)
        return getResponse(request:requestCreator.getRequest())
    }
    
    func createBody(parameters: [String: String],data: Data,mimeType: String,filename:String) -> Data {
        let body = NSMutableData()
        var go:String = ""
        let boundaryPrefix = "--\(self.boundary)\r\n"
        for (key, value) in parameters {
            body.appendString(boundaryPrefix)
            go.append(boundaryPrefix)
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            go.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
            go.append("\(value)\r\n")
        }
        go.append(boundaryPrefix)
        body.appendString(boundaryPrefix)
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        go.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimeType)\r\n\r\n")
        go.append("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.appendString("\r\n")
        go.append("\r\n")
        body.appendString("--".appending(self.boundary.appending("--")))
        go.append("--".appending(self.boundary.appending("--")))
        NSLog(go)
        return body as Data
    }
    
}

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}
