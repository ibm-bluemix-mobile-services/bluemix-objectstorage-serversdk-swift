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

internal class Utils{
	
	internal static let X_AUTH_TOKEN = "X-Auth-Token"
	
	static func urlPathEncode(text:String) -> String {
		return text.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
	}
	
	static func createHeaderDictionary(authToken:String?, additionalHeaders:[String:String]? = nil) -> [String:String]{
		var headers:Dictionary<String, String> = [:]
		
		if let authToken = authToken {
			headers.updateValue(authToken, forKey: X_AUTH_TOKEN)
		}

		if let additionalHeaders = additionalHeaders {
			for (key, value) in additionalHeaders{
				headers.updateValue(value, forKey: key)
			}
		}

		return headers;
	}
	
}
