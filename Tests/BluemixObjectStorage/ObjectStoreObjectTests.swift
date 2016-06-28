/*
*     Copyright 2016 IBM Corp.
*     Licensed under the Apache License, Version 2.0 (the "License");
*     you may not use this file except in compliance with the License.
*     You may obtain a copy of the License at
*     http://www.apache.org/licenses/LICENSE-2.0
*     Unless required by applicable law or agreed to in writing, software
*     distributed under the License is distributed on an "AS IS" BASIS,
*     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*     See the License for the specific language governing permissions and
*     limitations under the License.
*/

import XCTest
import Foundation
@testable import BluemixObjectStorage

class ObjectStoreObjectTests: XCTestCase {
	var expecatation:XCTestExpectation?
	
	override func setUp() {
		self.continueAfterFailure = false
	}

	func testObjectStoreObject(){
		expecatation = expectation(withDescription: "doneExpectation")
		
		let objStore = ObjectStorage(projectId: Consts.projectId)
		if Consts.mockServer{
			objStore.httpClient = MockServer_ObjectStorageTests()
		}
		XCTAssertNotNil(objStore, "Failed to initialize ObjectStore")
		XCTAssertEqual(objStore.projectId, Consts.projectId, "ObjectStore projectId is not equal to the one initialized with")
		
		
		objStore.connect(userId: Consts.userId, password: Consts.password, region: Consts.region, completionHandler: { (error) in
			XCTAssertNil(error, "error != nil")
			self.doTestCreateContainer(objStore: objStore)
		})
		
		waitForExpectations(withTimeout: Consts.testTimeout) { (error) in
			XCTAssertNil(error, "Test timeout")
		}
	}
	
	func doTestCreateContainer(objStore:ObjectStorage){
		objStore.createContainer(name: Consts.containerName) {(error, container) in
			XCTAssertNil(error, "error != nil")
			XCTAssertNotNil(container, "container == nil")
			XCTAssertEqual(container?.name, Consts.containerName, "container.name != \(Consts.containerName)")
			XCTAssertNotNil(container?.objectStore, "container.objectStore == nil")
			XCTAssertNotNil(container?.url, "url == nil")
			self.doTestStoreBigObject(container: container!)
		}
	}
	
	func doTestStoreBigObject(container: ObjectStorageContainer){
		let bigData = Consts.bigObjectData
		print("bigObjectData.length == \(bigData.length)")
		container.storeObject(name: Consts.objectName, data: bigData) { (error, object) in
			XCTAssertNil(error, "error != nil")
			XCTAssertNotNil(object, "object == nil")
			XCTAssertEqual(object?.name, Consts.objectName, "object.name != \(Consts.objectName)")
			XCTAssertNotNil(object?.container, "object.container == nil")
			XCTAssertNotNil(object?.url, "url == nil")
			XCTAssertEqual(object?.data, bigData, "object.data != Consts.bigObjectData")
			self.doTestLoadBigObjectNoCaching(object: object!)
		}
	}
	
	func doTestLoadBigObjectNoCaching(object: ObjectStorageObject){
		object.load(shouldCache: false) { error, data in
			XCTAssertNil(error, "error != nil")
			XCTAssertNotNil(data, "data == nil")
			XCTAssertEqual(data, Consts.bigObjectData, "data != Consts.bigObjectData")
			XCTAssertNil(object.data, "object.data != nil")
			self.doTestLoadObjectWithCaching(object: object)
		}
	}
	
	func doTestLoadObjectWithCaching(object: ObjectStorageObject){
		object.load(shouldCache: true) { error, data in
			XCTAssertNil(error, "error != nil")
			XCTAssertNotNil(data, "data == nil")
			XCTAssertEqual(data, Consts.bigObjectData, "data != Consts.bigObjectData")
			XCTAssertEqual(object.data, Consts.bigObjectData, "object.data != Consts.objectData")
			self.doTestUpdateMetadata(object: object)
		}
	}
	
	func doTestUpdateMetadata(object: ObjectStorageObject){
		let metadata:Dictionary<String, String> = [Consts.objectMetadataTestName:Consts.metadataTestValue]
		object.updateMetadata(metadata: metadata) {error in
			XCTAssertNil(error, "error != nil")
			self.doTestRetrieveMetadata(object: object)
		}
	}
	
	func doTestRetrieveMetadata(object: ObjectStorageObject){
		object.retrieveMetadata {error, metadata in
			XCTAssertNil(error, "error != nil")
			XCTAssertNotNil(metadata, "metadata == nil")
			XCTAssertEqual(metadata![Consts.objectMetadataTestName], Consts.metadataTestValue, "metadataTestValue != \(Consts.metadataTestValue)")
			self.doTestDeleteObject(object: object)
		}
	}
	
	
	func doTestDeleteObject(object: ObjectStorageObject){
		object.delete {error in
			XCTAssertNil(error, "error != nil")
			self.doTestDeleteContainer(container: object.container)
		}
	}
	
	func doTestDeleteContainer(container: ObjectStorageContainer){
		container.delete {error in
			XCTAssertNil(error, "error != nil")
			self.expecatation?.fulfill()
		}
	}
}

extension ObjectStoreObjectTests {
	static var allTests : [(String, (ObjectStoreObjectTests) -> () throws -> Void)] {
		return [
		       	("testObjectStoreObject", testObjectStoreObject)
		]
	}
}
