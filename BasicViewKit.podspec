#
# Be sure to run `pod lib lint GIViewKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BasicViewKit'
  s.version          = '1.0.0'
  s.summary          = 'A short description of BasicViewKit.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'http://114.242.31.175:8090/wangzhichen/BasicViewKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  # s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Rex' => 'rex_wzc@163.com' }
  s.source           = { :git => 'git@114.242.31.175:wangzhichen/BasicViewKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  
  s.default_subspec = 'Core'
  
  s.subspec 'Core' do |core|
      
      core.source_files = 'BasicViewKit/Core/**/*'
  
     # core.dependency 'GIKit'
      core.dependency 'ReactiveSwift'
      core.dependency 'ReactiveCocoa'

      
  end
  
  
  s.subspec 'Standard' do |stand|
      
      stand.source_files = 'BasicViewKit/Standard/**/*'
      
      stand.dependency 'BasicViewKit/Core'
      
      stand.dependency 'MJRefresh', '~> 3.1.17'
      
      end
  
  # s.resource_bundles = {
  #   'GIViewKit' => ['GIViewKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  
end
