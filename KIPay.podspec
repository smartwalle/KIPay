Pod::Spec.new do |s|
  s.name         = "KIPay"
  s.version      = "0.1"
  s.summary      = "KIPay"
  s.description  = <<-DESC
  					KIPay.
                   DESC

  s.homepage     = "https://github.com/smartwalle/KIPay"
  s.license      = "MIT"
  s.author       = { "SmartWalle" => "smartwalle@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/smartwalle/KIPay.git", :branch => "master", :submodules => true }

  s.requires_arc = true

  s.subspec 'PayPal' do |ss|
 	  ss.source_files = "KIPay/KIPay/KIPayDefine.h", "KIPay/KIPay/KIPayPal/*.{h,m}"
 	  ss.dependency "PayPal-iOS-SDK"
  end

  s.subspec 'AliPay' do |ss|
   	ss.source_files = "KIPay/KIPay/KIPayDefine.h", "KIPay/KIPay/KIAliPay/**/*.{h,m}"
   	ss.frameworks = "SystemConfiguration"
   	ss.resources = "KIPay/KIPay/KIAliPay/External/SDK/AlipaySDK.bundle"
   	ss.vendored_frameworks = 'KIPay/KIPay/KIAliPay/External/SDK/AlipaySDK.framework'
   	ss.public_header_files = "KIPay/KIPay/KIAliPay/External/SDK/AlipaySDK.framework/Headers/**/*.h", "KIPay/KIPay/KIAliPay/**/*.h"
   	ss.dependency "OpenSSL-Universal", "1.0.1.p"
  end
  
end
