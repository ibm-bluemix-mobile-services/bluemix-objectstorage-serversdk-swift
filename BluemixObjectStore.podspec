Pod::Spec.new do |s|
  s.name             = "BluemixObjectStore"
  s.version          = "0.0.21"
  s.summary          = "Swift SDK for IBM Object Store service on Bluemix"
  s.description      = "Swift SDK for IBM Object Store service on Bluemix. The SDK is currently in early development stages and available for iOS, OSX and Linux platforms"
  s.homepage         = "https://github.com/ibm-bluemix-mobile-services/bms-clientsdk-swift-objectstore"
  s.license          = 'Apache License, Version 2.0'
  s.author           = { "Anton Aleksandrov" => "antona@us.ibm.com" }
  s.source           = { :git => "https://github.com/ibm-bluemix-mobile-services/bms-clientsdk-swift-objectstore.git", :tag => "#{s.version}" }

  s.ios.deployment_target 	= '8.0'
  s.osx.deployment_target 	= '10.11'
 
  s.requires_arc = true

  s.source_files = 'Sources/**/*'

  s.resource_bundles = {
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'Foundation'
end
