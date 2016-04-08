# BluemixObjectStore


## Content

This repository contains the Swift SDK for [IBM Object Store service on Bluemix](https://console.ng.bluemix.net/docs/services/ObjectStorage/index.html). The SDK is currently in early development stages and available for iOS, OSX and Linux platforms.

## Installation

#### Cocoapods
To install BluemixObjectStore using Cocoapods dependency manager add `pod 'BluemixObjectStore'` to your Podfile:

```ruby
use_frameworks!

target 'your-target' do
	pod 'BluemixObjectStore'
end
```

#### Swift package manager
To install BluemixObjectStore using Swift Package Manager add following dependency in your 'Package.swift' file 

```Swift
import PackageDescription

let package = Package(
    name: "HelloSwift",
	dependencies: [
        .Package(url: "https://github.com/ibm-bluemix-mobile-services/bms-clientsdk-swift-objectstore.git", majorVersion: 0)
	]
)
```



## API reference

API docs are automatically generated from source code and available using this link - [http://cocoadocs.org/docsets/BluemixObjectStore](http://cocoadocs.org/docsets/BluemixObjectStore)

## Usage

Import the BluemixObjectStore framework to the classes you want to use it in

```ruby
import BluemixObjectStore
```

The BluemixObjectStore SDK designed to be as stateless and lightweight as possible. Important thing to note is that object content is not loaded automatically when ObjectStoreObject instance is retrieved from ObjectStoreContainer. Loading object content should be done explicitly by calling .load() method of an ObjectStoreObject instance as described below. 

### ObjectStore 

Use `ObjectStore` instance to connect to IBM Object Store service and manage containers.

#### Connect to the IBM Object Store service using userId and password

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

#### Connect to the IBM Object Store service using authToken

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

#### Create a new object or update an existing one

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

#### Delete the container

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

#### Load the object content

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

#### Get cached object content

```
object.load(shouldCache: true) { (error, data) in ...... }

let imageView = UIImageView(image: UIImage(data: object.cachedData!))
self.view.addSubview(imageView)
```

#### Delete the object

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
