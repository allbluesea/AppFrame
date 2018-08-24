//
//  MBProgressHUD+Extension.m
//  AppFrame
//
//  Created by icebrk on 2018/8/20.
//  Copyright © 2018年 Firebrk. All rights reserved.
//

#import "MBProgressHUD+Extension.h"


@implementation MBProgressHUD (Extension)

+ (void)showMessage:(NSString *)message {
    [self showMessage:message toView:nil];
}

+ (void)showMessage:(NSString *)message toView:(UIView *)view {
    [self showMessage:message toView:view afterDelay:1.f];
}

+ (void)showMessage:(NSString *)message toView:(UIView *)view afterDelay:(NSTimeInterval)delay {
    if (view == nil) view = [UIApplication sharedApplication].delegate.window;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    // 再设置模式
    hud.mode = MBProgressHUDModeText;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:delay];
}

+ (MBProgressHUD *)showLoadingMessage:(NSString *)message {
    return [self showLoadingMessage:message toView:nil];
}

+ (MBProgressHUD *)showLoadingMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].delegate.window;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;
    return hud;
}


+ (void)hideHUD {
    [self hideHUDForView:nil];
}

+ (void)hideHUDForView:(UIView *)view {
    if (view == nil) view = [UIApplication sharedApplication].delegate.window;
    [self hideAllHUDsForView:view animated:YES];
}


@end
