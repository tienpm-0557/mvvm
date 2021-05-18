#
# Be sure to run `pod lib lint MVVM.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MVVM'
  s.version          = '1.0.0'
  s.summary          = 'A MVVM library for iOS Swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A MVVM library for iOS Swift, including interfaces for View, ViewModel and Model, DI and Services
                       DESC

  s.homepage         = 'https://github.com/phamminhtien305/mvvm.git'
  # s.screenshots     = '', ''
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'TienPM' => 'phamminhtien305@gmail.com' }
  s.source           = { :git => 'https://github.com/phamminhtien305/mvvm.git', :tag => s.version.to_s }
  s.swift_version    = '5.0'
  # s.social_media_url = 'https://twitter.com/phamminhtien305'

  s.ios.deployment_target = '10.0'

  s.source_files = 'MVVM/Classes/**/*'

  # s.resource_bundles = {
  #   'MVVMBase' => ['MVVM/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'

  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
  s.dependency 'Action'
  s.dependency 'Alamofire'
  s.dependency 'SDWebImage'
  s.dependency 'ObjectMapper'
  s.dependency 'PureLayout'
  s.dependency 'Moya'
  s.dependency 'ReachabilitySwift'
  s.dependency 'MagicalRecord'
  s.dependency 'KeychainAccess'
  s.dependency 'RNCryptor'
  s.dependency 'RxOptional'
  
end
