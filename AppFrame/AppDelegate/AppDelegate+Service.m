//
//  AppDelegate+Service.m
//  AppFrame
//
//  Created by icebrk on 2018/8/20.
//  Copyright © 2018年 Firebrk. All rights reserved.
//

#import "AppDelegate+Service.h"
#import "EGLoginViewController.h"
#import "GuideViewController.h"
#import "ADPageView.h"
#import "BaseWebViewController.h"

@implementation AppDelegate (Service)


- (void)configUI {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
}

- (void)configShareInfo {
    
}

- (void)configPushInfoWithOption:(NSDictionary *)options {
    
}

- (void)config3DTouch {
    if (@available(iOS 9.0, *)) {
        if (self.window.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
            NSArray *arr = @[
                             @{@"iconName": @"common_touch_door", @"type": @"type1", @"title": @"自助开门"},
                             @{@"iconName": @"common_touch_visitor", @"type": @"type2", @"title": @"访客预约"}];
            NSMutableArray *items = [NSMutableArray arrayWithCapacity:arr.count];
            for (int i = 0; i < arr.count; i++) {
                UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithTemplateImageName:[arr[i] objectForKey:@"iconName"]];
                UIApplicationShortcutItem *item = [[UIApplicationShortcutItem alloc] initWithType:[arr[i] objectForKey:@"type"] localizedTitle:[arr[i] objectForKey:@"title"] localizedSubtitle:nil icon:icon userInfo:nil];
                [items addObject:item];
            }
            
            [[UIApplication sharedApplication] setShortcutItems:[items copy]];
        }
    }
    
}

// MARK: GOTO

- (void)goToLogin {
    self.window.rootViewController = [EGLoginViewController new];
}

- (void)goToMain {
    self.tabBarController = [EGTabBarController new];
    self.window.rootViewController = self.tabBarController;
}

- (void)goToGuide {
    GuideViewController *vc = [GuideViewController new];
    vc.imgGroup = nil;
    self.window.rootViewController = vc;
}

- (void)showAD {
    ADPageView *adView = [[ADPageView alloc] initWithFrame:self.window.bounds eventHandler:^{
        // TODO: 广告详情
        BaseWebViewController *vc = [BaseWebViewController new];
        vc.URL = @"http://www.baidu.com";
        [self.tabBarController.selectedViewController pushViewController:vc animated:YES];
    }];
    [adView show];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0

// MARK: 3DTouch

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    UIViewController *rootVC = self.window.rootViewController;
    if ([rootVC isKindOfClass:[EGTabBarController class]]) {
        UINavigationController *nav = (UINavigationController *)self.tabBarController.selectedViewController;
        if ([shortcutItem.type isEqualToString:@"type1"]) {
            UIViewController *vc = [NSClassFromString(@"xxx") new];
            [vc setValue:@0 forKey:@"type"];
            vc.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:vc animated:YES];
        } else if ([shortcutItem.type isEqualToString:@"type2"]) {
            UIViewController *vc = [NSClassFromString(@"xxx") new];
            vc.hidesBottomBarWhenPushed = YES;
            [nav pushViewController:vc animated:YES];
        }
    }
}
#endif


- (void)monitorNetworkStatus {
    [NetworkManager monitorNetworkStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                UILabel *label = [UILabel new];
                label.frame = CGRectMake(0, -NAV_STATUS_HEIGHT, SCREEN_WIDTH, NAV_STATUS_HEIGHT);
                label.font = [UIFont systemFontOfSize:15];
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor whiteColor];
                label.text = @"网络连接已断开";
                label.backgroundColor = [UIColor colorWithRed:0.033 green:0.685 blue:0.978 alpha:0.8];
                [self.window addSubview:label];
                
                [UIView animateWithDuration:0.3 animations:^{
                    CGRect frame = label.frame;
                    frame.origin.y = 0;
                    label.frame = frame;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.2 delay:1.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        CGRect frame = label.frame;
                        frame.origin.y = -NAV_STATUS_HEIGHT;
                        label.frame = frame;
                    } completion:^(BOOL finished) {
                        [label removeFromSuperview];
                    }];
                }];
            }
                NSLog(@"网络连接已断开");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"2G/3G/4G");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                break;
            default:
                break;
        }
    }];
}








@end
