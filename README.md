# BluemixObjectStore

[![Swift][swift-badge]][swift-url]
[![Platform][platform-badge]][platform-url]

## Installation
```swift
import PackageDescription

let package = Package(
    dependencies: [
        .Package(url: "https://github.com/ibm-bluemix-mobile-services/bluemix-objectstore-swift-sdk.git", majorVersion: 0, minor: 1)
    ]
)
```

0.1.x releases of BluemixObjectStore are tested on OSX and Linux with DEVELOPMENT-SNAPSHOT-2016-04-25-a


### Build on Linux

```bash
sudo apt-get update
swift build -Xcc -fblocks -Xlinker -ldispatch
```

### Build on Mac:

```bash
swift build
```

## Using on Bluemix

TBD

## Usage

Import the BluemixObjectStore framework to the classes you want to use it in

```swift
import BluemixObjectStore
```

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

#### Update account metadata

```swift
let metadata:Dictionary<String, String> = ["X-Account-Meta-SomeName":"SomeValue"]
objStore.updateMetadata(metadata: metadata) { (error) in
	if let error = error {
		print("updateMetadata error :: \(error)")
	} else {
		print("updateMetadata success")
	}
}
```

#### Retrieve account metadata

```swift
objStore.retrieveMetadata { (error, metadata) in
	if let error = error {
		print("retrieveMetadata error :: \(error)")
	} else {
		print("retrieveMetadata success :: \(metadata)")
	}
}
```

### ObjectStoreContainer

Use `ObjectStoreContainer` instance to manage objects inside of particular container

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

### ObjectStoreObject

Use `ObjectStoreObjects` instance to load object content.

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

### ObjectStoreError

The `ObjectStoreError` is an enum with possible failure reasons

```swift
enum ObjectStoreError: ErrorType {
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

This project is released under the Apache-2.0 license

[swift-badge]: https://img.shields.io/badge/Swift-3.0-orange.svg
[swift-url]: https://swift.org
[platform-badge]: https://img.shields.io/badge/Platforms-OS%20X%20--%20Linux-lightgray.svg
[platform-url]: https://swift.org
