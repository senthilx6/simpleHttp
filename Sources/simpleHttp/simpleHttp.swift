import Foundation


class SimpleHttpClinet {
    
    var url:String;
    var creds:Dictionary<String,String>;
    var token:String = ""
    init(url:String,creds:Dictionary<String,String>,token:String="") {
      self.url =  url
      self.creds = creds
        if(token.isEmpty) {
      setToken()
        } else {
            self.token =  token
        }
    }
    
   
    
    // have to write a common method to support PUT
    func post(url:String,postdata:Data?)->[String: Any] {
        var serverResponse:[String: Any] = [:]
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        if let data = postdata{
        request.httpBody = data
        }
        let authString = self.token.isEmpty ? useBaseAuth() : self.token
        request.addValue(authString, forHTTPHeaderField: "Authorization")
        return getResponse(request:request)
    }
    
    func get(url:String)->[String: Any] {
        var serverResponse:[String: Any] = [:]
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let authString = self.token.isEmpty ? useBaseAuth() : self.token
        request.addValue(authString, forHTTPHeaderField: "Authorization")
        return getResponse(request:request)
    }
        
    // have to write a common method to support PUT
    func put(url:String,postdata:Data?)->[String: Any] {
        var serverResponse:[String: Any] = [:]
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        if let data = postdata{
            request.httpBody = data
        }
        let authString = self.token.isEmpty ? useBaseAuth() : self.token
        request.addValue(authString, forHTTPHeaderField: "Authorization")
        return getResponse(request:request)
    }
    
    
    func delete(url:String)->[String: Any] {
        var serverResponse:[String: Any] = [:]
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let authString = self.token.isEmpty ? useBaseAuth() : self.token
        request.addValue(authString, forHTTPHeaderField: "Authorization")
        return getResponse(request:request)
    }
    
    private func useBaseAuth()->String {
        let userPasswordString:String = "\(self.creds["emailid"] as! String):\(self.creds["password"] as! String)"
        let userPasswordData = userPasswordString.data(using: String.Encoding.utf8)
        let base64EncodedCredential = userPasswordData?.base64EncodedString()
        let authString = "Basic " + base64EncodedCredential!
        return authString
    }
    
    
     func setToken() {
        var serverResponse:[String: Any] = [:]
        serverResponse = post(url:"https://\(url)/api/sign_in", postdata: nil)
        let tokenKey  = serverResponse["auth_token"] as! String
        self.token = "Token token=\(tokenKey)"
    }
    
    func getToken()->String {
        return self.token
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
