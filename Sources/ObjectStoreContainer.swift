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
import BluemixHTTPSClient
import BluemixSimpleLogger

/// ObjectStoreContainer instance represents a single container on IBM Object Store service
public class ObjectStoreContainer{

	/// Container name
	public let name:String!

	/// Container url
	public let url:String!

	internal let objectStore:ObjectStore!
	private let logger:Logger

	internal init(name:String, url:String, objectStore:ObjectStore){
		self.logger = Logger(forName:"ObjectStoreContainer [\(name)]")
		self.name = name
		self.url = url
		self.objectStore = objectStore
	}

	/**
	Create a new object or update an existing one. In case object with a same name already exists it will be replaced with the new content.

	- Parameter name: The name of the object to be stored
	- Parameter data: The object content
	- Parameter completionHandler: Closure to be executed once object is created
	*/
	public func storeObject(name:String, data:NSData, completionHandler:(error: ObjectStoreError?, object: ObjectStoreObject?)->Void){
		logger.info("Storing object [\(name)]")
		let headers = Utils.createHeaderDictionaryWithAuthToken()
		let requestUrl = Utils.generateObjectUrl(baseUrl: self.url, objectName: name)
		HTTPSClient.put(url: requestUrl, headers: headers, data: data) { (error, data, status, headers) in
			if let error = error{
				completionHandler(error: ObjectStoreError.fromHttpError(error: error), object: nil)
			} else {
				self.logger.info("Stored object [\(name)]")
				completionHandler(error: nil, object: ObjectStoreObject(name:name, url: requestUrl, container: self))
			}
		}
	}

	/**
	Retrieve an existing object

	- Parameter name: The name of the object to be retrieved
	- Parameter completionHandler: Closure to be executed once object is retrieved
	*/
	public func retrieveObject(name:String, completionHandler:(error: ObjectStoreError?, object: ObjectStoreObject?)->Void) {
		logger.info("Retrieving object [\(name)]")
		let headers = Utils.createHeaderDictionaryWithAuthToken()
		let requestUrl = Utils.generateObjectUrl(baseUrl: self.url, objectName: name)
		HTTPSClient.get(url: requestUrl, headers: headers) { (error, data, status, headers) in
			if let error = error{
				completionHandler(error: ObjectStoreError.fromHttpError(error: error), object: nil)
			} else {
				self.logger.info("Retrieved object [\(name)]")
				completionHandler(error: nil, object: ObjectStoreObject(name:name, url: requestUrl, container: self))
			}
		}
	}

	/**
	Retrieve a list of existing objects

	- Parameter completionHandler: Closure to be executed once object list is retrieved
	*/
	public func retrieveObjectsList(completionHandler:(error: ObjectStoreError?, objects: [ObjectStoreObject]?) -> Void){
		logger.info("Retrieving objects list")
		let headers = Utils.createHeaderDictionaryWithAuthToken()
		HTTPSClient.get(url: self.url, headers: headers) { (error, data, status, headers) in
			if let error = error{
				completionHandler(error: ObjectStoreError.fromHttpError(error: error), objects: nil)
			} else {
				self.logger.info("Retrieved objects list")
				var objectsList = [ObjectStoreObject]()
				let responseData = String(data: data!, encoding: NSUTF8StringEncoding)!
				#if os(Linux)
					let objectNames = responseData.componentsSeparatedByString("\n")
				#else
					let objectNames = responseData.components(separatedBy: "\n")
				#endif
				for objectName:String in objectNames{
					if objectName.characters.count == 0 {
						continue
					}
					let objectUrl = self.url + "/" + Utils.urlPathEncode(text: objectName)
					objectsList.append(ObjectStoreObject(name:objectName, url: objectUrl, container: self))
				}
				completionHandler(error: nil, objects: objectsList)
			}
		}
	}

	/**
	Delete an existing object

	- Parameter name: The name of the object to be deleted
	- Parameter completionHandler: Closure to be executed once object is deleted
	*/
	public func deleteObject(name:String, completionHandler:(error: ObjectStoreError?) -> Void){
		logger.info("Deleting object [\(name)]")
		let headers = Utils.createHeaderDictionaryWithAuthToken()
		let requestUrl = Utils.generateObjectUrl(baseUrl: self.url, objectName: name)
		HTTPSClient.get(url: requestUrl, headers: headers) { (error, data, status, headers) in
			if let error = error{
				completionHandler(error: ObjectStoreError.fromHttpError(error: error))
			} else {
				self.logger.info("Deleted object [\(name)]")
				completionHandler(error: nil)
			}
		}
	}

	/**
	Delete the container

	- Parameter completionHandler: Closure to be executed once container is deleted
	*/
	public func delete(completionHandler:(error:ObjectStoreError?)->Void){
		self.objectStore.deleteContainer(name: self.name, completionHandler: completionHandler)
	}

	/**
	Update container metadata

	- Parameter metadata: a dictionary of metadata items, e.g. ["X-Container-Meta-Subject":"AmericanHistory"]. It is possible to supply multiple metadata items within same invocation. To delete a particular metadata item set it's value to an empty string, e.g. ["X-Container-Meta-Subject":""]. See Object Storage API v1 for more information about possible metadata items - http://developer.openstack.org/api-ref-objectstorage-v1.html
	- Parameter completionHandler: Closure to be executed once metadata is updated.
	*/
	public func updateMetadata(metadata:Dictionary<String, String>, completionHandler:(error:ObjectStoreError?) -> Void){
		logger.info("Updating container metadata :: \(metadata)")
		let headers = Utils.createHeaderDictionaryWithAuthToken(and: metadata)
		HTTPSClient.post(url: self.url, headers: headers){(error, data, status, headers) in
			if let error = error{
				completionHandler(error: ObjectStoreError.fromHttpError(error: error))
			} else {
				self.logger.info("Container metadata updated")
				completionHandler(error: nil)
			}
		}
	}

	/**
	Retrieve container metadata. The metadata will be returned to a completionHandler as a Dictionary<String, String> instance with set of keys and values

	- Parameter completionHandler: Closure to be executed once metadata is retrieved.
	*/
	public func retrieveMetadata(completionHandler:(error:ObjectStoreError?, metadata: Dictionary<String, String>?) -> Void){
		logger.info("Retrieving container metadata")
		let headers = Utils.createHeaderDictionaryWithAuthToken()
		HTTPSClient.head(url: self.url, headers: headers){(error, data, status, headers) in
			if let error = error{
				completionHandler(error: ObjectStoreError.fromHttpError(error: error), metadata: nil)
			} else {
				self.logger.info("Metadata retrieved")
				completionHandler(error: nil, metadata: headers)
			}
		}
	}
}

