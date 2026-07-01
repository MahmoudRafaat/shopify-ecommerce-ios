# This tells CocoaPods to hide warnings from all Pods
inhibit_all_warnings!

platform :ios, '18.1'

target 'shopify-ecommerce-ios' do
  use_frameworks!
  pod 'Firebase/Auth', '11.2.0'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '18.1'
      end
    end
  end
end