Pod::Spec.new do |s|
  s.name             = "BMSObjectStore"
  s.version          = "0.0.2"
  s.summary          = "Swift SDK for IBM Object Store service on Bluemix"

  s.description      = <<-DESC

  this is where description will be 
  this is where description will be 
  this is where description will be 
  this is where description will be 
  this is where description will be 
  this is where description will be 
  this is where description will be 
  this is where description will be 

                       DESC

  s.homepage         = "https://github.com/ibm-bluemix-mobile-services/bms-clientsdk-swift-objectstore"
  s.license          = 'Apache-2.0'
  s.author           = { "Anton Aleksandrov" => "antona@us.ibm.com" }
  s.source           = { :git => "https://github.com/ibm-bluemix-mobile-services/bms-clientsdk-swift-objectstore.git" }
  
  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'clientsdk_swift_objectstore/**/*'
  s.resource_bundles = {
    #'BMSObjectStore' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'Foundation'
end
