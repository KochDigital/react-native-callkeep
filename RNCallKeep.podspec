require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name                = "RNCallKeep"
  s.version             = package['version']
  s.summary             = package['description']
  s.homepage            = package['homepage']
  s.license             = package['license']
  s.author              = package['author']
  s.source              = { :git => package['repository']['url'], :tag => "v#{s.version}" }
  s.requires_arc        = true
  s.platform            = :ios, "8.0"
  # s.ios.deployment_target = '15.0'
  s.ios.public_header_files =  'ios/VialerPJSIP.framework/Versions/A/Headers/*.h'
  s.source_files        = "ios/RNCallKeep/*.{h,m}"
  s.dependency 'React'
  
  s.vendored_frameworks = 'ios/VialerPJSIP.framework'
  s.xcconfig = {
    'GCC_PREPROCESSOR_DEFINITIONS' => 'PJ_AUTOCONF=1',
    'USE_HEADERMAP' =>  'NO'    
	}
end

