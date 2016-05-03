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
@testable import BluemixObjectStore

class ObjectStoreContainerTests: XCTestCase {
	var expecatation:XCTestExpectation?
	
	func testObjectStoreContainer(){
		expecatation = expectation(withDescription: "doneExpectation")
		
		let objStore = ObjectStore(projectId: Consts.projectId)
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
	
	func doTestCreateContainer(objStore:ObjectStore){
		objStore.createContainer(name: Consts.containerName) {(error, container) in
			XCTAssertNil(error, "error != nil")
			XCTAssertNotNil(container, "container == nil")
			XCTAssertEqual(container?.name, Consts.containerName, "container.name != \(Consts.containerName)")
			XCTAssertNotNil(container?.objectStore, "container.objectStore == nil")
			XCTAssertNotNil(container?.resource, "container.resource == nil")
			self.doTestUpdateMetadata(container: container!)
		}
	}
	
	func doTestUpdateMetadata(container: ObjectStoreContainer){
		let metadata:Dictionary<String, String> = [Consts.containerMetadataTestName:Consts.metadataTestValue]
		
		container.updateMetadata(metadata: metadata) { (error) in
			XCTAssertNil(error, "error != nil")
			self.doTestRetrieveMetadata(container: container)
		}
	}
	
	func doTestRetrieveMetadata(container: ObjectStoreContainer){
		container.retrieveMetadata { (error, metadata) in
			XCTAssertNil(error, "error != nil")
			XCTAssertNotNil(metadata, "metadata == nil")
			XCTAssertEqual(metadata![Consts.containerMetadataTestName], Consts.metadataTestValue, "metadataTestValue != \(Consts.metadataTestValue)")
			self.doTestStoreObject(container: container)
		}
	}
	
	func doTestStoreObject(container: ObjectStoreContainer){
		
		container.storeObject(name: Consts.objectName, data: Consts.objectData) { (error, object) in
			XCTAssertNil(error, "error != nil")
			XCTAssertNotNil(object, "object == nil")
			XCTAssertEqual(object?.name, Consts.objectName, "object.name != \(Consts.objectName)")
			XCTAssertNotNil(object?.container, "object.container == nil")
			XCTAssertNotNil(object?.resource, "object.resource == nil")
			XCTAssertEqual(object?.data, Consts.objectData, "object.data != \(Consts.objectData)")
			self.doTestRetrieveObject(container: container)
		}
	}
	
	func doTestRetrieveObject(container: ObjectStoreContainer){
		container.retrieveObject(name: Consts.objectName) { (error, object) in
			XCTAssertNil(error, "error != nil")
			XCTAssertNotNil(object, "object == nil")
			XCTAssertEqual(object?.name, Consts.objectName, "object.name != \(Consts.objectName)")
			XCTAssertNotNil(object?.container, "object.container == nil")
			XCTAssertNotNil(object?.resource, "object.resource == nil")
			XCTAssertEqual(object?.data, Consts.objectData, "object.data != \(Consts.objectData)")
			self.doTestRetrieveObjectList(container: container)
		}
	}
	
	func doTestRetrieveObjectList(container: ObjectStoreContainer){
		container.retrieveObjectsList { (error, objects) in
			XCTAssertNil(error, "error != nil")
			XCTAssertNotNil(objects, "objects == nil")
			XCTAssertNotNil(objects?.count, "objects == nil")
			XCTAssertGreaterThan(Int(objects!.count), Int(0), "objects <= 0")
			let object = objects![0]
			XCTAssertNotNil(object.container, "object.container == nil")
			XCTAssertNotNil(object.resource, "object.resource == nil")
			self.doTestDeleteObject(container: container)
		}
	}
	
	func doTestDeleteObject(container: ObjectStoreContainer){
		container.deleteObject(name: Consts.objectName) { (error) in
			XCTAssertNil(error, "error != nil")
			self.doTestDeleteContainer(container: container)
		}
	}
	
	func doTestDeleteContainer(container: ObjectStoreContainer){
		container.delete { (error) in
			XCTAssertNil(error, "error != nil")
			self.expecatation?.fulfill()
		}
	}
}

extension ObjectStoreContainerTests {
	static var allTests : [(String, ObjectStoreContainerTests -> () throws -> Void)] {
		return [
			("testObjectStoreContainer", testObjectStoreContainer)
		]
	}
}
