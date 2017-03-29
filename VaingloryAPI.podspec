Pod::Spec.new do |s|
  s.name         = "VaingloryAPI"
  s.version      = "0.1.0"
  s.summary      = "Api client for Vainglory game"

  s.description  = <<-DESC
In 2017 Vainglory  game launched its first API in order to provide community a way to share stats of game.
This API is a swift implementation to obtain its data.
                   DESC

  s.homepage      = "https://github.com/salavert/vainglory-api"
  s.license       = { :type => 'MIT', :file => 'LICENSE' }
  s.author        = { "Jose Salavert" => "salavert@gmail.com" }
  s.platform      = :ios, "10.0"
  s.source        = { :git => "https://github.com/salavert/vainglory-api.git", :tag => s.version.to_s }
  s.source_files  = "VaingloryAPI/**/*.{h,m,swift}"
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }
  s.ios.deployment_target = "10.0"
  
  s.dependency "Alamofire", "~> 4.4"
  s.dependency "Treasure"
end
