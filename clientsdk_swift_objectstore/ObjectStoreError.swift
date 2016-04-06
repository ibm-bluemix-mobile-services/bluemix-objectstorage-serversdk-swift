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

///	Used to indicate various failure types that might occur during BMSObjectStore operations
public enum ObjectStoreError: ErrorType {
	
	/**
		Indicates a failure during connection attempt. Since response and data is not available in this case an error message might be provided
	
		- Parameter message: An optional description of failure reason
	*/
	case ConnectionFailure(message:String?)
	
	/// Indicates a resource not being available on server. Returned in case of HTTP 404 status
	case NotFound
	
	/// Indicates a missing authorization or authentication failure. Returned in case of HTTP 401 status
	case Unauthorized

	/// Indicates an error reported by server. Retruned in cases of HTTP 4xx and 5xx statuses which are not handled separately
	case ServerError
	
}
