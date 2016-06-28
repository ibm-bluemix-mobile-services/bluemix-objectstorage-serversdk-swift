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

class ObjectStoreContainerTests: XCTestCase {
	var expecatation:XCTestExpectation?
	
	override func setUp() {
		self.continueAfterFailure = false
	}

	func testObjectStoreContainer(){
		expecatation = expectation(withDescription: "doneExpectation")
		
		let objStore = ObjectStorage(projectId: Consts.projectId)
		if Consts.mockServer{
			objStore.httpClient = MockServer_ObjectStorageTests()
		}
		XCTAssertNotNil(objStore)
		XCTAssertEqual(objStore.projectId, Consts.projectId)
		
		
		objStore.connect(userId: Consts.userId, password: Consts.password, region: Consts.region, completionHandler: { (error) in
			XCTAssertNil(error)
			self.doTestCreateContainer(objStore: objStore)
		})
		
		waitForExpectations(withTimeout: Consts.testTimeout) { (error) in
			XCTAssertNil(error, "Test timeout")
		}
	}
	
	func doTestCreateContainer(objStore:ObjectStorage){
		objStore.createContainer(name: Consts.containerName) {(error, container) in
			XCTAssertNil(error)
			XCTAssertNotNil(container)
			XCTAssertEqual(container?.name, Consts.containerName)
			XCTAssertNotNil(container?.objectStore)
			XCTAssertNotNil(container?.url)
			self.doTestUpdateMetadata(container: container!)
		}
	}
	
	func doTestUpdateMetadata(container: ObjectStorageContainer){
		let metadata:Dictionary<String, String> = [Consts.containerMetadataTestName:Consts.metadataTestValue]
		
		container.updateMetadata(metadata: metadata) { (error) in
			XCTAssertNil(error)
			self.doTestRetrieveMetadata(container: container)
		}
	}
	
	func doTestRetrieveMetadata(container: ObjectStorageContainer){
		container.retrieveMetadata { (error, metadata) in
			XCTAssertNil(error)
			XCTAssertNotNil(metadata)
			XCTAssertEqual(metadata![Consts.containerMetadataTestName], Consts.metadataTestValue)
			self.doTestStoreObject(container: container)
		}
	}
	
	func doTestStoreObject(container: ObjectStorageContainer){
		
		container.storeObject(name: Consts.objectName, data: Consts.objectData) { (error, object) in
			XCTAssertNil(error)
			XCTAssertNotNil(object)
			XCTAssertEqual(object?.name, Consts.objectName)
			XCTAssertNotNil(object?.container)
			XCTAssertNotNil(object?.url)
			XCTAssertEqual(object?.data, Consts.objectData)
			self.doTestRetrieveObject(container: container)
		}
	}
	
	func doTestRetrieveObject(container: ObjectStorageContainer){
		container.retrieveObject(name: Consts.objectName) { (error, object) in
			XCTAssertNil(error)
			XCTAssertNotNil(object)
			XCTAssertEqual(object?.name, Consts.objectName)
			XCTAssertNotNil(object?.container)
			XCTAssertNotNil(object?.url)
			XCTAssertEqual(object?.data, Consts.objectData)
			self.doTestRetrieveObjectList(container: container)
		}
	}
	
	func doTestRetrieveObjectList(container: ObjectStorageContainer){
		container.retrieveObjectsList { (error, objects) in
			XCTAssertNil(error)
			XCTAssertNotNil(objects)
			XCTAssertNotNil(objects?.count)
			XCTAssertGreaterThan(Int(objects!.count), Int(0))
			let object = objects![0]
			XCTAssertNotNil(object.container)
			XCTAssertNotNil(object.url)
			self.doTestDeleteObject(container: container)
		}
	}
	
	func doTestDeleteObject(container: ObjectStorageContainer){
		container.deleteObject(name: Consts.objectName) { (error) in
			XCTAssertNil(error)
			self.doTestDeleteContainer(container: container)
		}
	}
	
	func doTestDeleteContainer(container: ObjectStorageContainer){
		container.delete { (error) in
			XCTAssertNil(error)
			self.expecatation?.fulfill()
		}
	}
}

extension ObjectStoreContainerTests {
	static var allTests : [(String, (ObjectStoreContainerTests) -> () throws -> Void)] {
		return [
			("testObjectStoreContainer", testObjectStoreContainer)
		]
	}
}
