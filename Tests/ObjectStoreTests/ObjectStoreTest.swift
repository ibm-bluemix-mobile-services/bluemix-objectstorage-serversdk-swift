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

class ObjectStoreTests: XCTestCase {
	var expecatation:XCTestExpectation?
	
	func testObjectStore(){
		expecatation = expectation(withDescription: "doneExpectation")

		let objStore = ObjectStore(projectId: Consts.projectId)
		XCTAssertNotNil(objStore, "Failed to initialize ObjectStore")
		XCTAssertEqual(objStore.projectId, Consts.projectId, "ObjectStore projectId is not equal to the one initialized with")
		

		objStore.connect(userId: Consts.userId, password: Consts.password, region: Consts.region, completionHandler: { (error) in
			XCTAssertNil(error, "error != nil")
			self.doTestUpdateMetadata(objStore: objStore)
		})
		
		waitForExpectations(withTimeout: Consts.testTimeout) { (error) in
			XCTAssertNil(error, "Test timeout")
		}
	}
	
	func doTestUpdateMetadata(objStore: ObjectStore){
		let metadata:Dictionary<String, String> = [Consts.accountMetadataTestName:Consts.metadataTestValue]
		objStore.updateMetadata(metadata: metadata) { (error) in
			XCTAssertNil(error, "error != nil")
			self.doTestRetrieveMetadata(objStore: objStore)
		}
	}
	
	func doTestRetrieveMetadata(objStore: ObjectStore){
		objStore.retrieveMetadata { (error, metadata) in
			XCTAssertNil(error, "error != nil")
			XCTAssertNotNil(metadata, "metadata == nil")
			XCTAssertEqual(metadata![Consts.accountMetadataTestName], Consts.metadataTestValue, "metadataTestValue != \(Consts.metadataTestValue)")
			self.doTestCreateContainer(objStore: objStore)
		}
	}
	
	func doTestCreateContainer(objStore:ObjectStore){
		objStore.createContainer(name: Consts.containerName) {(error, container) in
			XCTAssertNil(error, "error != nil")
			XCTAssertNotNil(container, "container == nil")
			XCTAssertEqual(container?.name, Consts.containerName, "container.name != \(Consts.containerName)")
			XCTAssertNotNil(container?.objectStore, "container.objectStore == nil")
			XCTAssertNotNil(container?.resource, "container.resource == nil")
			self.doTestRetrieveContainer(objStore: objStore)
		}
	}
	
	func doTestRetrieveContainer(objStore:ObjectStore){
		objStore.retrieveContainer(name: Consts.containerName) { (error, container) in
			XCTAssertNil(error, "error != nil")
			XCTAssertNotNil(container, "container == nil")
			XCTAssertEqual(container?.name, Consts.containerName, "container.name != \(Consts.containerName)")
			XCTAssertNotNil(container?.objectStore, "container.objectStore == nil")
			XCTAssertNotNil(container?.resource, "container.resource == nil")
			self.doTestRetrieveContainersList(objStore: objStore)
		}
	}
	
	func doTestRetrieveContainersList(objStore:ObjectStore){
		objStore.retrieveContainersList { (error, containers) in
			XCTAssertNil(error, "error != nil")
			XCTAssertNotNil(containers, "containers == nil")
			XCTAssertNotNil(containers?.count, "containers.count == nil")
			XCTAssertGreaterThan(Int(containers!.count), Int(0), "containers.count <= 0")
			let container = containers![0]
			XCTAssertNotNil(container.objectStore, "container.objectStore == nil")
			XCTAssertNotNil(container.resource, "container.resource == nil")
			self.doTestDeleteContainer(objStore: objStore)
		}
	}


	func doTestDeleteContainer(objStore:ObjectStore){
		objStore.deleteContainer(name: Consts.containerName) { (error) in
			XCTAssertNil(error, "error != nil")
			self.expecatation?.fulfill()
		}
	}
}


extension ObjectStoreTests {
	static var allTests : [(String, ObjectStoreTests -> () throws -> Void)] {
		return [
		       	("testObjectStore", testObjectStore)
		]
	}
}
