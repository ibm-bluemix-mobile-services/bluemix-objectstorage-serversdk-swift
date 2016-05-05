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

import Foundation
import BluemixObjectStorage

struct Consts{
	static let projectId = ""
	static let userId = ""
	static let password = ""
	static let region = ObjectStorage.REGION_DALLAS

	static let containerName = "testcontainer"
	static let objectName = "testobject.txt"
	static let accountMetadataTestName = "x-account-meta-test"
	static let containerMetadataTestName = "x-container-meta-test"
	static let objectMetadataTestName = "x-object-meta-test"
	static let metadataTestValue = "testvalue"
	static let testTimeout = 30.0
	
	#if os(Linux)
		static let objectData = "testdata".dataUsingEncoding(NSUTF8StringEncoding)!
	#else
		static let objectData = "testdata".data(using: NSUTF8StringEncoding)!
	#endif
	
	static var bigObjectData:NSData {
		get {
			var str = "123456789 ";
			for _ in 1...17 {
				str += str
			}
			#if os(Linux)
				return str.dataUsingEncoding(NSUTF8StringEncoding)!
			#else
				return str.data(using: NSUTF8StringEncoding)!
			#endif
		}
	}

}
