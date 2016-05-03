//
//  Consts.swift
//  BluemixObjectStore
//
//  Created by Anton Aleksandrov on 5/2/16.
//
//

import Foundation
import BluemixObjectStore
struct Consts{
	static let projectId = "012689c20a5b4e5e9f9e5c4f363cd39d"
	static let userId = "beb8c3848a5b411293f3503a53d92bea"
	static let password = "G(7o40/NyWcCX,=C"
	static let region = ObjectStore.REGION_DALLAS

	static let containerName = "testcontainer"
	static let objectName = "testobject.txt"
	static let accountMetadataTestName = "x-account-meta-test"
	static let containerMetadataTestName = "x-container-meta-test"
	static let objectMetadataTestName = "x-object-meta-test"
	static let metadataTestValue = "testvalue"
	static let testTimeout = 30.0
	static let objectData = "testdata".data(using: NSUTF8StringEncoding)!

}
