ENV["COCOAPODS_DISABLE_STATS"] = "true"

platform :osx, '10.12'
use_frameworks!

target 'boring-company-chat' do
    pod 'RealmSwift'
		pod 'Moya-ObjectMapper'
		pod 'Moya', :git => "https://github.com/cowboyrushforth/Moya.git", :branch => "error_fix"
		pod 'Moya/RxSwift', :git => "https://github.com/cowboyrushforth/Moya.git", :branch => "error_fix"
		pod 'Moya-ObjectMapper/RxSwift'
		pod 'RxSwift',      '~> 3.0'
		pod 'ObjectMapper', '~> 2.2.5'
    pod 'AlamofireImage', '~> 3.1'
    pod 'Starscream', '~> 2.0.4'
end

post_install do |installer|
		installer.pods_project.targets.each do |target|
				target.build_configurations.each do |config|
						config.build_settings['SWIFT_VERSION'] = '3.0'
				end
		end
end
