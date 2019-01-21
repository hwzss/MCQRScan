#
#  Be sure to run `pod spec lint MCQRScan.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "MCQRScan"
  s.version      = "0.0.1"
  s.summary      = "A short description of MCQRScan."
  s.description  = "一个轻量级的二维码扫描识别工具类，已解耦合，容易自定义自己的UI"

  s.homepage     = "https://github.com/hwzss/MCQRScan"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.platform     = :ios, "8.0"
  s.author       = { "maodou" => "maodou@ecook.cn" }
  s.source       = { :git => "https://github.com/hwzss/MCQRScan.git" }

  s.source_files = "MCQRScan", "MCQRScan/Core/**/*.{h,m}"
  s.resources    = "Resources/*.png"

  s.subspec 'CustomUI' do |sp|
    sp.source_files = "MCQRScan/CustomUI/**/*.{h,m}"
    sp.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'ENABLE_CustomUI=1'}
  end

end
