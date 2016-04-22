Pod::Spec.new do |s|
  s.name             = "BluemixObjectStore"
  s.version          = "0.0.24"
  s.summary          = "Swift SDK for IBM Object Store service on Bluemix"
  s.description      = "Swift SDK for IBM Object Store service on Bluemix. The SDK is currently in early development stages and available for iOS, OSX and Linux platforms"
  s.homepage         = "https://github.com/ibm-bluemix-mobile-services/bms-clientsdk-swift-objectstore"
  s.license          = 'Apache License, Version 2.0'
  s.authors          = { "Anton Aleksandrov" => "antona@us.ibm.com" }
  s.source           = { :git => "https://github.com/ibm-bluemix-mobile-services/bms-clientsdk-swift-objectstore.git", :tag => s.version }
  s.source_files 	 = 'Sources/**/*'

  s.ios.deployment_target 	= '8.0'
  s.osx.deployment_target 	= '10.11'

  s.requires_arc = true

end
