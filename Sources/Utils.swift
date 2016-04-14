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
	static func urlPathEncode(text:String) -> String{
		#if swift(>=3)
			return text.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed())!
		#else
			return text.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathAllowedCharacterSet()) as String!
		#endif
	}
	
	static func generateObjectUrl(baseUrl:String, objectName:String) -> String{
		#if swift(>=3)
			return baseUrl + "/" + Utils.urlPathEncode(text: objectName)
		#else
			return baseUrl + "/" + Utils.urlPathEncode(objectName)
		#endif
	}
}

/*
#if swift(>=3)
#else
#endif
*/