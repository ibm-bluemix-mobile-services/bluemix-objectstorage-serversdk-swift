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
import BluemixSimpleLogger
import SimpleHttpClient

internal class AuthTokenManager {
	private static let TOKEN_ENDPOINT = "https://identity.open.softlayer.com/v3/auth/tokens"
	private static let TOKEN_RESOURCE = HttpResourse(schema: "https", host: "identity.open.softlayer.com", port: "443", path: "/v3/auth/tokens")
	private static let X_SUBJECT_TOKEN = "x-subject-token"
	private let logger = Logger.init(forName: "AuthTokenManager")
	
	var userId: String
	var password: String
	var projectId: String
	var authToken: String?
	
	init(projectId: String, userId: String, password: String){
		self.userId = userId
		self.password = password
		self.projectId = projectId
	}
	
	func refreshAuthToken(completionHandler:(error:ObjectStoreError?) -> Void){
		let headers = ["Content-Type":"application/json"];
		let authRequestData = AuthorizationRequestBody(userId: userId, password: password, projectId: projectId).data()
		
		logger.info("Retrieving authToken from Identity Server")
		HttpClient.post(resource: AuthTokenManager.TOKEN_RESOURCE, headers: headers, data: authRequestData) { error, status, headers, data in
			if let error = error {
				completionHandler(error: ObjectStoreError.from(httpError: error))
			} else {
				self.logger.info("authToken Retrieved")
				self.authToken = headers![AuthTokenManager.X_SUBJECT_TOKEN]
				completionHandler(error: nil)
			}
		}
	}
}