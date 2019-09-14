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

internal class AuthTokenManager {
	private static let TOKEN_URL = Url(host: "identity.open.softlayer.com", path: "/v3/auth/tokens")
	private static let X_SUBJECT_TOKEN = "X-Subject-Token"
	private let logger = Logger.init(forName: "AuthTokenManager")
	
	let httpClient: HttpClientProtocol
	var userId: String
	var password: String
	var projectId: String
	var authToken: String?
	
	init(projectId: String, userId: String, password: String, httpClient: HttpClientProtocol){
		self.userId = userId
		self.password = password
		self.projectId = projectId
		self.httpClient = httpClient
	}
	 
	func refreshAuthToken(completionHandler:@escaping (ObjectStorageError?) -> Void){
		let headers = ["Content-Type":"application/json"];
		let authRequestData = AuthorizationRequestBody(userId: userId, password: password, projectId: projectId).data()
		
		logger.info("Retrieving authToken from Identity Server")
		httpClient.post(url: AuthTokenManager.TOKEN_URL, headers: headers, data: authRequestData) { error, status, headers, data in
			if let error = error {
				completionHandler(ObjectStorageError.from(httpError: error))
			} else {
				self.logger.info("authToken Retrieved")
				self.authToken = headers![AuthTokenManager.X_SUBJECT_TOKEN]
				completionHandler(nil)
			}
		}
	}
}
