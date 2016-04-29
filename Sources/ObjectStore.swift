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
	Retrieve authToken from Identity Server

	- Parameter userId: UserId provided by the IBM Object Store. Can be obtained via VCAP_SERVICES, service instance keys or IBM Object Store dashboard.
	- Parameter password: Password provided by the IBM Object Store. Can be obtained via VCAP_SERVICES, service instance keys or IBM Object Store dashboard.
	- Parameter region: Defines whether ObjectStore should connect to Dallas or London instance of IBM Object Store. Use *ObjectStore.REGION_DALLAS* and *ObjectStore.REGION_LONDON* as values
	*/
	public func retrieveAuthToken(userId:String, password:String, region:String) throws -> String{
		let headers = ["Content-Type":"application/json"];
		let authRequestBody = AuthorizationRequestBody(userId: userId, password: password, projectId: projectId)
		logger.info("Retrieving authToken from Identity Server")
		
		let response = HTTPSClient.post(url: ObjectStore.TOKEN_ENDPOINT, headers: headers, data: authRequestBody.data())
		
		if let error = response.error {
			throw ObjectStoreError.fromHttpError(error: error)
		} else if let authToken = response.allHeaderFields![ObjectStore.X_SUBJECT_TOKEN]{
			self.logger.info("authToken Retrieved")
			return authToken
		} else {
			throw ObjectStoreError.FailedToRetrieveAuthToken
		}
//			Utils.authToken = response.allHeaderFields![ObjectStore.X_SUBJECT_TOKEN]
//			self.projectEndpoint = region + self.projectId
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
	public func connect(authToken:String, region:String) throws{
		let headers = Utils.createHeaderDictionaryWithAuthToken()
		let requestUrl = region + projectId
		logger.info("Connecting to IBM ObjectStore")

		let response = HTTPSClient.get(url: requestUrl, headers: headers)
		if let error = response.error{
			throw ObjectStoreError.fromHttpError(error: error)
		} else {
			self.logger.info("Connected to IBM ObjectStore")
			self.projectEndpoint = region + self.projectId
			Utils.authToken = authToken
		}
	}

	/**
	Create a new container

	- Parameter name: The name of container to be created
	- Parameter completionHandler: Closure to be executed once container is created.
	*/
	public func createContainer(name:String) throws -> ObjectStoreContainer{
		logger.info("Creating container [\(name)]")
		let headers = Utils.createHeaderDictionaryWithAuthToken()
		let requestUrl = Utils.generateObjectUrl(baseUrl: projectEndpoint, objectName: name)
		let response = HTTPSClient.put(url: requestUrl, headers: headers)
		if let error = response.error{
			throw ObjectStoreError.fromHttpError(error: error)
		} else {
			// status 201 == create new container
			// status 202 == updated existing container
			self.logger.info("Created container [\(name)]")
			return ObjectStoreContainer(name:name, url: requestUrl, objectStore: self)
		}
	}

	/**
	Retrieve an existing container

	- Parameter name: The name of container to retrieve
	- Parameter completionHandler: Closure to be executed once container is retrieved.
	*/
	public func retrieveContainer(name:String) throws -> ObjectStoreContainer {
		logger.info("Retrieving container [\(name)]")
		let headers = Utils.createHeaderDictionaryWithAuthToken()
		let requestUrl = Utils.generateObjectUrl(baseUrl: projectEndpoint, objectName: name)
		let response = HTTPSClient.get(url: requestUrl, headers: headers)
		
		if let error = response.error{
			throw ObjectStoreError.fromHttpError(error: error)
		} else {
			// status 201 == create new container
			// status 202 == updated existing container
			self.logger.info("Retrieved container [\(name)]")
			return ObjectStoreContainer(name:name, url: requestUrl, objectStore: self)
		}
	}

	/**
	Retrieve a list of existing containers

	- Parameter completionHandler: Closure to be executed once list of containeds is retrieved.
	*/
	public func retrieveContainersList() throws -> [ObjectStoreContainer]{
		logger.info("Retrieving containers list")
		let headers = Utils.createHeaderDictionaryWithAuthToken()
		let response = HTTPSClient.get(url: projectEndpoint, headers: headers)
		if let error = response.error {
			throw ObjectStoreError.fromHttpError(error: error)
		} else {
			self.logger.info("Retrieved containers list")
			var containersList = [ObjectStoreContainer]()
			#if os(Linux)
				let containerNames = response.bodyAsString!.componentsSeparatedByString("\n")
			#else
				let containerNames = response.bodyAsString!.components(separatedBy: "\n")
			#endif
			for containerName:String in containerNames{
				if containerName.characters.count == 0 {
					continue
				}
				let containerUrl = Utils.generateObjectUrl(baseUrl: self.projectEndpoint, objectName: containerName)
				containersList.append(ObjectStoreContainer(name:containerName, url: containerUrl, objectStore: self))
			}
			return containersList
		}
	}

	/**
	Delete an existing container

	- Parameter name: The name of container to delete
	- Parameter completionHandler: Closure to be executed once container is deleted.
	*/
	public func deleteContainer(name:String) throws {
		logger.info( "Deleting container [\(name)]")
		let headers = Utils.createHeaderDictionaryWithAuthToken()
		let requestUrl = Utils.generateObjectUrl(baseUrl: projectEndpoint, objectName: name)
		let response = HTTPSClient.delete(url: requestUrl, headers: headers)
 
		if let error = response.error{
			throw ObjectStoreError.fromHttpError(error: error)
		} else {
			// status 201 == create new container
			// status 202 == updated existing container
			self.logger.info("Deleted container [\(name)]")
		}
	}

	/**
	Update account metadata

	- Parameter metadata: a dictionary of metadata items, e.g. ["X-Account-Meta-Subject":"AmericanHistory"]. It is possible to supply multiple metadata items within same invocation. To delete a particular metadata item set it's value to an empty string, e.g. ["X-Account-Meta-Subject":""]. See Object Storage API v1 for more information about possible metadata items - http://developer.openstack.org/api-ref-objectstorage-v1.html
	- Parameter completionHandler: Closure to be executed once metadata is updated.
	*/
	public func updateMetadata(metadata:Dictionary<String, String>) throws{
		logger.info("Updating account metadata :: \(metadata)")
		let headers = Utils.createHeaderDictionaryWithAuthToken(and: metadata)
		let response = HTTPSClient.post(url:projectEndpoint, headers: headers)
		
		if let error = response.error{
			throw ObjectStoreError.fromHttpError(error: error)
		} else {
			self.logger.info("Account metadata updated")
		}
	}

	/**
	Retrieve account metadata. The metadata will be returned to a completionHandler as a Dictionary<String, String> instance with set of keys and values

	- Parameter completionHandler: Closure to be executed once metadata is retrieved.
	*/
	public func retrieveMetadata() throws -> Dictionary<String, String> {
		logger.info("Retrieving account metadata")
		let headers = Utils.createHeaderDictionaryWithAuthToken()
		let response = HTTPSClient.head(url:projectEndpoint, headers: headers)
		if let error = response.error{
			throw ObjectStoreError.fromHttpError(error: error)
		} else {
			self.logger.info("Metadata retrieved")
			return headers
		}
	}
}
