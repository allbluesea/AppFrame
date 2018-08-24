//
//  EGRegisterViewController.m
//  AppFrame
//
//  Created by icebrk on 2018/8/20.
//  Copyright © 2018年 Firebrk. All rights reserved.
//

#import "EGRegisterViewController.h"

static NSInteger const VCodeTime = 60;

@interface EGRegisterViewController ()

@property (nonatomic, strong) UIButton *codeBtn;// 验证码
@property (nonatomic, strong) NSTimer *timer;// 定时器
@property (nonatomic, assign) NSInteger count;// 倒计时
@property (nonatomic, assign) BOOL canGetVcode;//是否可以获取验证码

@end

@implementation EGRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _canGetVcode = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self resetState];
}

// MARK: Private

- (void)startTimer {
    _count = VCodeTime;
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)countDown {
    _count--;
    if (_count <= 0) [self resetState];
    [self.codeBtn setTitle:[NSString stringWithFormat:@"跳过%ld", _count] forState:UIControlStateNormal];
}

- (void)clearTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    _count = VCodeTime;
}

- (void)resetState {
    _canGetVcode = YES;
    [self clearTimer];
    [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
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
