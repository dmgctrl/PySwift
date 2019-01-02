Pod::Spec.new do |s|
  s.name          = "StyleKit"
  s.version       = "2.1.3"
  s.license       = { :type => "MIT", :file => "LICENSE" }
  s.summary       = "StyleKit is an iOS library that styles native controls with a CSS-like JSON format."
  s.homepage      = "https://github.com/dmgctrl/StyleKit"
  s.author        = "Tonic Design Co."
  s.platform      = :ios, "9.0"
  s.source        = { :git => "https://github.com/dmgctrl/StyleKit.git", :tag => "#{s.version}" }
  s.source_files  = "StyleKit/StyleKit/**/*.swift"
  s.swift_version = "4.2"
end
