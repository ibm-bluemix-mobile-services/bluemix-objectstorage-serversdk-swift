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
import SimpleLogger

/// Use ObjectStore instance to connect to IBM Object Store service and manage containers
public class ObjectStorage {

	/// Use this value in .connect(...)  methods to connect to Dallas instance of IBM Object Store
	public static let REGION_DALLAS = "DALLAS"
	//public static let DALLAS_RESOURCE = HttpResource(schema: "https", host: "dal.objectstorage.open.softlayer.com", port: "443", path: "/v1/AUTH_")
	internal static let DALLAS_URL = Url(host: "dal.objectstorage.open.softlayer.com", path: "/v1/AUTH_")

	/// Use this value in .connect(...)  methods to connect to London instance of IBM Object Store
	public static let REGION_LONDON = "LONDON"
//	public static let LONDON_RESOURCE = HttpResource(schema: "https", host: "lon.objectstorage.open.softlayer.com", port: "443", path: "/v1/AUTH_")
	internal static let LONDON_URL = Url(host: "lon.objectstorage.open.softlayer.com", path: "/v1/AUTH_")


	private let logger:Logger

	internal var projectId:String! = ""
	internal var projectUrl: Url?
	internal var authTokenManager:AuthTokenManager?
	internal var httpClient: HttpClientProtocol

	/**
	Initialize ObjectStore by supplying projectId and optionally requestManager

	- Parameter projectId: ProjectId provided by the IBM Object Store. Can be obtained via VCAP_SERVICES, service instance keys or IBM Object Store dashboard.
	*/
	public init(projectId:String){
		self.projectId = projectId
		logger = Logger(forName:"ObjectStore [\(self.projectId)]")
		self.httpClient = HttpClient()
	}

	/**
	Connect to ObjectStore

	- Parameter userId: UserId provided by the IBM Object Store. Can be obtained via VCAP_SERVICES, service instance keys or IBM Object Store dashboard.
	- Parameter password: Password provided by the IBM Object Store. Can be obtained via VCAP_SERVICES, service instance keys or IBM Object Store dashboard.
	- Parameter region: Defines whether ObjectStore should connect to Dallas or London instance of IBM Object Store. Use *ObjectStore.REGION_DALLAS* and *ObjectStore.REGION_LONDON* as values
	*/
	public func connect(userId:String, password:String, region:String, completionHandler:@escaping (_ error: ObjectStorageError?) -> Void) {
		self.authTokenManager = AuthTokenManager(projectId: projectId, userId: userId, password: password, httpClient: httpClient)

		authTokenManager?.refreshAuthToken { (error) in
			if error != nil {
				completionHandler(ObjectStorageError.FailedToRetrieveAuthToken)
			} else {
				self.projectUrl = (region == ObjectStorage.REGION_DALLAS) ? ObjectStorage.DALLAS_URL : ObjectStorage.LONDON_URL
				self.projectUrl = self.projectUrl?.urlByAdding(pathComponent: self.projectId)
				completionHandler(nil)
			}
		}
	}

	/**
	Create a new container

	- Parameter name: The name of container to be created
	- Parameter completionHandler: Closure to be executed once container is created.
	*/
	public func createContainer(name:String, completionHandler: @escaping (_ error:ObjectStorageError?, _ container: ObjectStorageContainer?) -> Void){
		logger.info("Creating container [\(name)]")

		guard self.projectUrl != nil else{
			logger.error(String(describing: ObjectStorageError.NotConnected))
			return completionHandler(ObjectStorageError.NotConnected, nil)
		}

		let headers = Utils.createHeaderDictionary(authToken: authTokenManager?.authToken)
		let url = self.projectUrl?.urlByAdding(pathComponent: Utils.urlPathEncode(text: "/" + name))

		httpClient.put(url: url!, headers: headers, data: nil) { error, status, headers, data in
			if let error = error {
				completionHandler(ObjectStorageError.from(httpError: error), nil)
			} else {
				self.logger.info("Created container [\(name)]")
				let container = ObjectStorageContainer(name: name, url: url!, objectStore: self)
				completionHandler(nil, container)
			}
		}
	}


	/**
	Retrieve an existing container

	- Parameter name: The name of container to retrieve
	- Parameter completionHandler: Closure to be executed once container is retrieved.
	*/
	public func retrieveContainer(name:String, completionHandler: @escaping (_ error:ObjectStorageError?, _ container: ObjectStorageContainer?) -> Void){
		logger.info("Retrieving container [\(name)]")

		guard self.projectUrl != nil else{
			logger.error(String(describing: ObjectStorageError.NotConnected))
			return completionHandler(ObjectStorageError.NotConnected, nil)
		}

		let headers = Utils.createHeaderDictionary(authToken: authTokenManager?.authToken)
		let url = self.projectUrl?.urlByAdding(pathComponent: Utils.urlPathEncode(text: "/" + name))

		httpClient.get(url: url!, headers: headers) { error, status, headers, data in
			if let error = error {
				completionHandler(ObjectStorageError.from(httpError: error), nil)
			} else {
				self.logger.info("Retrieved container [\(name)]")
				let container = ObjectStorageContainer(name: name, url: url!, objectStore: self)
				completionHandler(nil, container)
			}
		}
	}

