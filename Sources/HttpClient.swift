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
import SimpleHttpClient

internal protocol HttpClientProtocol{
	func get(url: Url, headers: [String : String]?, completionHandler: @escaping SimpleHttpClient.NetworkRequestCompletionHandler)
	func put(url: Url, headers: [String : String]?, data: Data?, completionHandler: @escaping SimpleHttpClient.NetworkRequestCompletionHandler)
	func delete(url: Url, headers: [String : String]?, completionHandler: @escaping SimpleHttpClient.NetworkRequestCompletionHandler)
	func post(url: Url, headers: [String : String]?, data: Data?, completionHandler: @escaping SimpleHttpClient.NetworkRequestCompletionHandler)
	func head(url: Url, headers: [String : String]?, completionHandler: @escaping SimpleHttpClient.NetworkRequestCompletionHandler)
}

internal class HttpClient: HttpClientProtocol{
	func get(url: Url, headers: [String : String]? = nil, completionHandler: @escaping SimpleHttpClient.NetworkRequestCompletionHandler){
		let resource = HttpResource(schema: url.schema, host: url.host, port: url.port, path: url.path)
		SimpleHttpClient.HttpClient.get(resource: resource, headers: headers, completionHandler: completionHandler)
	}
	
	func put(url: Url, headers: [String : String]? = nil, data: Data? = nil, completionHandler: @escaping SimpleHttpClient.NetworkRequestCompletionHandler){
		let resource = HttpResource(schema: url.schema, host: url.host, port: url.port, path: url.path)
		SimpleHttpClient.HttpClient.put(resource: resource, headers: headers, data: data, completionHandler: completionHandler)
	}
	
	func delete(url: Url, headers: [String : String]? = nil, completionHandler: @escaping SimpleHttpClient.NetworkRequestCompletionHandler){
		let resource = HttpResource(schema: url.schema, host: url.host, port: url.port, path: url.path)
		SimpleHttpClient.HttpClient.delete(resource: resource, headers: headers, completionHandler: completionHandler)
	}
	
	func post(url: Url, headers: [String : String]? = nil, data: Data? = nil, completionHandler: @escaping SimpleHttpClient.NetworkRequestCompletionHandler){
		let resource = HttpResource(schema: url.schema, host: url.host, port: url.port, path: url.path)
		SimpleHttpClient.HttpClient.post(resource: resource, headers: headers, data: data, completionHandler: completionHandler)
	}
	
	func head(url: Url, headers: [String : String]? = nil, completionHandler: @escaping SimpleHttpClient.NetworkRequestCompletionHandler){
		let resource = HttpResource(schema: url.schema, host: url.host, port: url.port, path: url.path)
		SimpleHttpClient.HttpClient.head(resource: resource, headers: headers, completionHandler: completionHandler)
	}
}

internal struct Url{
	var schema:String
	var host:String
	var port:String
	var path:String
	
	init(schema:String="https", host:String, port:String = "443", path:String){
		self.schema = schema
		self.host = host
		self.port = port
		self.path = path
	}
	
	func urlByAdding(pathComponent:String) -> Url{
		var url = Url(schema: self.schema, host: self.host, port: self.port, path: self.path)
		url.path += pathComponent
		return url as Url
	}
}
