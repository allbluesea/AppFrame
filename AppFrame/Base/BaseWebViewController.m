//
//  BaseWebViewController.m
//  AppFrame
//
//  Created by icebrk on 2018/8/20.
//  Copyright © 2018年 Firebrk. All rights reserved.
//

#import "BaseWebViewController.h"

NSString * const JS_SHOW_VC = @"showController";

@interface BaseWebViewController () 

@end

@implementation BaseWebViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBackItem];
    
    [self configWeb];
    [self configProgress];
    
    if ([self.URL isNotEmpty]) {
        [self loadRequestWithURL:self.URL];
    } else if ([self.HTMLString isNotEmpty]) {
        [self loadRequestWithHTMLStr:self.HTMLString];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addScriptMessages];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeScriptMessages];
}

// MARK: WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    [self handleDefaultScriptMessage:message otherScriptMessageHandler:nil];
}

- (void)handleDefaultScriptMessage:(WKScriptMessage *)message otherScriptMessageHandler:(void(^)(void))handler {
    if ([message.name isEqualToString:JS_SHOW_VC]) {
        NSString *vcClass = message.body;
        if ([vcClass isNotEmpty]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIViewController *vc = [NSClassFromString(vcClass) new];
                [self.navigationController pushViewController:vc animated:YES];
            });
        }
    } else {
        !handler ?: handler();
    }
}

// MARK: WKNavigationDelegate

// 发送请求前是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    [self updateNavigationItems];
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 收到服务器跳转请求
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
}

// 收到响应是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
}


// 开始
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}

// 内容开始返回
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

// 完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSString *title = webView.title;
    self.title = [title isNotEmpty] ? title : NSLocalizedString(@"详情", nil);
    [self updateNavigationItems];
}

// 失败
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"wkweb err occurred: %@", error.localizedDescription);
}

// 失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"wkweb err occurred: %@", error.localizedDescription);
}


// MARK: WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定" , nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:prompt message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor blackColor];
        textField.placeholder = defaultText;
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    
    return webView;
}

// MARK: KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if (object == _web) {
        if ([keyPath isEqualToString:@"estimatedProgress"]) {
            CGFloat newProgress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
            if (newProgress == 1) {
                self.progress.hidden = YES;
                [self.progress setProgress:0 animated:NO];
            } else {
                if (self.progress.hidden) self.progress.hidden = NO;
                [self.progress setProgress:newProgress animated:YES];
            }
        }
    }
}

// MARK: Public

- (void)loadRequestWithURL:(NSString *)str {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:str]];
    [_web loadRequest:request];
}

- (void)loadRequestWithHTMLStr:(NSString *)str {
    NSURL *bundleURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    [_web loadHTMLString:str baseURL:bundleURL];
}

/// 清除缓存
- (void)clearWebCache {
    if (@available(iOS 9.0, *)) {
        NSSet *websiteDataTypes
        
        = [NSSet setWithArray:@[
                                
                                WKWebsiteDataTypeDiskCache,
                                
                                //WKWebsiteDataTypeOfflineWebApplicationCache,
                                
                                WKWebsiteDataTypeMemoryCache,
                                
                                //WKWebsiteDataTypeLocalStorage,
                                
                                //WKWebsiteDataTypeCookies,
                                
                                //WKWebsiteDataTypeSessionStorage,
                                
                                //WKWebsiteDataTypeIndexedDBDatabases,
                                
                                //WKWebsiteDataTypeWebSQLDatabases
                                
                                ]];
        
        //// All kinds of data
        
        //NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        
        //// Date from
        
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        
        //// Execute
        
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
            // Done
            
        }];
    } else {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
        
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        
        NSError *errors;
        
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
    
}

- (void)layoutWithoutNavigationBar {
    self.web.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.progress.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1.f);
}

// MARK: Private

- (void)configWeb {
    // web
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.minimumFontSize = 10.f;
    
    WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
    webConfig.preferences = preferences;
    
    _web = [[WKWebView alloc] initWithFrame:CGRectMake(0, NAV_STATUS_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_STATUS_HEIGHT) configuration:webConfig];
    _web.navigationDelegate = self;
    _web.UIDelegate = self;
    _web.allowsBackForwardNavigationGestures = YES;
    [_web addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    if (@available(iOS 11.0, *)) {
        _web.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addSubview:_web];
}

- (void)configProgress {
    _progress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, NAV_STATUS_HEIGHT, SCREEN_WIDTH, 2.f)];
    _progress.tintColor = [UIColor colorWithRed:0.3f green:0.44f blue:0.82f alpha:0.8f];
    _progress.trackTintColor = [UIColor clearColor];
    [self.view insertSubview:_progress aboveSubview:self.web];
}

- (void)updateNavigationItems {
    if (self.web.canGoBack) {
        [self setNavItemsWithImgNames:@[@"navbar_back_black", @"navbar_close_black"] side:NavigationBarLeftSide target:self action:@selector(navigationItemClick:)];
    } else {
        [self setNavBackItem];
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)addScriptMessages {
    for (NSString *JSName in self.defaultJSMessageNames) {
        [self.web.configuration.userContentController addScriptMessageHandler:self name:JSName];
    }
}

- (void)removeScriptMessages {
    for (NSString *JSName in _defaultJSMessageNames) {
        [self.web.configuration.userContentController removeScriptMessageHandlerForName:JSName];
    }
}

// MARK: Action

- (void)navigationItemClick:(UIButton *)sender {
    NSInteger index = sender.tag - NAVIGATION_LEFT_ITEM_BASE_TAG;
    if (index == 0) {
        [self.web goBack];
    } else if (index == 1) {
        [self back];
    }
    
}

// MARK: Getter

- (NSMutableArray *)defaultJSMessageNames {
    if (!_defaultJSMessageNames) {
        NSArray *arr = @[JS_SHOW_VC];
        _defaultJSMessageNames = [arr mutableCopy];
    }
    
    return _defaultJSMessageNames;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_web removeObserver:self forKeyPath:@"estimatedProgress"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
