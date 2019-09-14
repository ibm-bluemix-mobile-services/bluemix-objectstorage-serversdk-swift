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
import SimpleLogger

/// ObjectStorageObject instance represents a single object in the IBM Object Store service. Use ObjectStorageObject instance to load object content.
public class ObjectStorageObject{

	/// Object name
	public let name:String

	/// Object resource
	internal let url: Url
	internal let container:ObjectStorageContainer
	private let httpClient:HttpClientProtocol
	private let logger:Logger

	/**
	Retrieved object NSData
	*/
	public var data:Data? = nil

	internal init(name:String, url: Url, container:ObjectStorageContainer, data:Data? = nil){
		self.logger = Logger(forName:"ObjectStoreObject [\(container.name)]\\[\(name)]")
		self.name = name
		self.url = url
		self.container = container
		self.data = data
		self.httpClient = container.objectStore.httpClient
	}

	/*
	Load the object content

	- Parameter shouldCache: Defines whether object content loaded from IBM Object Store service will be cached by this ObjectStoreObject instance
	- Parameter completionHandler: Closure to be executed once object is created
	*/
	public func load(shouldCache:Bool = false, completionHandler:@escaping (_ error:ObjectStorageError?, _ data:Data?)->Void){
		logger.info("Loading object")
		let headers = Utils.createHeaderDictionary(authToken: container.objectStore.authTokenManager?.authToken)
		httpClient.get(url: self.url, headers: headers) { error, status, headers, data in
			if let error = error{
				completionHandler(ObjectStorageError.from(httpError: error), nil)
			} else {
				self.logger.info("Loaded object")
				self.data = shouldCache ? data : nil;
				completionHandler(nil, data)
			}
		}
	}

	/**
	Delete the object
	*/
	public func delete(completionHandler:@escaping (_ error: ObjectStorageError?)->Void){
		self.container.deleteObject(name: self.name, completionHandler: completionHandler)
	}

	/**
	Update object metadata

	- Parameter metadata: a dictionary of metadata items, e.g. ["X-Object-Meta-Subject":"AmericanHistory"]. It is possible to supply multiple metadata items within same invocation. To delete a particular metadata item set it's value to an empty string, e.g. ["X-Object-Meta-Subject":""]. See Object Storage API v1 for more information about possible metadata items - http://developer.openstack.org/api-ref-objectstorage-v1.html
	- Parameter completionHandler: Closure to be executed once metadata is updated.
	*/
	public func updateMetadata(metadata:Dictionary<String, String>, completionHandler: @escaping (_ error: ObjectStorageError?)->Void){
		logger.info("Updating metadata :: \(metadata)")
		
		let headers = Utils.createHeaderDictionary(authToken: container.objectStore.authTokenManager?.authToken, additionalHeaders: metadata)
		
		httpClient.post(url: self.url, headers: headers, data: nil) { error, status, headers, data in
			if let error = error {
				completionHandler(ObjectStorageError.from(httpError: error))
			} else {
				self.logger.info("Metadata updated :: \(metadata)")
				completionHandler(nil)
			}
		}
	}

	/**
	Retrieve object metadata. The metadata will be returned to a completionHandler as a Dictionary<String, String> instance with set of keys and values

	- Parameter completionHandler: Closure to be executed once metadata is retrieved.
	*/
	public func retrieveMetadata(completionHandler: @escaping (_ error: ObjectStorageError?, _ metadata: [String:String]?) -> Void){
		logger.info("Retrieving metadata")
		
		let headers = Utils.createHeaderDictionary(authToken: container.objectStore.authTokenManager?.authToken)
		httpClient.head(url: self.url, headers: headers) { error, status, headers, data in
			if let error = error {
				completionHandler(ObjectStorageError.from(httpError: error), nil)
			} else {
                self.logger.info("Metadata retrieved :: \(headers ?? [:])")
				completionHandler(nil, headers);
			}
		}
	}
}
