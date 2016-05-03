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
import BluemixSimpleLogger

/// ObjectStoreObject instance represents a single object in the IBM Object Store service. Use ObjectStoreObjects instance to load object content.
public class ObjectStoreObject{

	/// Object name
	public let name:String

	/// Object resource
	public let resource:HttpResourse

	internal let container:ObjectStoreContainer
	
	private let logger:Logger

	/**
	Retrieved object NSData
	*/
	public var data:NSData? = nil

	internal init(name:String, resource: HttpResourse, container:ObjectStoreContainer, data:NSData? = nil){
		self.logger = Logger(forName:"ObjectStoreObject [\(container.name)]\\[\(name)]")
		self.name = name
		self.resource = resource
		self.container = container
		self.data = data
	}
/*

	/*
	Load the object content

	- Parameter shouldCache: Defines whether object content loaded from IBM Object Store service will be cached by this ObjectStoreObject instance
	- Parameter completionHandler: Closure to be executed once object is created
	public func load(shouldCache:Bool = false) throws -> NSData{
		logger.info("Loading object")
		let headers = Utils.createHeaderDictionaryWithAuthToken()
		let response = HTTPSClient.get(url: self.url, headers: headers)
 
		if let error = response.error{
			throw ObjectStoreError.fromHttpError(error: error)
		} else {
			self.logger.info("Loaded object")
			self.cachedData = shouldCache ? response.data! : nil;
			return response.data!
		}
	}
	*/

	/**
	Delete the object
	*/
	public func delete() throws{
		try self.container.deleteObject(name: self.name)
	}

	/**
	Update object metadata

	- Parameter metadata: a dictionary of metadata items, e.g. ["X-Object-Meta-Subject":"AmericanHistory"]. It is possible to supply multiple metadata items within same invocation. To delete a particular metadata item set it's value to an empty string, e.g. ["X-Object-Meta-Subject":""]. See Object Storage API v1 for more information about possible metadata items - http://developer.openstack.org/api-ref-objectstorage-v1.html
	- Parameter completionHandler: Closure to be executed once metadata is updated.
	*/
	public func updateMetadata(metadata:Dictionary<String, String>) throws {
		logger.info("Updating metadata :: \(metadata)")
		let headers = Utils.createHeaderDictionaryWithAuthToken(and: metadata)
		let response = HTTPSClient.post(url: self.url, headers: headers)
		
		if let error = response.error{
			throw ObjectStoreError.fromHttpError(error: error)
		} else {
			self.logger.info("Metadata updated")
		}
	}

	/*
	Retrieve object metadata. The metadata will be returned to a completionHandler as a Dictionary<String, String> instance with set of keys and values

	- Parameter completionHandler: Closure to be executed once metadata is retrieved.
	public func retrieveMetadata() throws ->  Dictionary<String, String>{
		logger.info("Retrieving metadata")
		let headers = Utils.createHeaderDictionaryWithAuthToken()
		let response = HTTPSClient.head(url: self.url, headers: headers)
		
		if let error = response.error{
			throw ObjectStoreError.fromHttpError(error: error)
		} else {
			self.logger.info("Metadata retrieved")
			return headers
		}
	}
	*/
*/
}
