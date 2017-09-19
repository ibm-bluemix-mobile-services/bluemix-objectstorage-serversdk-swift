- - -

**_This project has been deprecated and is no longer actively maintained. Proceed at your own risk!_**

- - - 

# BluemixObjectStorage

Bluemix server SDK for Object Storage in Swift

[![Swift][swift-badge]][swift-url]
[![Platform][platform-badge]][platform-url]
[![Build Status](https://travis-ci.org/ibm-bluemix-mobile-services/bluemix-objectstorage-serversdk-swift.svg?branch=master)](https://travis-ci.org/ibm-bluemix-mobile-services/bluemix-objectstorage-serversdk-swift)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/8f7f31755ad74990a201ca558b94f37f)](https://www.codacy.com/app/ibm-bluemix-mobile-services/bluemix-objectstorage-serversdk-swift?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=ibm-bluemix-mobile-services/bluemix-objectstorage-serversdk-swift&amp;utm_campaign=Badge_Grade)
[![Coverage Status](https://coveralls.io/repos/github/ibm-bluemix-mobile-services/bluemix-objectstorage-serversdk-swift/badge.svg?branch=development)](https://coveralls.io/github/ibm-bluemix-mobile-services/bluemix-objectstorage-serversdk-swift?branch=development)

## Installation

```swift
import PackageDescription

let package = Package(
    dependencies: [
        .Package(url: "https://github.com/ibm-bluemix-mobile-services/bluemix-objectstorage-serversdk-swift.git", majorVersion: 0, minor: 7)
	]
)
```

* 0.7.x releases were tested on OSX and Linux with Swift 3.0.2

## Usage

Import the BluemixObjectStorage framework

```swift
import BluemixObjectStorage
```

### Objectstorage

Use `ObjectStorage` instance to connect to IBM Object Storage service and manage containers.

#### Connect to the IBM Object Storage service using userId and password

```swift
let objstorage = ObjectStorage(projectId:"your-project-id")
objstorage.connect(	userId: "your-service-userId",
 					password: "your-service-password",
					region: ObjectStorage.REGION_DALLAS) { (error) in
	if let error = error {
		print("connect error :: \(error)")
	} else {
		print("connect success")
	}							
}
```

#### Create a new container

```swift
objstorage.createContainer(name: "container-name") { (error, container) in
	if let error = error {
		print("createContainer error :: \(error)")
	} else {
		print("createContainer success :: \(container?.name)")
	}
}
```

#### Retrieve an existing container

```swift
objstorage.retrieveContainer(name: "container-name") { (error, container) in
	if let error = error {
		print("retrieveContainer error :: \(error)")
	} else {
		print("retrieveContainer success :: \(container?.name)")
	}
}
```

#### Retrieve a list of existing containers

```swift
objstorage.retrieveContainersList { (error, containers) in
	if let error = error {
		print("retrieveContainersList error :: \(error)")
	} else {
		print("retrieveContainersList success :: \(containers?.description)")
	}
}
```

#### Delete an existing container

```swift
objstorage.deleteContainer(name: "container-name") { (error) in
	if let error = error {
		print("deleteContainer error :: \(error)")
	} else {
		print("deleteContainer success")
	}
}
```

#### Update account metadata

```swift
let metadata:Dictionary<String, String> = ["X-Account-Meta-SomeName":"SomeValue"]
objstorage.updateMetadata(metadata: metadata) { (error) in
	if let error = error {
		print("updateMetadata error :: \(error)")
	} else {
		print("updateMetadata success")
	}
}
```

#### Retrieve account metadata

```swift
objstorage.retrieveMetadata { (error, metadata) in
	if let error = error {
		print("retrieveMetadata error :: \(error)")
	} else {
		print("retrieveMetadata success :: \(metadata)")
	}
}
```

### ObjectStorageContainer

Use `ObjectStorageContainer` instance to manage objects inside of particular container

#### Create a new object or update an existing one

```swift
#if os(Linux)
	let data = "testdata".dataUsingEncoding(NSUTF8StringEncoding)!
#else
	let data = "testdata".data(using: NSUTF8StringEncoding)!
#endif
let data = str.dataUsingEncoding(NSUTF8StringEncoding)
container.storeObject(name: "object-name", data: data) { (error, object) in
	if let error = error {
		print("storeObject error :: \(error)")
	} else {
		print("storeObject success :: \(object?.name)")
	}
}
```

#### Retrieve an existing object

```swift
container.retrieveObject(name: "object-name") { (error, object) in
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

#### Update container metadata

```swift
let metadata:Dictionary<String, String> = ["X-Container-Meta-SomeName":"SomeValue"]
container.updateMetadata(metadata: metadata) { (error) in
	if let error = error {
		print("updateMetadata error :: \(error)")
	} else {
		print("updateMetadata success")
	}
}
```

#### Retrieve container metadata

```swift
container.retrieveMetadata { (error, metadata) in
	if let error = error {
		print("retrieveMetadata error :: \(error)")
	} else {
		print("retrieveMetadata success :: \(metadata)")
	}
}
```

### ObjectStorageObject

Use `ObjectStorageObject` instance to load object content on demand

#### Load the object content

```swift
object.load(shouldCache: false) { (error, data) in
	if let error = error {
		print("load error :: \(error)")
	} else {
		print("load success :: \(data)")
	}
}
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

#### Update object metadata

```swift
let metadata:Dictionary<String, String> = ["X-Object-Meta-SomeName":"SomeValue"]
object.updateMetadata(metadata: metadata) { (error) in
	if let error = error {
		print("updateMetadata error :: \(error)")
	} else {
		print("updateMetadata success")
	}
}
```

#### Retrieve object metadata

```swift
object.retrieveMetadata { (error, metadata) in
	if let error = error {
		print("retrieveMetadata error :: \(error)")
	} else {
		print("retrieveMetadata success :: \(metadata)")
	}
}
```

### ObjectStorageError

The `ObjectStorageError` is an enum with possible failure reasons

```swift
enum ObjectStorageError: ErrorType {
	case ConnectionFailure
	case NotFound
	case Unauthorized
	case ServerError
	case InvalidUri
	case FailedToRetrieveAuthToken
	case NotConnected
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


[swift-badge]: https://img.shields.io/badge/Swift-3.0-orange.svg
[swift-url]: https://swift.org
[platform-badge]: https://img.shields.io/badge/Platforms-OS%20X%20--%20Linux-lightgray.svg
[platform-url]: https://swift.org
