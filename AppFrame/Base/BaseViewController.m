//
//  BaseViewController.m
//  AppFrame
//
//  Created by icebrk on 2018/8/20.
//  Copyright © 2018年 Firebrk. All rights reserved.
//

#import "BaseViewController.h"


@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    [MobClick beginLogPageView:NSStringFromClass(self.class)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //    [MobClick endLogPageView:NSStringFromClass(self.class)];
}

// MARK: Public

- (void)setNavBackItem {
    //    UIImage *backImg = [[UIImage imageNamed:@"navbar_back_gray"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    [self.navigationController.navigationBar setBackIndicatorImage:backImg];
    //    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:backImg];
    //    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    //    self.navigationItem.backBarButtonItem = backItem;
    
    [self setNavLeftItemWithImgName:@"navbar_back_gray"];
}

- (void)setNavLeftItemWithImgName:(NSString *)imgName {
    [self setNavItemsWithImgNames:@[imgName] side:NavigationBarLeftSide target:self action:@selector(navLeftItemClick:)];
}

- (void)setNavRightItemWithImgName:(NSString *)imgName {
    [self setNavItemsWithImgNames:@[imgName] side:NavigationBarRightSide target:self action:@selector(navRightItemClick:)];
}

- (void)setNavItemsWithImgNames:(NSArray *)imgNames
                           side:(NavigationBarSide)side
                         target:(id)target
                         action:(SEL)action {
    NSMutableArray * items = [[NSMutableArray alloc] initWithCapacity:imgNames.count];
    for (int i = 0; i < imgNames.count; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 24, 24);
        [btn setImage:[UIImage imageNamed:imgNames[i]] forState:UIControlStateNormal];
        if (imgNames.count > 1) {
            btn.tag = (side == NavigationBarLeftSide ? NAVIGATION_LEFT_ITEM_BASE_TAG : NAVIGATION_RIGHT_ITEM_BASE_TAG) + i;
        }
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        if (side == NavigationBarLeftSide) {
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        }else{
            [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
        }
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [items addObject:item];
    }
    
    if (side == NavigationBarLeftSide) {
        self.navigationItem.leftBarButtonItems = items;
    } else {
        self.navigationItem.rightBarButtonItems = items;
    }
}

- (void)setNavLeftItemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor {
    [self setNavItemWithTitle:title titleColor:titleColor side:NavigationBarLeftSide target:self action:@selector(navLeftItemClick:)];
}

- (void)setNavRightItemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor {
    [self setNavItemWithTitle:title titleColor:titleColor side:NavigationBarRightSide target:self action:@selector(navRightItemClick:)];
}

- (void)setNavItemWithTitle:(NSString *)title
                 titleColor:(UIColor *)titleColor
                       side:(NavigationBarSide)side
                     target:(id)target
                     action:(SEL)action  {
    CGFloat btnWidth = [title sizeWithAttributes:@{NSFontAttributeName: FONT(15.f)}].width + 1;
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, btnWidth, 24);
    btn.titleLabel.font = FONT(15);
    if (!titleColor) {
        titleColor = [UIColor blackColor];
    }
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    if (side == NavigationBarLeftSide) {
        [btn setContentEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    }else{
        [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
    }
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    if (side == NavigationBarLeftSide) {
        self.navigationItem.leftBarButtonItem = item;
    } else {
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)navLeftItemClick:(UIButton *)sender {
    [self back];
}

- (void)navRightItemClick:(UIButton *)sender {}

- (void)setNavigationBarColor:(UIColor *)color {
    self.navigationController.navigationBar.barTintColor = color;
}

- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    [[UIApplication sharedApplication] setStatusBarStyle:statusBarStyle];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)showMessage:(NSString *)msg {
    [MBProgressHUD hideHUDForView:self.view];
    [MBProgressHUD showMessage:msg toView:self.view];
}

- (void)back {
    if (self.presentedViewController || self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)goToLogin {
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:[NSClassFromString(@"EGLoginViewController") new]];
    [nav setClearBackground];
    [self presentViewController:nav animated:YES completion:nil];;
}

// 提示
- (void)showAlertMessage:(NSString *)msg {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

// 打开设置
- (void)requestSettingsAuthorization {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"应用尚未授权"
                                                                   message:@"前往设置打开权限"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"授权" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
            [[UIApplication sharedApplication] openURL:settingsURL];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
