# Be sure to run `pod lib lint SpaceView.podspec' to ensure this is a
# valid spec before submitting.

Pod::Spec.new do |s|
  s.name             = 'SpaceView'
  s.version          = '1.0.5'
  s.summary          = 'Swift library, for showing awesome messages!'
  s.description      = <<-DESC
Library to display the amazing messages to alert the user. You can easily call them. Incredibly simple and easy to change to suit your requirements.
                       DESC
  s.homepage         = 'https://github.com/Xopoko/SpaceView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Horoko' => 'alonsik1@gmail.com' }
  s.source           = { :git => 'https://github.com/Xopoko/SpaceView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'SpaceView/Classes/*'
end
