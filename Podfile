# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

use_frameworks!

def app_pods
  pod 'Alamofire', '~> 5.0.0-rc.2'
  pod 'AlamofireNetworkActivityLogger', '~> 3.0'
  pod 'ActionSheetPicker-3.0', '~> 2.3.0'
  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
  pod 'SVProgressHUD', '~> 2.2.0'
end

target 'PocketGDP' do
  
  # Pods for PocketGDP
  app_pods

  target 'PocketGDPTests' do
    pod 'OHHTTPStubs/Swift', '8.0.0'
    pod 'Quick', '~> 2.1.0'
    pod 'Nimble', '~> 8.0.1'
  end

  target 'PocketGDPUITests' do
    # Pods for testing
  end

end
