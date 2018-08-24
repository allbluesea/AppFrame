//
//  MBProgressHUD+Extension.h
//  AppFrame
//
//  Created by icebrk on 2018/8/20.
//  Copyright © 2018年 Firebrk. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Extension)

+ (void)showMessage:(NSString *)message;
+ (void)showMessage:(NSString *)message toView:(UIView *)view;
+ (void)showMessage:(NSString *)message toView:(UIView *)view afterDelay:(NSTimeInterval)delay;

+ (MBProgressHUD *)showLoadingMessage:(NSString *)message;
+ (MBProgressHUD *)showLoadingMessage:(NSString *)message toView:(UIView *)view;


+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;

@end
