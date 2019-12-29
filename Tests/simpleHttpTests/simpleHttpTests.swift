import XCTest
@testable import simpleHttp

final class simpleHttpTests: XCTestCase {
    
    
    func testPostMethod() {
        let header  = ["Content-Type":"application/json","Accept":"application/json"]
        let client =   SimpleHttpClinet(hostname:"https://postman-echo.com",headers: header)
        let values: Dictionary<String,String> = ["foo1":"bar1","foo2":"bar2"]
        let postdata =  try? JSONSerialization.data(withJSONObject: values, options: [])
        let result:[String: Any] =  client.post(path: "post", postdata: postdata)
        XCTAssert(result["status code"] as! Int == 200)
    }
    
    
    func testGetMethod() {
        let header  = ["Content-Type":"application/json","Accept":"application/json"]
        let client =   SimpleHttpClinet(hostname:"https://postman-echo.com",headers: header)
        let result:[String: Any] =  client.get(path: "get",query: "foo1=bar1&foo2=bar2")
        XCTAssert(result["status code"] as! Int == 200)
    }
    
    
    func testPutMethod() {
        let header  = ["Content-Type":"application/json","Accept":"application/json"]
        let client =   SimpleHttpClinet(hostname:"https://postman-echo.com",headers: header)
        let result:[String: Any] =  client.put(path: "put", postdata: nil)
        XCTAssert(result["status code"] as! Int == 200)
    }
    
    func testDeleteMethod() {
        let header  = ["Content-Type":"application/json","Accept":"application/json"]
        let client =   SimpleHttpClinet(hostname:"https://postman-echo.com",headers: header)
        let result:[String: Any] =  client.delete(path: "delete")
        XCTAssert(result["status code"] as! Int == 200)
    }

}
