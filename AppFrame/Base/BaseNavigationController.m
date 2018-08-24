//
//  BaseNavigationController.m
//  AppFrame
//
//  Created by icebrk on 2018/8/20.
//  Copyright © 2018年 Firebrk. All rights reserved.
//

#import "BaseNavigationController.h"
#import "BaseViewController.h"

@interface BaseNavigationController () <UINavigationControllerDelegate>

@end

@implementation BaseNavigationController

// 初始化
+ (void)initialize {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.hidesBottomBarWhenPushed = self.viewControllers.count > 0;
    [super pushViewController:viewController animated:YES];
}

// MARK: UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isKindOfClass:NSClassFromString(@"BaseViewController")]) {
        BaseViewController *vc = (BaseViewController *)viewController;
        [navigationController setNavigationBarHidden:vc.isNavBarHidden animated:YES];
    }
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
