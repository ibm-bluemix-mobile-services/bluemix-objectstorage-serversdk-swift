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
import HTTPSClient
/*
class OLD_LinuxRequestManager: BaseRequestManager{
	private let logger = Logger(name: "LinuxRequestManager")

	override func get(url:String, headers:[String:String]? = nil, completionHandler:NetworkRequestCompletionHandler = NOOPNetworkRequestCompletionHandler){
		self.sendRequest(url: url, method: .get , headers: headers, completionHandler: completionHandler)
	}

	override func post(url:String, headers:[String:String]? = nil, data:NSData? = nil, completionHandler:NetworkRequestCompletionHandler = NOOPNetworkRequestCompletionHandler){
		self.sendRequest(url: url, method: .post , headers: headers, data: data, completionHandler: completionHandler)
	}

	override func put(url:String, headers:[String:String]? = nil, data:NSData? = nil, completionHandler:NetworkRequestCompletionHandler = NOOPNetworkRequestCompletionHandler){
		self.sendRequest(url: url, method: .put , headers: headers, data: data, completionHandler: completionHandler)
	}

	override func delete(url:String, headers:[String:String]? = nil, completionHandler:NetworkRequestCompletionHandler = NOOPNetworkRequestCompletionHandler){
		self.sendRequest(url: url, method: .delete , headers: headers, completionHandler: completionHandler)
	}

	override func head(url:String, headers:[String:String]? = nil, completionHandler:NetworkRequestCompletionHandler = NOOPNetworkRequestCompletionHandler){
		self.sendRequest(url: url, method: .head , headers: headers, completionHandler: completionHandler)
	}

	/**
	Send a request

	- Parameter url: The URL to send request to
	- Parameter method: The HTTP method to use
	- Parameter contentType: The value of a 'Content-Type' header
	- Parameter data: The data to send in request body
	- Parameter completionHandler: NetworkRequestCompletionHandler instance
	*/
	private func sendRequest(url:String, method:S4.Method, headers:[String:String]? = nil, data: NSData? = nil, completionHandler:NetworkRequestCompletionHandler){

		print("anton1 :: \(url)")

		var requestUri = try? URI(url)

		guard requestUri != nil else {
			return completionHandler(error: ObjectStoreError.ConnectionFailure(message: "Invalid URI"), data: nil, status: nil, headers: nil)
		}
		
		if requestUri!.port == nil{
			requestUri!.port = requestUri?.scheme == "https" ? 443 : 80
		}
		
		print("anton2 :: \(requestUri!.path)")
		
		let client = try? Client(uri:requestUri!)
		guard client != nil else {
			return completionHandler(error: ObjectStoreError.ConnectionFailure(message: "Invalid URI"), data: nil, status: nil, headers: nil)
		}
		
		var s4headers = S4.Headers()
		
		if let headers = headers {
			for (name, value) in headers{
				var s4header = S4.Header()
				s4header.append(value)
				s4headers.headers.updateValue(s4header, forKey: CaseInsensitiveString(name))
			}
		}
		
		if let authToken = authToken{
			var s4header = S4.Header()
			s4header.append(authToken)
			s4headers.headers.updateValue(s4header, forKey: CaseInsensitiveString(BaseRequestManager.X_AUTH_TOKEN))
		}
		
		let response:S4.Response?;
		var byteArray:[UInt8] = []
		
		if let data = data {
			let dataLength = data.length
			let bytesCount = dataLength/sizeof(UInt8)
			byteArray = [UInt8](repeating:0, count: bytesCount)
			data.getBytes(&byteArray, length: dataLength)
			response = try? client!.send(method: method, uri: requestUri!.path!, headers: s4headers, body: Data(byteArray))
		} else {
			response = try? client!.send(method: method, uri: requestUri!.path!, headers: s4headers)
		}
		
		
		if var response = response {
			
			let statusCode = response.status.statusCode
			let s4headers = response.headers
			let responseBodyByteArray = try? response.body.becomeBuffer()
			let responseBodyByteArraySize = responseBodyByteArray?.bytes.count
			let responseBodyData = NSData(bytes: responseBodyByteArray?.bytes, length: responseBodyByteArraySize!)

			switch statusCode {
			case 401:
				self.logger.error(text: String(ObjectStoreError.Unauthorized))
				let responseBodyString = String(data:responseBodyData, encoding: NSUTF8StringEncoding)
				self.logger.debug(text: responseBodyString!)
				completionHandler(error: ObjectStoreError.Unauthorized, data: data, status: statusCode, headers: convertHeaders(s4headers: s4headers))
				break
			case 404:
				self.logger.error(text: String(ObjectStoreError.NotFound))
				let responseBodyString = String(data:responseBodyData, encoding: NSUTF8StringEncoding)
				self.logger.debug(text: responseBodyString!)
				completionHandler(error: ObjectStoreError.NotFound, data: data, status: statusCode, headers: convertHeaders(s4headers: s4headers))
				break
			case 400 ... 599:
				self.logger.error(text: String(ObjectStoreError.ServerError))
				let responseBodyString = String(data:responseBodyData, encoding: NSUTF8StringEncoding)
				self.logger.debug(text: responseBodyString!)
				completionHandler(error: ObjectStoreError.ServerError, data: data, status: statusCode, headers: convertHeaders(s4headers: s4headers))
				break
			default:
				completionHandler(error: nil, data: responseBodyData, status: statusCode, headers: convertHeaders(s4headers: s4headers))
				break
			}

			// var bodyString = String(bytes: bodyByteArray!, encoding: NSUTF8StringEncoding)

		} else {
			completionHandler(error: ObjectStoreError.ConnectionFailure(message: "Invalid Request"), data: nil, status: nil, headers: nil)
		}
	}
	
	func convertHeaders(s4headers:S4.Headers) -> [String:String]{
		var headers:Dictionary<String, String> = [:]
		for (key, value) in s4headers{
			headers.updateValue(value[0], forKey: key.string)
		}
		return headers;
	}
}
*/