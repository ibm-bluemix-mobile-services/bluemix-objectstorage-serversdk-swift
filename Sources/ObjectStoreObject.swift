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
	public func load(shouldCache shouldCache:Bool, completionHandler:(error: ObjectStoreError?, data:NSData?)->Void){
		logger.info("Loading object")
		container.objectStore.requestManager.get(url: self.url) { (error, data, response) in
			if let error = error {
				completionHandler(error: error, data: nil)
			} else {
				self.logger.info("Loaded object")
				if shouldCache {
					self.cachedData = data
				}
				completionHandler(error: nil, data:data)
			}
			
		}
	}
	
	/**
	Delete the object
	*/
	public func delete(completionHandler completionHandler:(error:ObjectStoreError?)->Void){
		self.container.deleteObject(name: self.name, completionHandler: completionHandler)
	}

	
}