//
//  BaseViewController.h
//  AppFrame
//
//  Created by icebrk on 2018/8/20.
//  Copyright © 2018年 Firebrk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NavigationBarSide) {
    NavigationBarLeftSide, ///< 导航栏左侧
    NavigationBarRightSide, ///< 导航栏右侧
};

#define NAVIGATION_LEFT_ITEM_BASE_TAG 6666
#define NAVIGATION_RIGHT_ITEM_BASE_TAG 7777

@interface BaseViewController : UIViewController

/// 导航栏是否隐藏
@property (nonatomic, assign, getter=isNavBarHidden) BOOL navBarHidden;
/// 导航栏左侧按钮
@property (nonatomic, strong) UIButton *navLeftButton;
/// 导航栏右侧按钮
@property (nonatomic, strong) UIButton *navRightButton;

// 导航栏按钮设置

/// 导航栏左侧按钮点击事件
- (void)navLeftItemClick:(UIButton *)sender;
/// 导航栏右侧按钮点击事件
- (void)navRightItemClick:(UIButton *)sender;
/// 设置导航栏返回键（无文字）
- (void)setNavBackItem;
/// 设置导航栏左侧按钮图片
- (void)setNavLeftItemWithImgName:(NSString *)imgName;
/// 设置导航栏右侧按钮图片
- (void)setNavRightItemWithImgName:(NSString *)imgName;
/// 设置导航栏按钮图片
- (void)setNavItemsWithImgNames:(NSArray *)imgNames
                           side:(NavigationBarSide)side
                         target:(id)target
                         action:(SEL)action;

/// 设置导航栏左侧按钮标题及颜色 默认黑色
- (void)setNavLeftItemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor;
/// 设置导航栏右侧按钮标题及颜色 默认黑色
- (void)setNavRightItemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor;
/// 设置导航栏按钮标题及颜色 默认黑色
- (void)setNavItemWithTitle:(NSString *)title
                 titleColor:(UIColor *)titleColor
                       side:(NavigationBarSide)side
                     target:(id)target
                     action:(SEL)action;

/// 设置导航栏颜色
- (void)setNavigationBarColor:(UIColor *)color;
/// 设置状态栏
- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle;
/// 标题 设置
- (void)setnavigationBarTitleStyleWithFont:(UIFont *)font color:(UIColor *)color;

/// 返回
- (void)back;
/// 关闭
- (void)dismiss;
/// 显示hud消息
- (void)showMessage:(NSString *)msg;
/// 跳转登录
- (void)goToLogin;

/// 常用按钮
- (UIButton *)commonButton;

/*
/// 显示分享
- (void)showsShareView;
/// 选中分享平台 需在子类重写
- (void)didSelectPlatformType:(UMSocialPlatformType)type;
/// 分享调用
- (void)shareToPlatform:(UMSocialPlatformType)type messageObject:(UMSocialMessageObject *)messageObject completion:(UMSocialRequestCompletionHandler)completion;
 */


@end
