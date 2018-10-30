//
//  ICERegisterViewController.m
//  AppFrame
//
//  Created by icebrk on 2018/8/20.
//  Copyright © 2018年 Firebrk. All rights reserved.
//

#import "ICERegisterViewController.h"
#import "UnderlineTextField.h"

static NSInteger const VCodeTime = 60;

@interface ICERegisterViewController ()

@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) UnderlineTextField *phoneTF;
@property (nonatomic, strong) UnderlineTextField *codeTF;
@property (nonatomic, strong) UIButton *codeBtn;// 验证码
@property (nonatomic, strong) NSTimer *timer;// 定时器
@property (nonatomic, assign) NSInteger count;// 倒计时
@property (nonatomic, assign) BOOL canGetVcode;//是否可以获取验证码

@end

@implementation ICERegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _scroll = [[UIScrollView alloc] init];
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.bounces = NO;
    [self.view addSubview:_scroll];
    [_scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *container = [UIView new];
    [_scroll addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scroll);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self resetState];
}

// MARK: Action

- (void)codeBtnClick:(UIButton *)sender {
    // 请求验证码
    if (![Util dimCheckPhone:self.phoneTF.text]) {
        return;
    }
    
    sender.userInteractionEnabled = NO;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:self.phoneTF.text forKey:@"mobile"];
    [NetworkManager POSTWithAPIName:@"" parameters:parameters completionBlock:^(NSInteger code, NSString *message, id responseData) {
        [self showMessage:@"验证码已发送"];
        [self startTimer];
    } failureBlock:^(NSInteger code, NSString *errorString) {
        [self showMessage:errorString];
    }];
    
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
    if (_count <= 0) {
        [self resetState];
        return;
    }
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%lds", _count] forState:UIControlStateNormal];
}

- (void)clearTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _count = VCodeTime;
}

- (void)resetState {
    [self clearTimer];
    self.codeBtn.userInteractionEnabled = YES;
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
