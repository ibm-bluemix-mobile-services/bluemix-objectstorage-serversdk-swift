import Foundation
import HTTPSClient

class Tester{
	let projectId = ""
	let userId = ""
	let password = ""
	let authToken = ""
	let containerName = "FileContainer"
	//let objectName = "hello.txt"
	let objectName = "photo1.jpg"
	let region = ObjectStore.REGION_DALLAS

	func run(){
		let objStore = ObjectStore(projectId: projectId)
//		objStore.connect(authToken: authToken, region: region) { (error) in
//			if let error = error {
//				print("connect failure \(error)")
//			} else {
//				print("connect success")
//				self.getContainer(objStore: objStore)
//				self.updateMetadata(objStore: objStore)
//			}
//		}
		
		objStore.connect(userId: userId, password: password, region: region){ (error) in
			if let error = error {
				print("connect failure \(error)")
			} else {
				print("connect success")
				self.getContainer(objStore: objStore)
			}
		}
	}

	func updateMetadata(container:ObjectStoreContainer){
		let metadata:Dictionary<String, String> = ["X-Account-Meta-Test1":"111", "X-Account-Meta-Test2":"zzz", "X-Container-Meta-Web-Listings":"true"]
		container.updateMetadata(metadata: metadata) { (error) in
			if let error = error {
				print("updateMetadata failure \(error)")
			} else {
				print("updateMetadata success")
				self.retrieveMetadata(container: container)
			}
		}
	}

	func retrieveMetadata(container:ObjectStoreContainer) {
		container.retrieveMetadata { (error, metadata) in
			if let error = error {
				print("retrieveMetadata failure \(error)")
			} else {
				print("retrieveMetadata success \(metadata)")
			}
		}
	}

	func getContainer(objStore:ObjectStore){
		objStore.retrieveContainer(name: containerName, completionHandler: { (error, container) in
			if let error = error {
				print("retrieveContainer failure \(error)")
			} else {
				print("retrieveContainer success \(container!.url)")
				self.getObject(objContainer: container!)
				//self.updateMetadata(container: container!)
			}
		})

	}

	func getObject(objContainer:ObjectStoreContainer){
		objContainer.retrieveObject(name: objectName) { (error, object) in
			if let error = error {
				print("getObject failure \(error)")
			} else {
				print("getObject success")
				self.load(object: object!)
			}
		}
	}

	func load(object:ObjectStoreObject){
		object.load(shouldCache: false) { (error, data) in
			if let error = error {
				print("loadObject failure \(error)")
			} else {
				print("loadObject success \(data)")
				print("loadObject success \(String(data:data!, encoding:NSUTF8StringEncoding))")
				data?.write(toFile: "img1.jpg", atomically: true)
			}
		}
	}
}

Tester().run();
//NSRunLoop.current().run()

