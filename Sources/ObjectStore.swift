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

/// Use ObjectStore instance to connect to IBM Object Store service and manage containers
public class ObjectStore {

//	private static let TOKEN_ENDPOINT = "http://www.cnn.com/asd"
	private static let TOKEN_ENDPOINT = "https://identity.open.softlayer.com/v3/auth/tokens"

	/// Use this value in .connect(...)  methods to connect to Dallas instance of IBM Object Store
	public static let REGION_DALLAS = "https://dal.objectstorage.open.softlayer.com/v1/AUTH_"

	/// Use this value in .connect(...)  methods to connect to London instance of IBM Object Store
	public static let REGION_LONDON = "https://lon.objectstorage.open.softlayer.com/v1/AUTH_"

	internal static let X_SUBJECT_TOKEN = "X-Subject-Token"
	
	private let logger:Logger

	internal var projectId:String! = ""
	internal var projectEndpoint:String! = ""

	/**
	Initialize ObjectStore by supplying projectId and optionally requestManager

	- Parameter projectId: ProjectId provided by the IBM Object Store. Can be obtained via VCAP_SERVICES, service instance keys or IBM Object Store dashboard.
	*/
	public init(projectId:String){
		self.projectId = projectId
		logger = Logger(forName:"ObjectStore [\(self.projectId)]")
	}

	/**
	Connect to the IBM Object Store service using userId and password. Note that username and password are considered sensitive credentials and should only be accessible by trusted applications. If possible avoid exposing your IBM Object Store credentials directly to the mobile app and use authorization token instead.

	- Parameter userId: UserId provided by the IBM Object Store. Can be obtained via VCAP_SERVICES, service instance keys or IBM Object Store dashboard.
	- Parameter password: Password provided by the IBM Object Store. Can be obtained via VCAP_SERVICES, service instance keys or IBM Object Store dashboard.
	- Parameter region: Defines whether BMSObjectStore should connect to Dallas or London instance of IBM Object Store. Use *ObjectStore.REGION_DALLAS* and *ObjectStore.REGION_LONDON* as values
	- Parameter completionHandler: Closure to be executed once connection is established
	*/
	public func connect(userId:String, password:String, region:String, completionHandler: (error:ObjectStoreError?) -> Void){
		let headers = ["Content-Type":"application/json"];
		let authRequestBody = AuthorizationRequestBody(userId: userId, password: password, projectId: projectId)
			logger.info("Connecting to IBM ObjectStore")
		
			HTTPSClient.post(url: ObjectStore.TOKEN_ENDPOINT, headers: headers, data: authRequestBody.data()) { (error, data, status, headers) in
				if let error = error {
					completionHandler(error: ObjectStoreError.fromHttpError(error: error))
				} else {
					self.logger.info("Connected to IBM ObjectStore")
					Utils.authToken = headers![ObjectStore.X_SUBJECT_TOKEN]
					self.projectEndpoint = region + self.projectId
					completionHandler(error: nil)

				}
			}

		// TODO: handle expiration
		// let body = AuthorizationResponseBody(data:data!).json
		// let expirationTimestamp = body["token"]["expires_at"].stringValue

	}
	/**
	Connect to the IBM Object Store service using authorization token. Authorization token allows to connecto to IBM Object Store without exposing user credentials to client application. This is a recommended connection mode.

	- Parameter authToken: The authorization token received from Open Stack identity service. See IBM Object Store documentation to learn how to obtain authorization token
	- Parameter region: Defines whether BMSObjectStore should connect to Dallas or London instance of IBM Object Store. Use *ObjectStore.REGION_DALLAS* and *ObjectStore.REGION_LONDON* as values
	- Parameter completionHandler: Closure to be executed once connection is established
	*/
	public func connect(authToken:String, region:String, completionHandler: (error:ObjectStoreError?) -> Void){
		let headers = Utils.createHeaderDictionaryWithAuthToken()
		let requestUrl = region + projectId
		logger.info("Connecting to IBM ObjectStore")

		HTTPSClient.get(url: requestUrl, headers: headers) { (error, data, status, headers) in
			if let error = error {
				completionHandler(error: ObjectStoreError.fromHttpError(error: error))
			} else {
				self.logger.info("Connected to IBM ObjectStore")
				self.projectEndpoint = region + self.projectId
				completionHandler(error: nil)

			}
		}
	}

	/**
	Create a new container

	- Parameter name: The name of container to be created
	- Parameter completionHandler: Closure to be executed once container is created.
	*/
	public func createContainer(name:String, completionHandler:(error: ObjectStoreError?, container: ObjectStoreContainer?) -> Void){
		logger.info("Creating container [\(name)]")
		let headers = Utils.createHeaderDictionaryWithAuthToken()
		let requestUrl = Utils.generateObjectUrl(baseUrl: projectEndpoint, objectName: name)
		HTTPSClient.put(url: requestUrl, headers: headers) { (error, data, status, headers) in
			if let error = error {
				completionHandler(error: ObjectStoreError.fromHttpError(error: error), container: nil)
			} else {
				// status 201 == create new container
				// status 202 == updated existing container
				self.logger.info("Created container [\(name)]")
				completionHandler(error: nil, container: ObjectStoreContainer(name:name, url: requestUrl, objectStore: self))
			}
		}
	}

