Pod::Spec.new do |spec|

  spec.name         = "KKNetworking"
  spec.version      = "1.0"
  spec.summary      = "A low-level networking framework for iOS"

  spec.homepage     = "https://github.com/keke1201/KKNetworking"
  
  spec.license      = "MIT"
  
  spec.author             = { "lkk" => "keke1201work@gmail.com" }
  spec.platform     = :ios, "9.0"

  spec.source       = { :git => "https://github.com/keke1201/KKNetworking.git", :tag => "#{spec.version}" }
  
  spec.source_files  = "KKNetworking/*.{h,m}"
  
  spec.dependency "AFNetworking", "~> 3.1.0"

end
