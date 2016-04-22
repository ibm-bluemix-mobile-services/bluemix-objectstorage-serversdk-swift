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

/// ObjectStoreObject instance represents a single object in the IBM Object Store service. Use ObjectStoreObjects instance to load object content.
public class ObjectStoreObject{
	
	/**
	Object instance name
	*/
	public let name:String!

	/**
	Object absolute URL
	*/
	public let url:String!
	internal let container:ObjectStoreContainer!
	private let logger:Logger
	
	/**
	Get cached object content. Requires `.load(shouldCache:true)` to be called previously
	*/
	var cachedData:NSData? = nil
	
	internal init(name:String, url: String, container:ObjectStoreContainer){
		self.logger = Logger(name:"ObjectStoreObject [\(container.name)]\\[\(name)]")
		self.name = name
		self.url = url
		self.container = container
	}
	
	/**
	Load the object content
	
	- Parameter shouldCache: Defines whether object content loaded from IBM Object Store service will be cached by this ObjectStoreObject instance
	- Parameter completionHandler: Closure to be executed once object is created
	*/
	public func load(shouldCache:Bool, completionHandler:(error: ObjectStoreError?, data:NSData?)->Void){
		#if swift(>=3)
			logger.info(text: "Loading object")
			container.objectStore.requestManager.get(url: self.url) { (error, data, response) in
				if let error = error {
					completionHandler(error: error, data: nil)
				} else {
					self.logger.info(text: "Loaded object")
					self.cachedData = shouldCache ? data : nil;
					completionHandler(error: nil, data:data)
				}
			}
		#else
			logger.info("Loading object")
			container.objectStore.requestManager.get(self.url) { (error, data, response) in
				if let error = error {
					completionHandler(error: error, data: nil)
				} else {
					self.logger.info("Loaded object")
					self.cachedData = shouldCache ? data : nil;
					completionHandler(error: nil, data:data)
				}
			}
		#endif
	}
	
	/**
	Delete the object
	*/
	public func delete(completionHandler:(error:ObjectStoreError?)->Void){
		#if swift(>=3)
			self.container.deleteObject(name: self.name, completionHandler: completionHandler)
		#else
			self.container.deleteObject(self.name, completionHandler: completionHandler)
		#endif
	}

	/**
	Update object metadata
	
	- Parameter metadata: a dictionary of metadata items, e.g. ["X-Object-Meta-Subject":"AmericanHistory"]. It is possible to supply multiple metadata items within same invocation. To delete a particular metadata item set it's value to an empty string, e.g. ["X-Object-Meta-Subject":""]. See Object Storage API v1 for more information about possible metadata items - http://developer.openstack.org/api-ref-objectstorage-v1.html
	- Parameter completionHandler: Closure to be executed once metadata is updated.
	*/
	public func updateMetadata(metadata:Dictionary<String, String>, completionHandler:(error:ObjectStoreError?) -> Void){
		#if swift(>=3)
			logger.info(text: "Updating object metadata :: \(metadata)")
			container.objectStore.requestManager.post(url: self.url, headers: metadata){(error, data, response) in
				if let error = error{
					completionHandler(error: error)
				} else {
					self.logger.info(text: "Object metadata updated")
					completionHandler(error: nil)
				}
			}
		#else
			logger.info("Updating object metadata :: \(metadata)")
			container.objectStore.requestManager.post(self.url, headers: metadata){(error, data, response) in
				if let error = error{
					completionHandler(error: error)
				} else {
					self.logger.info("Object metadata updated")
					completionHandler(error: nil)
				}
			}
		#endif
	}
	
	/**
	Retrieve object metadata. The metadata will be returned to a completionHandler as a Dictionary<String, String> instance with set of keys and values
	
	- Parameter completionHandler: Closure to be executed once metadata is retrieved.
	*/
	public func retrieveMetadata(completionHandler:(error:ObjectStoreError?, metadata: Dictionary<String, String>?) -> Void){
		#if swift(>=3)
			logger.info(text: "Retrieving object metadata")
			container.objectStore.requestManager.head(url: self.url){(error, data, response) in
				if let error = error{
					completionHandler(error:error, metadata: nil)
				} else {
					self.logger.info(text: "Metadata retrieved")
					var metadataHeaders = Dictionary<String, String>()
					for (headerName, headerValue) in response!.allHeaderFields{
						metadataHeaders[String(headerName)] = String(headerValue)
					}
					completionHandler(error: nil, metadata: metadataHeaders)
				}
			}
		#else
			logger.info("Retrieving object metadata")
			container.objectStore.requestManager.head(self.url){(error, data, response) in
				if let error = error{
					completionHandler(error:error, metadata: nil)
				} else {
					self.logger.info("Metadata retrieved")
					var metadataHeaders = Dictionary<String, String>()
					for (headerName, headerValue) in response!.allHeaderFields{
						metadataHeaders[String(headerName)] = String(headerValue)
					}
					completionHandler(error: nil, metadata: metadataHeaders)
				}
			}
		#endif
	}

}

#if swift(>=3)
#else
#endif
