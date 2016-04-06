# BMSObjectStore


## Content

This repository contains the Swift SDK for IBM Object Store service on Bluemix. 


## Installation

BMSObjectStore is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "BMSObjectStore"
```

## API reference

```swift
class ObjectStore {
    static REGION_DALLAS
    static REGION_LONDON
    init(projectId:String)
    func connect(userId userId:String, password:String, region:String, completionHandler: (error:ObjectStoreError?) -> Void){}
	func connect(authToken:String, region:String, completionHandler: (error:ObjectStoreError?) -> Void){}
	func createContainer(name:String, completionHandler:(error: ObjectStoreError?, container: ObjectStoreContainer?) -> Void){}
	func retrieveContainer(name:String, completionHandler:(error: ObjectStoreError?, container: ObjectStoreContainer?)->Void){}
	func retrieveContainersList(completionHandler:(error: ObjectStoreError?, containers: [ObjectStoreContainer]?) -> Void){}
    func deleteContainer(name:String, completionHandler:(error: ObjectStoreError?) -> Void)
}
```

```swift
class ObjectStoreContainer{
    name
    url
    init(name:String, url:String, objectStore:ObjectStore)
   	func storeObject(name:String, data:NSData, completionHandler:(error: ObjectStoreError?, object: ObjectStoreObject?)->Void){}
   	func retrieveObject(name:String, completionHandler:(error: ObjectStoreError?, object: ObjectStoreObject?)->Void) {}
    func retrieveObjectsList(completionHandler:(error: ObjectStoreError?, objects: [ObjectStoreObject]?) -> Void){}
    func deleteObject(name:String, completionHandler:(error: ObjectStoreError?) -> Void){}
    func delete(completionHandler:(error:ObjectStoreError?)->Void){}
}
```

```swift
class ObjectStoreObject{
    let name
    let url
    var cachedData:NSData
    func load(shouldCache:Bool, completionHandler:(error: ObjectStoreError?, data:NSData?)->Void){}
    func delete(completionHandler:(error:ObjectStoreError?)->Void){}
}
```

```swift
enum ObjectStoreError: ErrorType {
	case ConnectionFailure(message:String)
	case AuthenticationError
	case ServerError
	case NotFound
}
```

## Usage

Import the BMSObjectStore framework to the classes you want to use it in

```ruby
import BMSObjectStore
```

The BMSObjectStore SDK was designed to be as stateless and lightweight as possible. Important thing to note is that object content is not loaded automatically when ObjectStoreObject instance is retrieved from ObjectStoreContainer. Loading object content should be done explicitly by calling .load() method of ObjectStoreObject as described below. 

### ObjectStore 

Use `ObjectStore` instance to connect to IBM Object Store service and manage containers.

#### Connect to the IBM Object Store using userId and password

```swift
let objStore = ObjectStore(projectId:"your-project-id")
objStore.connect(	userId: "your-service-userId",
 					password: "your-service-password",
					region: ObjectStore.REGION_DALLAS) { (error) in
	if let error = error {
		print("connect error :: \(error)")
	} else {
		print("connect success")
	}							
}
```

#### Connect to the IBM Object Store using authToken

```swift
let objStore = ObjectStore(projectId:"your-project-id")
objStore.connect(	authToken: "your-auth-token", 
					region: ObjectStore.REGION_DALLAS) { (error) in
	if let error = error {
		print("connect error :: \(error)")
	} else {
		print("connect success");
	}
}
```

#### Create a new container

```swift
objStore.createContainer(name: "container-name") { (error, container) in
	if let error = error {
		print("createContainer error :: \(error)")
	} else {
		print("createContainer success :: \(container?.name)")
	}
}
```

#### Retrieve an existing container

```swift
objStore.retrieveContainer(name: "container-name") { (error, container) in
	if let error = error {
		print("retrieveContainer error :: \(error)")
	} else {
		print("retrieveContainer success :: \(container?.name)")
	}
}
```

#### Retrieve a list of existing containers

```swift
objStore.retrieveContainersList { (error, containers) in
	if let error = error {
		print("retrieveContainersList error :: \(error)")
	} else {
		print("retrieveContainersList success :: \(containers?.description)")
	}
}
```

#### Delete an existing container

```swift
objStore.deleteContainer(name: "container-name") { (error) in
	if let error = error {
		print("deleteContainer error :: \(error)")
	} else {
		print("deleteContainer success")
	}
}
```

### ObjectStoreContainer

Use `ObjectStoreContainer` instance to manage objects inside of particular container

#### Create a new object

```swift
let str = "Hello World!"
let data = str.dataUsingEncoding(NSUTF8StringEncoding)
container.storeObject(name: "object-name", data: data!) { (error, object) in
	if let error = error {
		print("storeObject error :: \(error)")
	} else {
		print("storeObject success :: \(object?.name)")
	}
}
```
#### Retrieve an existing object

```swift
container.retrieveObject(name: "object-name"") { (error, object) in
	if let error = error {
		print("retrieveObject error :: \(error)")
	} else {
		print("retrieveObject success :: \(object?.name)")
	}
}
```
#### Retrieve a list of existing objects

```swift
container.retrieveObjectsList { (error, objects) in
	if let error = error {
		print("retrieveObjectsList error :: \(error)")
	} else {
		print("retrieveObjectsList success :: \(objects?.description)")
	}
}
```

#### Delete an existing object

```swift
container.deleteObject(name: "object-name") { (error) in
	if let error = error {
		print("deleteObject error :: \(error)")
	} else {
		print("deleteObject success")
	}
}
```

#### Delete container

```swift
container.delete { (error) in
	if let error = error {
		print("deleteContainer error :: \(error)")
	} else {
		print("deleteContainer success")
	}
}
```

### ObjectStoreObject

Use `ObjectStoreObjects` instance to load object content. 

#### Loading objects content

```swift
object.load(shouldCache: false) { (error, data) in
	if let error = error {
		print("load error :: \(error)")
	} else {
		dispatch_async(dispatch_get_main_queue(), {
			let imageView = UIImageView(image: UIImage(data: data!))
			self.view.addSubview(imageView)
		});
	}
}
```

#### Getting cached objects content

```
object.load(shouldCache: true) { (error, data) in ...... }

let imageView = UIImageView(image: UIImage(data: object.cachedData!))
self.view.addSubview(imageView)
```

#### Delete object

```swift
object.delete { (error) in
	if let error = error {
		print("deleteObject error :: \(error)")
	} else {
		print("deleteObject success")
	}
}
```

### ObjectStoreError

The `ObjectStoreError` is an enum with possible failure reasons

```swift
enum ObjectStoreError: ErrorType {
	case ConnectionFailure(message:String)
	case AuthenticationError
	case ServerError
	case NotFound
}
```


## License

Copyright 2016 IBM Corp.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
