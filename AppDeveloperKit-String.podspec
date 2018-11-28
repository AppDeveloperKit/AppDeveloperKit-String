
Pod::Spec.new do |s|

s.name              = 'AppDeveloperKit-String'

s.version           = '1.0.1'
s.summary           = 'String utilities - regular expressions and subscripting'
s.homepage          = 'https://github.com/AppDeveloperKit/AppDeveloperKit-String'

s.author            = { 'Name' => 'Scott Carter' }
s.license           = { :type => 'BSD 3-Clause', :file => 'LICENSE'}

s.swift_version = '4.2'

s.platform          = :ios

s.ios.deployment_target = '11.0'

s.source = { :git => 'https://github.com/AppDeveloperKit/AppDeveloperKit-String.git', :tag => s.version.to_s }


s.subspec 'String' do |string|
string.source_files   = 'Library/String.swift'
end


s.subspec 'Regex' do |regex|
regex.source_files   = 'Library/Regex.swift'

regex.dependency 'AppDeveloperKit-String/String'
end


s.subspec 'Subscript' do |subscript|
subscript.source_files   = 'Library/Subscript.swift'
end


end


