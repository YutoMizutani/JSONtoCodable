Pod::Spec.new do |s|
  s.name             = "JSONtoCodable"
  s.version          = "1.2.0"
  s.summary          = "A generating tool from Raw JSON to Codable"

  s.description      = <<-DESC
  A generating tool from Raw JSON to Codable.
                       DESC

  s.homepage         = "https://github.com/YutoMizutani/JSONtoCodable"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Yuto Mizutani" => "yuto.mizutani.dev@gmail.com" }
  s.source           = { :git => "https://github.com/YutoMizutani/JSONtoCodable.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/EXPENSIVE_MAN'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.watchos.deployment_target = '4.0'
  s.tvos.deployment_target = '11.0'

  s.requires_arc = true

  s.source_files = 'Sources/**/*.swift'
end