	/**
	Retrieve an existing container

	- Parameter name: The name of container to retrieve
	- Parameter completionHandler: Closure to be executed once container is retrieved.
	*/
	public func retrieveContainer(name:String, completionHandler:(error: ObjectStoreError?, container: ObjectStoreContainer?)->Void) {
		logger.info("Retrieving container [\(name)]")
		let headers = Utils.createHeaderDictionaryWithAuthToken()
		let requestUrl = Utils.generateObjectUrl(baseUrl: projectEndpoint, objectName: name)
		HTTPSClient.get(url: requestUrl, headers: headers) { (error, data, status, headers) in
			if let error = error {
				completionHandler(error: ObjectStoreError.fromHttpError(error: error), container: nil)
			} else {
				self.logger.info("Retrieved container [\(name)]")
				completionHandler(error: nil, container: ObjectStoreContainer(name:name, url: requestUrl, objectStore: self))
			}
		}
	}

	/**
	Retrieve a list of existing containers

	- Parameter completionHandler: Closure to be executed once list of containeds is retrieved.
	*/
	public func retrieveContainersList(completionHandler:(error: ObjectStoreError?, containers: [ObjectStoreContainer]?) -> Void){
		logger.info("Retrieving containers list")
		let headers = Utils.createHeaderDictionaryWithAuthToken()
		HTTPSClient.get(url: projectEndpoint, headers: headers) { (error, data, status, headers) in
			if let error = error {
				completionHandler(error: ObjectStoreError.fromHttpError(error: error), containers: nil)
			} else {
				self.logger.info("Retrieved containers list")
				var containersList = [ObjectStoreContainer]()
				let responseData = String(data: data!, encoding: NSUTF8StringEncoding)!
				#if os(Linux)
					let containerNames = responseData.componentsSeparatedByString("\n")
				#else
					let containerNames = responseData.components(separatedBy: "\n")
				#endif
				for containerName:String in containerNames{
					if containerName.characters.count == 0 {
						continue
					}
					let containerUrl = Utils.generateObjectUrl(baseUrl: self.projectEndpoint, objectName: containerName)
					containersList.append(ObjectStoreContainer(name:containerName, url: containerUrl, objectStore: self))
				}
				completionHandler(error: nil, containers: containersList)
			}
		}
	}

	/**
	Delete an existing container

	- Parameter name: The name of container to delete
	- Parameter completionHandler: Closure to be executed once container is deleted.
	*/
	public func deleteContainer(name:String, completionHandler:(error: ObjectStoreError?) -> Void){
		logger.info( "Deleting container [\(name)]")
		let headers = Utils.createHeaderDictionaryWithAuthToken()
		let requestUrl = Utils.generateObjectUrl(baseUrl: projectEndpoint, objectName: name)
		HTTPSClient.delete(url: requestUrl, headers: headers) { (error, data, status, headers) in
			if let error = error {
				completionHandler(error: ObjectStoreError.fromHttpError(error: error))
			} else {
				self.logger.info("Deleted container [\(name)]")
				completionHandler(error: nil)
			}
		}
	}

	/**
	Update account metadata

	- Parameter metadata: a dictionary of metadata items, e.g. ["X-Account-Meta-Subject":"AmericanHistory"]. It is possible to supply multiple metadata items within same invocation. To delete a particular metadata item set it's value to an empty string, e.g. ["X-Account-Meta-Subject":""]. See Object Storage API v1 for more information about possible metadata items - http://developer.openstack.org/api-ref-objectstorage-v1.html
	- Parameter completionHandler: Closure to be executed once metadata is updated.
	*/
	public func updateMetadata(metadata:Dictionary<String, String>, completionHandler:(error:ObjectStoreError?) -> Void){
		logger.info("Updating account metadata :: \(metadata)")
		let headers = Utils.createHeaderDictionaryWithAuthToken(and: metadata)
		HTTPSClient.post(url:projectEndpoint, headers: headers){(error, data, status, headers) in
			if let error = error{
				completionHandler(error: ObjectStoreError.fromHttpError(error: error))
			} else {
				self.logger.info("Account metadata updating")
				completionHandler(error: nil)
			}
		}
	}

	/**
	Retrieve account metadata. The metadata will be returned to a completionHandler as a Dictionary<String, String> instance with set of keys and values

	- Parameter completionHandler: Closure to be executed once metadata is retrieved.
	*/
	public func retrieveMetadata(completionHandler:(error:ObjectStoreError?, metadata: Dictionary<String, String>?) -> Void) {
		logger.info("Retrieving account metadata")
		let headers = Utils.createHeaderDictionaryWithAuthToken()
		HTTPSClient.head(url:projectEndpoint, headers: headers){(error, data, status, headers) in
			if let error = error{
				completionHandler(error: ObjectStoreError.fromHttpError(error: error), metadata: nil)
			} else {
				self.logger.info("Metadata retrieved")
				completionHandler(error: nil, metadata: headers)
			}
		}
	}
}
