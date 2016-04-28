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
/*
/// Typealias for network requests callback
//internal typealias NetworkRequestCompletionHandler = (error:ObjectStoreError?, data:NSData?, response: NSHTTPURLResponse?) -> Void
internal typealias NetworkRequestCompletionHandler = (error:ObjectStoreError?, data:NSData?, status:Int?, headers: [String:String]?) -> Void

internal let NOOPNetworkRequestCompletionHandler:NetworkRequestCompletionHandler = {(a,b,c,d)->Void in}


/// Protocol for implementing RequestManager
internal protocol RequestManager{

	/// Send a GET request
	func get(url:String, headers:[String:String]?, completionHandler:NetworkRequestCompletionHandler)

	/// Send a PUT request
	func put(url:String, headers:[String:String]?, data:NSData?, completionHandler:NetworkRequestCompletionHandler)

	/// Send a DELETE request
	func delete(url:String, headers:[String:String]?, completionHandler:NetworkRequestCompletionHandler)

	/// Send a POST request
	func post(url:String, headers:[String:String]?, data:NSData?, completionHandler:NetworkRequestCompletionHandler)

	/// Send a HEAD request
	func head(url:String, headers:[String:String]?, completionHandler:NetworkRequestCompletionHandler)

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
	func get(url:String, headers:[String:String]? = nil, completionHandler:NetworkRequestCompletionHandler = NOOPNetworkRequestCompletionHandler){
			self.sendRequest(url: url, method: "GET", headers: headers, completionHandler: completionHandler)
	}

	/**
	Send a HEAD request

	- Parameter url: The URL to send request to
	- Parameter completionHandler: NetworkRequestCompletionHandler instance
	*/
	func head(url:String, headers:[String:String]? = nil, completionHandler:NetworkRequestCompletionHandler = NOOPNetworkRequestCompletionHandler){
			sendRequest(url: url, method: "HEAD", headers: headers, completionHandler: completionHandler)
	}


	/**
	Send a PUT request

	- Parameter url: The URL to send request to
	- Parameter contentType: The value of a 'Content-Type' header
	- Parameter data: The data to send in request body
	- Parameter completionHandler: NetworkRequestCompletionHandler instance
	*/
	func put(url:String, headers:[String:String]? = nil, data:NSData? = nil, completionHandler:NetworkRequestCompletionHandler = NOOPNetworkRequestCompletionHandler){
			sendRequest(url: url, method: "PUT", headers: headers, data: data, completionHandler: completionHandler)
	}

	/**
	Send a DELETE request

	- Parameter url: The URL to send request to
	- Parameter completionHandler: NetworkRequestCompletionHandler instance
	*/
	func delete(url:String, headers:[String:String]? = nil, completionHandler:NetworkRequestCompletionHandler){
			sendRequest(url: url, method: "DELETE", headers: headers, completionHandler: completionHandler)
	}

	/**
	Send a POST request

	- Parameter url: The URL to send request to
	- Parameter headers: A dictionary of http headers to add
	- Parameter data: The data to send in request body
	- Parameter completionHandler: NetworkRequestCompletionHandler instance
	*/
	func post(url:String, headers:[String:String]? = nil, data:NSData? = nil, completionHandler:NetworkRequestCompletionHandler = NOOPNetworkRequestCompletionHandler){
			sendRequest(url: url, method: "POST", headers: headers, data: data, completionHandler: completionHandler)
	}

	/**
	Send a request

	- Parameter url: The URL to send request to
	- Parameter method: The HTTP method to use
	- Parameter contentType: The value of a 'Content-Type' header
	- Parameter data: The data to send in request body
	- Parameter completionHandler: NetworkRequestCompletionHandler instance
	*/
	private func sendRequest(url:String, method:String, headers:[String:String]? = nil, data: NSData? = nil, completionHandler:NetworkRequestCompletionHandler){
			logger.error(text: "Not implemented")
	}
}
*/