platform :ios,'10.0'
def pods
    pod 'UMengAnalytics-NO-IDFA'
    pod 'RedpacketAliAuthLib','~> 1.1.4'
    pod 'MBProgressHUD', '~> 1.1.0'
    pod 'Hyphenate'
    pod 'AliyunOSSiOS'
    
    #react-native
    pod ‘React’, :path => './react-native/node_modules/react-native', :subspecs => [
    'Core',             #核心库
    'BatchedBridge',    #RN版本高于0.45之后必须导入
    'DevSupport',       # 如果RN版本 >= 0.43，则需要加入此行才能开启开发者菜单
    'ART',
    'RCTActionSheet',
    'RCTAnimation',
    'RCTCameraRoll',
    'RCTGeolocation',
    'RCTImage',
    'RCTNetwork',
    'RCTPushNotification',
    'RCTSettings',
    'RCTText',
    'RCTVibration',
    'RCTWebSocket',
    'RCTLinkingIOS'
    ]
    pod 'yoga', :path => './react-native/node_modules/react-native/ReactCommon/yoga'
end
target 'ShanChain' do
	pods
end
