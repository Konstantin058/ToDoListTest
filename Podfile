# platform :ios, '17.5'

target 'ToDoListTest' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

pod 'FirebaseCore'
 pod 'FirebaseAuth'
 pod 'FirebaseFirestore'
 pod 'FirebaseStorage'
pod 'ReachabilitySwift'

  # Pods for ToDoListTest

end

post_install do |installer|
     installer.generated_projects.each do |project|
         project.targets.each do |target|
                target.build_configurations.each do |config|
                    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
                  end
              end
          end
      end