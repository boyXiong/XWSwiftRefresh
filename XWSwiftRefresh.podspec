
Pod::Spec.new do |s|


s.name         = "XWSwiftRefresh"
s.version      = "0.1.8"
s.summary      = "The easiest way to use pull-to-refresh with Swift2.0 program language."


s.homepage     = "https://github.com/boyXiong/XWSwiftRefresh"
s.screenshots  = "https://raw.githubusercontent.com/boyXiong/raw/master/picture/XWSwiftRefresh/displayHowToUser.gif"



s.license      = "MIT"


s.author             = { "boyXiong" => "relv@qq.com" }

s.social_media_url   = "http://blog.csdn.net/boyXiong.com/"


s.platform     = :ios, "8.0"


s.source       = { :git => "https://github.com/boyXiong/XWSwiftRefresh.git", :tag => "0.1.6" }


s.source_files  = "XWSwiftRefresh/**/*.{swift}"

s.resources = "XWSwiftRefresh/Icon/xw_icon.bundle"


s.requires_arc = true

end
