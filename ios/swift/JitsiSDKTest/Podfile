platform :ios, '12.0'

target 'App' do
    pod 'JitsiMeetSDK', '~> 4.1.0'

    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['ENABLE_BITCODE'] = 'NO'
            end
        end
    end
end
