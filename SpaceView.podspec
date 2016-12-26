#
# Be sure to run `pod lib lint SpaceView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SpaceView'
  s.version          = '1.0.0'
  s.summary          = 'Swift library, for showing awesome messages!'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Library to display the amazing messages to alert the user. You can easily recall them. Incredibly simple and easy to change to suit your requirements.
                       DESC

  s.homepage         = 'https://github.com/Xopoko/SpaceView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Horoko' => 'alonsik1@gmail.com' }
  s.source           = { :git => 'https://github.com/Xopoko/SpaceView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SpaceView/Classes/*'
  
  # s.resource_bundles = {
  #   'SpaceView' => ['SpaceView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
