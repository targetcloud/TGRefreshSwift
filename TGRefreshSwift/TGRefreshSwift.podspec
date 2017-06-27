Pod::Spec.new do |s|
s.name         = "TGRefreshSwift"
s.version      = "0.0.5"
s.summary      = "橡皮筋下拉刷新控件，弹簧下拉刷新控件，QQ效果下拉刷新，同时支持其他样式"
s.homepage     = "https://github.com/targetcloud/TGRefreshSwift"
s.license      = "MIT"
s.author       = { "targetcloud" => "targetcloud@163.com" }
s.platform     = :ios, "8.0"
s.source       = { :git => "https://github.com/targetcloud/TGRefreshSwift.git", :tag => s.version }
s.source_files  = "TGRefreshSwift/TGRefreshSwift/TGRefreshSwift/**/*.{swift,h,m}"
s.resources     = "TGRefreshSwift/TGRefreshSwift/TGRefreshSwift/TGRefreshSwift.bundle"
s.requires_arc = true
end
