#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint zeking_device_info.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'zeking_device_info'
  s.version          = '0.0.1'
  s.summary          = '获取设备信息'
  s.description      = <<-DESC
A new Flutter plugin.
                       DESC
  s.homepage         = 'https://github.com/LZQL/zeking_device_info'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Zeking' => '396298154@qq.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'SSKeychain'
  s.dependency 'MJExtension'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
end
