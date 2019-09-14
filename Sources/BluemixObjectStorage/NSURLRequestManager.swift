/*
*     Copyright 2016 IBM Corp.
*     Licensed under the Apache License, Version 2.0 (the "License");
*     you may not use this file except in compliance with the License.
*     You may obtain a copy of the License at
*     http://www.apache.org/licenses/LICENSE-2.0
*     Unless required by applicable law or agreed to in writing, software
*     distributed under the License is distributed on an "AS IS" BASIS,
*     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
*     See the License for the specific language governing permissions and
*     limitations under the License.
*/

import Foundation

/*
/// NSURL based implementation of RequestManager protocol. Used as a default RequestManager in BMSObjectStore
internal class NSURLRequestManager: BaseRequestManager {
	private let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
	private let logger = Logger(name: "RequestManager")

	/**
	Send a request

	- Parameter url: The URL to send request to
	- Parameter method: The HTTP method to use
	- Parameter contentType: The value of a 'Content-Type' header
	- Parameter data: The data to send in request body
	- Parameter completionHandler: NetworkRequestCompletionHandler instance
	*/
	private func sendRequest(url:String, method:String, headers:[String:String]? = nil, data: NSData? = nil, completionHandler:NetworkRequestCompletionHandler){
		let request = NSMutableURLRequest(url: NSURL(string: url)!)
		request.httpMethod = method

		if let headers = headers{
			for (headerName, headerValue) in headers{
				request.setValue(headerValue, forHTTPHeaderField: headerName)
			}
		}

		if let authToken = authToken{
			request.setValue(authToken, forHTTPHeaderField: BaseRequestManager.X_AUTH_TOKEN)
		}

		let networkTaskCompletionHandler = {
			(data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in

			guard error == nil else {
				self.logger.error(text: String(ObjectStoreError.ConnectionFailure(message: error!.description)))
				completionHandler(error:ObjectStoreError.ConnectionFailure(message: error!.description), data: nil, response: nil)
				return
			}

			let httpResponse = response as! NSHTTPURLResponse

			switch httpResponse.statusCode {
			case 401:
				self.logger.error(text: String(ObjectStoreError.Unauthorized))
				self.logger.debug(text: httpResponse.description)
				completionHandler(error: ObjectStoreError.Unauthorized, data: data, response: httpResponse)
				break
			case 404:
				self.logger.error(text: String(ObjectStoreError.NotFound))
				self.logger.debug(text: httpResponse.description)
				completionHandler(error: ObjectStoreError.NotFound, data: data, response: httpResponse)
				break
			case 400 ... 599:
				self.logger.error(text: String(ObjectStoreError.ServerError))
				self.logger.debug(text: httpResponse.description)
				self.logger.debug(text: String(data:data!, encoding:NSUTF8StringEncoding)!)
				completionHandler(error: ObjectStoreError.ServerError, data: data, response: httpResponse)
				break
			default:
				completionHandler(error: nil, data: data, response: httpResponse)
				break
			}
		}

		if (data == nil){
			defaultSession.dataTask(with: request, completionHandler: networkTaskCompletionHandler).resume();
		} else {
			defaultSession.uploadTask(with: request, from: data, completionHandler: networkTaskCompletionHandler).resume();
		}
	}


	/**
	Send a GET request

	- Parameter url: The URL to send request to
	- Parameter completionHandler: NetworkRequestCompletionHandler instance
	*/
	override func get(url:String, headers:[String:String]? = nil, completionHandler:NetworkRequestCompletionHandler = NOOPNetworkRequestCompletionHandler){
		sendRequest(url: url, method: "GET", headers: headers, completionHandler: completionHandler)
	}

	/**
	Send a HEAD request

	- Parameter url: The URL to send request to
	- Parameter completionHandler: NetworkRequestCompletionHandler instance
	*/
	override func head(url:String, headers:[String:String]? = nil, completionHandler:NetworkRequestCompletionHandler = NOOPNetworkRequestCompletionHandler){
		sendRequest(url: url, method: "HEAD", headers: headers, completionHandler: completionHandler)
	}


	/**
	Send a PUT request

	- Parameter url: The URL to send request to
	- Parameter contentType: The value of a 'Content-Type' header
	- Parameter data: The data to send in request body
	- Parameter completionHandler: NetworkRequestCompletionHandler instance
	*/
	override func put(url:String, headers:[String:String]? = nil, data:NSData? = nil, completionHandler:NetworkRequestCompletionHandler = NOOPNetworkRequestCompletionHandler){
		sendRequest(url: url, method: "PUT", headers: headers, data: data, completionHandler: completionHandler)
	}

	/**
	Send a DELETE request

	- Parameter url: The URL to send request to
	- Parameter completionHandler: NetworkRequestCompletionHandler instance
	*/
	override func delete(url:String, headers:[String:String]? = nil, completionHandler:NetworkRequestCompletionHandler){
		sendRequest(url: url, method: "DELETE", headers: headers, completionHandler: completionHandler)
	}

	/**
	Send a POST request

	- Parameter url: The URL to send request to
	- Parameter headers: A dictionary of http headers to add
	- Parameter data: The data to send in request body
	- Parameter completionHandler: NetworkRequestCompletionHandler instance
	*/
	override func post(url:String, headers:[String:String]? = nil, data:NSData? = nil, completionHandler:NetworkRequestCompletionHandler = NOOPNetworkRequestCompletionHandler){
		sendRequest(url: url, method: "POST", headers: headers, data: data, completionHandler: completionHandler)
	}
}
*/
