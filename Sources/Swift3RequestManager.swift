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
class Swift3RequestManager: BaseRequestManager{
	private let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
	private let logger = Logger(name: "Swift3RequestManager")
	
	/**
	Send a GET request
	
	- Parameter url: The URL to send request to
	- Parameter completionHandler: NetworkRequestCompletionHandler instance
	*/
	override func get(url url:String, completionHandler:NetworkRequestCompletionHandler = NOOPNetworkRequestCompletionHandler){
		logger.error("get Not implemented")
	}
	
	/**
	Send a PUT request
	
	- Parameter url: The URL to send request to
	- Parameter contentType: The value of a 'Content-Type' header
	- Parameter data: The data to send in request body
	- Parameter completionHandler: NetworkRequestCompletionHandler instance
	*/
	override func put(url url:String, contentType:String? = nil, data:NSData? = nil, completionHandler:NetworkRequestCompletionHandler = NOOPNetworkRequestCompletionHandler){
		logger.error("put Not implemented")
	}
	
	/**
	Send a DELETE request
	
	- Parameter url: The URL to send request to
	- Parameter completionHandler: NetworkRequestCompletionHandler instance
	*/
	override func delete(url url:String, completionHandler:NetworkRequestCompletionHandler = NOOPNetworkRequestCompletionHandler){
		logger.error("delete Not implemented")
	}
	
	/**
	Send a POST request
	
	- Parameter url: The URL to send request to
	- Parameter contentType: The value of a 'Content-Type' header
	- Parameter data: The data to send in request body
	- Parameter completionHandler: NetworkRequestCompletionHandler instance
	*/
	override func post(url url:String, contentType: String? = nil, data:NSData? = nil, completionHandler:NetworkRequestCompletionHandler = NOOPNetworkRequestCompletionHandler){
		sendRequest(url: url, method: "POST", contentType: contentType, data: data, completionHandler: completionHandler)
	}
	
	/**
	Send a request
	
	- Parameter url: The URL to send request to
	- Parameter method: The HTTP method to use
	- Parameter contentType: The value of a 'Content-Type' header
	- Parameter data: The data to send in request body
	- Parameter completionHandler: NetworkRequestCompletionHandler instance
	*/
	private func sendRequest(url url:String, method:String, contentType: String? = nil, data: NSData? = nil, completionHandler:NetworkRequestCompletionHandler){
		logger.info("sending request")
	}


}