//
//  EGTabBarController.m
//  AppFrame
//
//  Created by icebrk on 2018/8/20.
//  Copyright © 2018年 Firebrk. All rights reserved.
//

#import "EGTabBarController.h"
#import "BaseNavigationController.h"

static NSString * const kClass = @"className";
static NSString * const kTitle = @"title";
static NSString * const kImg = @"imgName";
static NSString * const kSelectedImg = @"selectedImgName";

@interface EGTabBarController () <UITabBarControllerDelegate>

@end

@implementation EGTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *itemsArray = @[@{kClass  : @"EGInfoViewController",
                              kTitle  : @"资讯",
                              kImg    : @"tabbar_info_normal",
                              kSelectedImg : @"tabbar_info_selected"},
                            @{kClass  : @"EGExpressViewController",
                              kTitle  : @"快讯",
                              kImg    : @"tabbar_express_normal",
                              kSelectedImg : @"tabbar_express_selected"},
                            @{kClass  : @"EGMarketViewController",
                              kTitle  : @"行情",
                              kImg    : @"tabbar_market_normal",
                              kSelectedImg : @"tabbar_market_selected"},
                            @{kClass  : @"EGMeViewController",
                              kTitle  : @"我的",
                              kImg    : @"tabbar_me_normal",
                              kSelectedImg : @"tabbar_me_selected"}];
    
    NSMutableArray *navs = [NSMutableArray array];
    NSDictionary *normalAttributes = @{NSFontAttributeName: FONT(10),
                                       NSForegroundColorAttributeName: RGB(0xa8a8a8)};
    NSDictionary *selAttributes = @{NSFontAttributeName: FONT(10),
                                    NSForegroundColorAttributeName: [UIColor orange]};

    [[UITabBar appearance] setBackgroundImage:[UIImage imageFromContextWithColor:RGB(0xfafafa)]];
    [[UITabBar appearance] setShadowImage:[UIImage imageFromContextWithColor:[UIColor colorWithHexString:@"#e0e0e0"]]];
    [[UITabBarItem appearance] setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:selAttributes forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -4)];
    
    [itemsArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *vc = [[NSClassFromString(dict[kClass]) alloc] init];
        vc.title = dict[kTitle];
        vc.tabBarItem.image = [UIImage imageNamed:dict[kImg]];
        vc.tabBarItem.selectedImage = [[UIImage imageNamed:dict[kSelectedImg]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        [navs addObject:nav];
    }];
    
    self.viewControllers = [navs copy];
    self.delegate = self;
}

#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
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
