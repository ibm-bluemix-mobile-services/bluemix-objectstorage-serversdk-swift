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
@testable import BluemixObjectStorage
import SimpleHttpClient

public class MockServer_ObjectStorageTests: HttpClientProtocol{
	
	var storedData:NSData?
	
	func get(url: Url, headers: [String : String]?, completionHandler: SimpleHttpClient.NetworkRequestCompletionHandler){
		let pathComponents = url.path.components(separatedBy: "/")
		
		// Get list of objects in container
		if (pathComponents.count == 4 && pathComponents[3] == Consts.containerName){
			let objectsList = Consts.objectName + "\n" + Consts.objectName;
			completionHandler(error: nil, status: 200, headers: [:], data: objectsList.data(using: NSUTF8StringEncoding))
		}
		// Get content of a particular object
		else if (pathComponents.count == 5 && pathComponents[4] == Consts.objectName){
			completionHandler(error: nil, status: 200, headers: [:], data: self.storedData)
		}
		// Get list of containers
		else {
			let containersList = Consts.containerName + "\n" + Consts.containerName;
			completionHandler(error: nil, status: 200, headers: [:], data: containersList.data(using: NSUTF8StringEncoding))
		}
	}
	func put(url: Url, headers: [String : String]?, data: NSData?, completionHandler: SimpleHttpClient.NetworkRequestCompletionHandler){
		self.storedData = data
		completionHandler(error: nil, status: 200, headers: [:], data: nil)
	}
	func delete(url: Url, headers: [String : String]?, completionHandler: SimpleHttpClient.NetworkRequestCompletionHandler){
		completionHandler(error: nil, status: 200, headers: [:], data: nil)
	}
	func post(url: Url, headers: [String : String]?, data: NSData?, completionHandler: SimpleHttpClient.NetworkRequestCompletionHandler){
		if (url.host.contains("identity")){
			completionHandler(error: nil, status: 200, headers: ["X-Subject-Token":"some-token"], data: nil)
		} else {
			completionHandler(error: nil, status: 200, headers: [:], data: nil)
		}
	}
	func head(url: Url, headers: [String : String]?, completionHandler: SimpleHttpClient.NetworkRequestCompletionHandler){
		let responseHeaders:[String:String]
		if (url.path.contains(Consts.objectName)){
			responseHeaders = [Consts.objectMetadataTestName:Consts.metadataTestValue]
		} else if (url.path.contains(Consts.containerName)){
			responseHeaders = [Consts.containerMetadataTestName:Consts.metadataTestValue]
		} else {
			responseHeaders = [Consts.accountMetadataTestName:Consts.metadataTestValue]
		}
		completionHandler(error: nil, status: 200, headers: responseHeaders, data: nil)
	}

}