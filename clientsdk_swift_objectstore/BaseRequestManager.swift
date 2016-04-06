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
internal typealias NetworkRequestCompletionHandler = (error:ObjectStoreError?, data:NSData?, response:NSHTTPURLResponse?) -> Void

public class BaseRequestManager {
	static let X_AUTH_TOKEN = "X-Auth-Token"
	private let logger = Logger(name: "BaseRequestManager")
	
	var authToken: String? = nil
	
	func get(url url:String, completionHandler:NetworkRequestCompletionHandler){
		logger.error("Not implemented")
	}
	
	func put(url url:String, contentType:String? = nil, data:NSData? = nil, completionHandler:NetworkRequestCompletionHandler){
		logger.error("Not implemented")
	}
	
	func delete(url url:String, completionHandler:NetworkRequestCompletionHandler){
		logger.error("Not implemented")
	}
	
	func post(url url:String, contentType: String? = nil, data:NSData? = nil, completionHandler:NetworkRequestCompletionHandler){
		logger.error("Not implemented")
	}
}