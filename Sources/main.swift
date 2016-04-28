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

	func run() throws -> AnyObject {
		let objStore = ObjectStore(projectId: projectId)

		try objStore.connect(userId: userId, password: password, region: region)
		//try objStore.connect(authToken: authToken, region: region)
		//try objStore.updateMetadata(metadata: ["X-Account-Meta-Test":"X-Account-Meta-Text"])
		//let _ = try objStore.retrieveMetadata()

		let container = try objStore.retrieveContainer(name: containerName)
		//try container.updateMetadata(metadata: ["X-Container-Meta-Test":"X-Container-Meta-Text"])
		//let _ = try container.retrieveMetadata()

		let object = try container.retrieveObject(name: objectName)
		//try object.updateMetadata(metadata: ["X-Object-Meta-Test":"X-Object-Meta-Text"])
		let _ = try object.retrieveMetadata()
		//let objectData = try object.load()
		print("ok")
		return "ok"
	}
}

let res = try? Tester().run();
//NSRunLoop.current().run()
