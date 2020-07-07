#
#  Be sure to run `pod spec lint BottomDrawerView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "BottomDrawerView"
  spec.version      = "0.4.2"
  spec.summary      = "A versatile draggable bottom drawer. CocoaPods library written in swift."

  spec.description  = <<-DESC
  A dismissable bottom draggable view, use it for partial messages or options. A draggable UIViewController that sits on top of another UIViewController, giving it more functionality and options.
                   DESC

  spec.homepage     = "https://github.com/LorTos/BottomDrawerView"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = "LorTos"
  spec.platform     = :ios, "11.0"
  spec.swift_versions = ["4.2", "5.0", "5.1", "5.2"]
  
  spec.source       = { :git => "https://github.com/LorTos/BottomDrawerView.git", :tag => "#{spec.version}" }
  spec.source_files  = "Sources/BottomDrawerView/*.swift"
end
