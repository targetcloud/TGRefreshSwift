Pod::Spec.new do |s|
s.name         = "TGRefreshSwift"
s.version      = "0.0.6"
s.summary      = "下拉刷新控件，支持刷新前、刷新中、刷新成功、刷新失败时4种状态下的动画效果设置，暴强！"
s.homepage     = "https://github.com/targetcloud/TGRefreshSwift"
s.license      = "MIT"
s.author       = { "targetcloud" => "targetcloud@163.com" }
s.platform     = :ios, "8.0"
s.source       = { :git => "https://github.com/targetcloud/TGRefreshSwift.git", :tag => s.version }
s.source_files  = "TGRefreshSwift/TGRefreshSwift/TGRefreshSwift/**/*.{swift,h,m}"
s.resources     = "TGRefreshSwift/TGRefreshSwift/TGRefreshSwift/TGRefreshSwift.bundle"
s.requires_arc = true
end
