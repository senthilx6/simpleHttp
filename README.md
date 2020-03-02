# Simple Http clinet

As name suggest a http clinet which can be used for xcuitest for perforing any api related operation
rather than doing the same process repatedly in UI which leads to time consuming process


### Prerequisites

```
Swift 4.2
cocopods
```

### Installing

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```
$ gem install cocoapods
```

To integrate simpleHttp into your Xcode project using CocoaPods, specify it in your `Podfile`:


```
pod 'simpleHttp', '0.0.6'
```

Then, run the following command:

```
$ pod install
```

After installing , build the project

```
import simpleHttp
```
 use the above command to import the module where you goning to use SimpleHttpClinet
 
 ```
        let header  = ["Content-Type":"application/json","Accept":"application/json"]
        let client =   SimpleHttpClinet(hostname:"https://postman-echo.com",headers: header)
        let result:[String: Any] =  client.put(path: "put", postdata: nil)
 ```
 
 from the htppClinet object you can use **post** , **put** , **get** , **delete**, **head**
other methods  like OPTIONS,PATCH coming soon
 
