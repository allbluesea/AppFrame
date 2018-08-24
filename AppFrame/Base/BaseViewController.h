//
//  BaseViewController.h
//  AppFrame
//
//  Created by icebrk on 2018/8/20.
//  Copyright © 2018年 Firebrk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NavigationBarSide) {
    NavigationBarLeftSide,
    NavigationBarRightSide,
};

#define NAVIGATION_LEFT_ITEM_BASE_TAG 6666
#define NAVIGATION_RIGHT_ITEM_BASE_TAG 7777

@interface BaseViewController : UIViewController

@property (nonatomic, assign, getter=isNavBarHidden) BOOL navBarHidden;

- (void)setNavBackItem;
- (void)setNavLeftItemWithImgName:(NSString *)imgName
                           target:(id)target
                           action:(SEL)action;

- (void)setNavRightItemWithImgName:(NSString *)imgName
                            target:(id)target
                            action:(SEL)action;

- (void)setNavItemsWithImgNames:(NSArray *)imgNames
                           side:(NavigationBarSide)side
                         target:(id)target
                         action:(SEL)action;

- (void)showMessage:(NSString *)msg;
- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle;
- (void)back;

@end
