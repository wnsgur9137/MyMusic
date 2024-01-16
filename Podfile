#Uncomment the next line to define a global platform for your project
platform :ios, '16.0'

def rxswift_pods
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxGesture'
  pod 'Moya/RxSwift'
  pod 'NSObject+Rx'
end

def rxtest_pods
  pod 'RxBlocking'
  pod 'RxTest'
end

def ui_pods
  pod 'FlexLayout'
  pod 'PinLayout'
  pod 'SkeletonView'
end

def image_pods
  pod 'Kingfisher'
end

def shared_pods
  rxswift_pods
  ui_pods
  image_pods
end

target 'MyMusic' do
  use_frameworks!

  shared_pods

  target 'MyMusicTests' do
    inherit! :search_paths
	shared_pods
	rxtest_pods
  end

end