	/**
	Retrieve a list of existing containers

	- Parameter completionHandler: Closure to be executed once list of containeds is retrieved.
	*/
	public func retrieveContainersList(completionHandler: @escaping (_ error:ObjectStorageError?, _ containers: [ObjectStorageContainer]?) -> Void){
		logger.info("Retrieving containers list")

		guard self.projectUrl != nil else{
			logger.error(String(describing: ObjectStorageError.NotConnected))
			return completionHandler(ObjectStorageError.NotConnected, nil)
		}

		let headers = Utils.createHeaderDictionary(authToken: authTokenManager?.authToken)

		httpClient.get(url: self.projectUrl!, headers: headers) {error, status, headers, data in
			if let error = error{
				completionHandler(ObjectStorageError.from(httpError: error), nil)
			} else {
				self.logger.info("Retrieved containers list")
				var containersList = [ObjectStorageContainer]()

				let responseBodyString = String(data: data!, encoding: String.Encoding.utf8)!

				let containerNames = responseBodyString.components(separatedBy: "\n")

				for containerName:String in containerNames{
					if containerName.characters.count == 0 {
						continue
					}
					let containerUrl = self.projectUrl?.urlByAdding(pathComponent: Utils.urlPathEncode(text: "/" + containerName))
					let container = ObjectStorageContainer(name: containerName, url: containerUrl!, objectStore: self)
					containersList.append(container)
				}
				completionHandler(nil, containersList)
			}
		}
	}

	/**
	Delete an existing container

	- Parameter name: The name of container to delete
	- Parameter completionHandler: Closure to be executed once container is deleted.
	*/
	public func deleteContainer(name:String, completionHandler: @escaping (_ error:ObjectStorageError?) -> Void){
		logger.info("Deleting container [\(name)]")

		guard self.projectUrl != nil else{
			logger.error(String(describing: ObjectStorageError.NotConnected))
			return completionHandler(ObjectStorageError.NotConnected)
		}

		let headers = Utils.createHeaderDictionary(authToken: authTokenManager?.authToken)
		let url = self.projectUrl?.urlByAdding(pathComponent: Utils.urlPathEncode(text: "/" + name))

		httpClient.delete(url: url!, headers: headers) { error, status, headers, data in
			if let error = error {
				completionHandler(ObjectStorageError.from(httpError: error))
			} else {
				self.logger.info("Deleted container [\(name)]")
				completionHandler(nil)
			}
		}
	}


	/**
	Update account metadata

	- Parameter metadata: a dictionary of metadata items, e.g. ["X-Account-Meta-Subject":"AmericanHistory"]. It is possible to supply multiple metadata items within same invocation. To delete a particular metadata item set it's value to an empty string, e.g. ["X-Account-Meta-Subject":""]. See Object Storage API v1 for more information about possible metadata items - http://developer.openstack.org/api-ref-objectstorage-v1.html
	- Parameter completionHandler: Closure to be executed once metadata is updated.
	*/
	public func updateMetadata(metadata:Dictionary<String, String>, completionHandler: @escaping (_ error:ObjectStorageError?) -> Void){
		logger.info("Updating metadata :: \(metadata)")

		guard self.projectUrl != nil else{
			logger.error(String(describing: ObjectStorageError.NotConnected))
			return completionHandler(ObjectStorageError.NotConnected)
		}

		let headers = Utils.createHeaderDictionary(authToken: authTokenManager?.authToken, additionalHeaders: metadata)

		httpClient.post(url: self.projectUrl!, headers: headers, data: nil) { error, status, headers, data in
			if let error = error {
				completionHandler(ObjectStorageError.from(httpError: error))
			} else {
				self.logger.info("Metadata updated :: \(metadata)")
				completionHandler(nil)
			}
		}

	}

	/**
	Retrieve account metadata. The metadata will be returned to a completionHandler as a Dictionary<String, String> instance with set of keys and values

	- Parameter completionHandler: Closure to be executed once metadata is retrieved.
	*/
	public func retrieveMetadata(completionHandler: @escaping (_ error: ObjectStorageError?, _ metadata: [String:String]?) -> Void) {
		logger.info("Retrieving metadata")

		guard self.projectUrl != nil else{
			logger.error(String(describing: ObjectStorageError.NotConnected))
			return completionHandler(ObjectStorageError.NotConnected, nil)
		}
		let headers = Utils.createHeaderDictionary(authToken: authTokenManager?.authToken)
		httpClient.head(url: self.projectUrl!, headers: headers) { error, status, headers, data in
			if let error = error {
				completionHandler(ObjectStorageError.from(httpError: error), nil)
			} else {
				self.logger.info("Metadata retrieved :: \(headers)")
				completionHandler(nil, headers);
			}
		}
	}
}
