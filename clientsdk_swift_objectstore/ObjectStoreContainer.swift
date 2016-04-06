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

/// ObjectStoreContainer instance represents a single container on IBM Object Store service
public class ObjectStoreContainer{
	
	/// Container name
	public let name:String!
	
	/// Container url
	public let url:String!
	
	internal let objectStore:ObjectStore!
	private let logger:Logger

	internal init(name:String, url:String, objectStore:ObjectStore){
		self.logger = Logger(name:"ObjectStoreContainer [\(name)]")
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
	public func storeObject(name name:String, data:NSData, completionHandler:(error: ObjectStoreError?, object: ObjectStoreObject?)->Void){
		logger.info("Storing object [\(name)]")
		let requestUrl = Utils.generateObjectUrl(baseUrl: self.url, objectName: name)
		
		objectStore.requestManager.put(url: requestUrl, data: data) { (error, data, response) in
			if let error = error{
				completionHandler(error: error, object: nil)
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
	public func retrieveObject(name name:String, completionHandler:(error: ObjectStoreError?, object: ObjectStoreObject?)->Void) {
		logger.info("Retrieving object [\(name)]")
		let requestUrl = Utils.generateObjectUrl(baseUrl: self.url, objectName: name)
		objectStore.requestManager.get(url: requestUrl) { (error, data, response) in
			if let error = error{
				completionHandler(error: error, object: nil)
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
	public func retrieveObjectsList(completionHandler completionHandler:(error: ObjectStoreError?, objects: [ObjectStoreObject]?) -> Void){
		logger.info("Retrieving objects list")
		
		objectStore.requestManager.get(url: self.url) { (error, data, response) in
			if let error = error{
				completionHandler(error: error, objects: nil)
			} else {
				self.logger.info("Retrieved objects list")
				var objectsList = [ObjectStoreObject]()
				let responseData = String(data: data!, encoding: NSUTF8StringEncoding)!
				let objectNames = responseData.componentsSeparatedByString("\n")
				for objectName:String in objectNames{
					if objectName.characters.count == 0 {
						continue
					}
					let objectUrl = self.url + "/" + Utils.urlPathEncode(objectName)
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
	public func deleteObject(name name:String, completionHandler:(error: ObjectStoreError?) -> Void){
		logger.info("Deleting object [\(name)]")
		let requestUrl = Utils.generateObjectUrl(baseUrl: self.url, objectName: name)
		objectStore.requestManager.get(url: requestUrl) { (error, data, response) in
			if let error = error{
				completionHandler(error: error)
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
	public func delete(completionHandler completionHandler:(error:ObjectStoreError?)->Void){
		self.objectStore.deleteContainer(name: self.name, completionHandler: completionHandler)
	}
	

}
