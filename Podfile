# Uncomment the next line to define a global platform for your project
# platform :ios, '13.0'
require_relative '/Users/sireesha/Documents/GitHub/RN/node_modules/react-native/scripts/react_native_pods'
require_relative '/Users/sireesha/Documents/GitHub/RN/node_modules/@react-native-community/cli-platform-ios/native_modules'
target 'ShoppingApp' do
  use_frameworks!
  inhibit_all_warnings!

  pod 'SDWebImage', '~> 5.0'
  pod "CreditCardValidator"
  pod 'SwiftMessages', '~> 5.0'
  pod 'MBProgressHUD', '~> 1.2.0'
  pod 'PhoneNumberKit', '~> 3.3'
  
  # Pods for ShoppingApp
  
  
  pod 'React', :path => '/Users/sireesha/Documents/GitHub/RN/node_modules/react-native', :subspecs => [
     
      # Include this for RN >= 0.47
     # Include this to enable In-App Devmenu if RN >= 0.43
     
     
     # Add any other subspecs you want to use in your project
   ]
   
   
   
end

# use_flipper!()

  # post_install do |installer|
  #   react_native_post_install(installer)
  #   __apply_Xcode_12_5_M1_post_install_workaround(installer)
  # end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ARCHS'] = '${ARCHS_STANDARD_64_BIT}'
    end
  end
end
