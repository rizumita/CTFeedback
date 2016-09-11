Pod::Spec.new do |s|
  s.name         = "CTFeedback"
  s.version      = "1.1.1"
  s.summary      = "Library to send feedback for iOS."
  s.homepage     = "https://github.com/rizumita/CTFeedback"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Ryoichi Izumita" => "r.izumita@caph.jp" }
  s.platform     = :ios, '7.0'
  s.source       = { :git => "https://github.com/rizumita/CTFeedback.git", :tag => "1.1.1" }
  s.source_files  = 'Classes', 'Classes/**/*.{h,m,plist}'
  s.resource_bundles = { 'CTFeedback' => ['Resources/*.lproj', 'Resources/PlatformNames.plist'] }
  s.framework  = 'MessageUI'
  s.requires_arc = true
end
