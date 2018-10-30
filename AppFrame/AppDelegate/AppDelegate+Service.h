//
//  AppDelegate+Service.h
//  AppFrame
//
//  Created by icebrk on 2018/8/20.
//  Copyright © 2018年 Firebrk. All rights reserved.
//

#import "AppDelegate.h"


static inline AppDelegate *SeekAppDelegate(void) {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@interface AppDelegate (Service)

- (void)configUI; ///< 配置UI
- (void)configUserInfo; ///< 配置用户信息
- (void)configShareInfo; ///< 配置分享平台
- (void)configPushInfoWithOption:(NSDictionary *)options; ///< 配置推送平台
- (void)config3DTouch; ///< 配置3DTouch

- (void)goToLogin; ///< 跳转登录页
- (void)goToMain; ///< 跳转主页
- (void)goToGuide; ///< 跳转引导页
- (void)showAD; ///< 显示广告页

- (void)monitorNetworkStatus; ///< 监控网络状态


@end


