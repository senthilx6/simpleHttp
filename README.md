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
pod 'simpleHttp', '0.0.5'
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
 let adminCreds: Dictionary<String,String> =
    ["emailid":"apiauthlesspassword@xyz.com","password":"apiauthpassword"]
  let htppClinet = SimpleHttpClinet(url:"testbaseurl.com",creds:adminCreds)
 ```
 
 from the htppClinet object can use **post** , **put** , **get** , **delete**, currently supports  BASIC AUTH , will be releasing other types of auth and provision 
 to include header and other http clinet methofs like OPTIONS,PATCH soon
 
