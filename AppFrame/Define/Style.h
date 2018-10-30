//
//  Style.h
//  AppFrame
//
//  Created by icebrk on 2018/8/20.
//  Copyright © 2018年 Firebrk. All rights reserved.
//

#ifndef Style_h
#define Style_h


// MARK: ----- Size -----

#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height // 屏幕高度
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width // 屏幕宽度
#define STATUS_BAR_HEIGHT (IPHONE_X ? 44.f : 20.f) // 状态栏高度
#define NAVBAR_HEIGHT 44.f // 导航栏高度
#define NAV_STATUS_HEIGHT (STATUS_BAR_HEIGHT + NAVBAR_HEIGHT) // 导航总高度
#define MARGIN 15.f // 边距
#define TABBAR_HEIGHT (IPHONE_X ? 83.f : 49.f)//tabbar的高
#define TABBAR_BOTTOM_INSET (IPHONE_X ? (TABBAR_HEIGHT - 49.f) : 0.f)//tabbar底部间隙（iPhoneX以上机型适用）
#define WHITESPACE_HEIGHT 10.f // 空白间距
#define NAVBAR_BTN_LENGTH 24.f // 导航按钮宽高
#define SEPARATOR_INSET UIEdgeInsetsMake(0, MARGIN, 0, MARGIN) // 分割线边距

// MARK: ----- Font -----

#define FONT(s) [UIFont systemFontOfSize:(s)] // 字体

// MARK: ----- Color -----

// 主题颜色
#define THEME_COLOR [UIColor colorWithHexString:@"#2692ff"]
// 导航颜色
#define NAV_COLOR [UIColor colorWithHexString:@"#ffffff"]
// 标题颜色
#define TITLE_COLOR [UIColor colorWithHexString:@"#353535"]
// Cell分割线颜色
#define SEPARATOR_COLOR [UIColor colorWithHexString:@"#e5e5e5"]
// 边缘线颜色
#define LINE_COLOR [UIColor colorWithHexString:@"#e0e0e0"]
// 页面背景颜色
#define BG_COLOR [UIColor colorWithHexString:@"#f0f0f0"]
// 消息提示颜色
#define MSG_COLOR [UIColor colorWithHexString:@"#ff3131"]
// 占位颜色
#define PLACEHOLDER_COLOR [UIColor colorWithHexString:@"#bfbfbf"]

// MARK: ----- Device -----

#define IPHONE_X [UIDevice isIPhoneXOrLater] // 是否为iPhone X

#endif /* Style_h */
