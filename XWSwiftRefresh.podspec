Pod::Spec.new do |s|
s.name         = 'XWSwiftRefresh'
s.version      = '0.0.1'
s.summary      = 'The easiest way to use pull-to-refresh with Swift2.0 program language'
s.homepage     = 'https://github.com/boyXiong/XWSwiftRefresh'
s.license      = 'MIT'
s.authors      = {'boyXiong' => 'relv@qq.com'}
s.platform     = :ios, '8.0'
s.source       = {:git => 'https://github.com/boyXiong/XWSwiftRefresh.git', :tag => s.version}
s.source_files = 'XWSwiftRefresh/**/*.{swift}'
s.resource     = 'XWSwiftRefresh/Icon/xw_icon.bundle'
s.requires_arc = true
end