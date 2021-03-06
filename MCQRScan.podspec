#
#  Be sure to run `pod spec lint MCQRScan.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "MCQRScan"
  s.version      = "0.1.5"
  s.summary      = "一个轻量级的二维码扫描识别工具类，已解耦合，容易自定义自己的UI"
  s.description  = "一个轻量级的二维码扫描识别工具类，已解耦合，容易自定义自己的UI"

  s.homepage     = "https://github.com/hwzss/MCQRScan"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.platform     = :ios, "8.0"
  s.author       = { "maodou" => "maodou@ecook.cn" }
  s.source       = { :git => "https://github.com/hwzss/MCQRScan.git",:tag => s.version.to_s, :submodules => true }
  
  s.default_subspecs = 'MCQRScanCore', 'MCQRScanCustomUI'

  s.subspec 'MCQRScanCore' do |sp|
    sp.source_files = "MCQRScan", "MCQRScan/Core/**/*.{h,m}"    
  end

  s.subspec 'MCQRScanCustomUI' do |sp|
    sp.platform     = :ios, "8.0"
    sp.source_files = "MCQRScan/CustomUI/**/*.{h,m}"
    sp.resources    = "Resources/*.png"
    sp.dependency "MCQRScan/MCQRScanCore"
  end

end
