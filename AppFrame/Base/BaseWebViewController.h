//
//  BaseWebViewController.h
//  AppFrame
//
//  Created by icebrk on 2018/8/20.
//  Copyright © 2018年 Firebrk. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>

FOUNDATION_EXTERN NSString * const JS_SHOW_VC;///< 跳转页面

@interface BaseWebViewController : BaseViewController <WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *web;
@property (nonatomic, copy) NSString *URL;
@property (nonatomic, copy) NSString *HTMLString;
@property (nonatomic, strong) NSMutableArray *defaultJSMessageNames;///< JS方法
@property (nonatomic, strong) UIProgressView *progress;///< 进度条


- (void)loadRequestWithURL:(NSString *)str;
- (void)loadRequestWithHTMLStr:(NSString *)str;
/// 清除缓存
- (void)clearWebCache;
/// 隐藏导航栏时的布局
- (void)layoutWithoutNavigationBar;
/// MessageHandler处理默认JS方法 供子类调用
- (void)handleDefaultScriptMessage:(WKScriptMessage *)message otherScriptMessageHandler:(void(^)(void))handler;

@end
