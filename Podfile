# Uncomment the next line to define a global platform for your project
 platform :ios, '11.2'

def shared_pods
    pod 'SnapKit'
    pod 'Firebase/Core'
    pod 'Firebase/AdMob'
end

target 'CCX Monitor' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for CCX Monitor
  shared_pods
  pod 'EFAutoScrollLabel'
  
  
  target 'CCX MonitorTests' do
    inherit! :search_paths
    # Pods for testing
  end

end

target 'CryptoMarketDataKit' do
    use_frameworks!
    
end

target 'CCX Widget' do
    use_frameworks!
    
    shared_pods
end
