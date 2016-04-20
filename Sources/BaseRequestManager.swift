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

/// Typealias for network requests callback
internal typealias NetworkRequestCompletionHandler = (error:ObjectStoreError?, data:NSData?, response:NSHTTPURLResponse?) -> Void
internal let NOOPNetworkRequestCompletionHandler:NetworkRequestCompletionHandler = {(a,b,c)->Void in}

/// Protocol for implementing RequestManager
internal protocol RequestManager {

	/// Send a GET request
	func get(url:String, completionHandler:NetworkRequestCompletionHandler)

	/// Send a PUT request
	func put(url:String, headers: [String:String]?, data:NSData?, completionHandler:NetworkRequestCompletionHandler)

	/// Send a DELETE request
	func delete(url:String, completionHandler:NetworkRequestCompletionHandler)

	/// Send a POST request
	func post(url:String, headers: [String:String]?, data:NSData?, completionHandler:NetworkRequestCompletionHandler)
}

/**
A stubbed implementation of RequestManager protocol, should never be used directly.
Known subclasses:

- NSURLRequestManager
*/
internal class BaseRequestManager: RequestManager {
	internal static let X_AUTH_TOKEN = "X-Auth-Token"
	internal var authToken: String? = nil

	private let logger = Logger(name: "BaseRequestManager")

	/**
	Send a GET request

	- Parameter url: The URL to send request to
	- Parameter completionHandler: NetworkRequestCompletionHandler instance
	*/
	func get(url:String, completionHandler:NetworkRequestCompletionHandler = NOOPNetworkRequestCompletionHandler){
		#if swift(>=3)
			logger.error(text: "Not implemented")
		#else
			logger.error("Not implemented")
		#endif
	}

	/**
	Send a PUT request

	- Parameter url: The URL to send request to
	- Parameter headers: Optional dictionary with HTTP headers for the request object (e.g. 'Content-Type')
	- Parameter data: The data to send in request body
	- Parameter completionHandler: NetworkRequestCompletionHandler instance
	*/
	func put(url:String, headers: [String:String]? = nil, data:NSData? = nil, completionHandler:NetworkRequestCompletionHandler = NOOPNetworkRequestCompletionHandler){
		#if swift(>=3)
			logger.error(text: "Not implemented")
		#else
			logger.error("Not implemented")
		#endif
	}

	/**
	Send a DELETE request

	- Parameter url: The URL to send request to
	- Parameter completionHandler: NetworkRequestCompletionHandler instance
	*/
	func delete(url:String, completionHandler:NetworkRequestCompletionHandler = NOOPNetworkRequestCompletionHandler){
		#if swift(>=3)
			logger.error(text: "Not implemented")
		#else
			logger.error("Not implemented")
		#endif
	}

	/**
	Send a POST request

	- Parameter url: The URL to send request to
	- Parameter headers: Optional dictionary with HTTP headers for the request object (e.g. 'Content-Type')
	- Parameter data: The data to send in request body
	- Parameter completionHandler: NetworkRequestCompletionHandler instance
	*/
	func post(url:String, headers: [String:String]? = nil, data:NSData? = nil, completionHandler:NetworkRequestCompletionHandler = NOOPNetworkRequestCompletionHandler){
		#if swift(>=3)
			logger.error(text: "Not implemented")
		#else
			logger.error("Not implemented")
		#endif
	}
}
