platform :ios, "7.0"
inhibit_all_warnings!
pod 'MagicalRecord'
pod 'ReactiveCocoa'
pod 'ReactiveViewModel'
pod 'FontAwesome-iOS'
pod "FLEX"

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods/Pods-acknowledgements.plist', 'cling/Settings.bundle/Acknowledgements.plist', :remove_destination => true)
end
