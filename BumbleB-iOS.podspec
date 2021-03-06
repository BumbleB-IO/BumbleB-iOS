#
# Be sure to run `pod lib lint BumbleB-iOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "BumbleB-iOS"
  s.version          = "0.1.5"
  s.summary          = "convenient access to the BumbleB API for objective-c developers"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = "BumbleB-iOS provides convenient access to the BumbleB API for objective-c developers. The interface converts Soundy API responses into NSObjects"

  s.homepage         = "https://github.com/BumbleB-IO/BumbleB-iOS"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Ram Greenberg" => "ramgreenberg@hotmail.com" }
  s.source           = { :git => "https://github.com/BumbleB-IO/BumbleB-iOS.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'BumbleB-iOS' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AFNetworking', '~> 2.6'
end
