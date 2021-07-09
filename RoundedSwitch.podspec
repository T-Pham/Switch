Pod::Spec.new do |s|
s.name             = 'RoundedSwitch'
s.version          = '3.0.0'
s.summary          = 'An iOS switch control implemented in Swift with full Interface Builder support.'
s.description      = <<-DESC
RoundedSwitch is an iOS switch control implemented in Swift with full Interface Builder support.
DESC
s.homepage         = 'https://github.com/T-Pham/Switch'
s.screenshots      = 'https://github.com/T-Pham/Switch/blob/master/switch.png?raw=true', 'https://github.com/T-Pham/Switch/blob/master/switch.gif?raw=true'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Thanh Pham' => 'minhthanh@me.com' }
s.source           = { :git => 'https://github.com/T-Pham/Switch.git', :tag => s.version.to_s }
s.ios.deployment_target = '8.0'
s.source_files = 'Sources/Switch/Switch.swift'
s.frameworks = 'UIKit'
s.swift_versions = '5.0'
end
