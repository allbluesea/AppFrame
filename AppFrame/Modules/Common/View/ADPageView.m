//
//  ADPageView.m
//  AppFrame
//
//  Created by icebrk on 2018/8/20.
//  Copyright © 2018年 Firebrk. All rights reserved.
//

#import "ADPageView.h"

static NSInteger const ShowTime = 5; ///< 倒计时
static NSString * const ADImgName = @"adimg";

@interface ADPageView ()

@property (nonatomic, strong) UIImageView *adView;
@property (nonatomic, strong) UIButton *skipBtn;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, copy) EventHandler handler;

@end

@implementation ADPageView

- (instancetype)initWithFrame:(CGRect)frame eventHandler:(EventHandler)handler {
    if (self = [super initWithFrame:frame]) {
        // 广告图片
        _adView = [[UIImageView alloc] initWithFrame:frame];
        _adView.userInteractionEnabled = YES;
        _adView.contentMode = UIViewContentModeScaleAspectFill;
        _adView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToADDetail)];
        [_adView addGestureRecognizer:tap];
        [self addSubview:_adView];
        
        // 跳过按钮
        _skipBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60 - 12, NAV_STATUS_HEIGHT, 60, 30)];
        _skipBtn.backgroundColor = [UIColor colorWithRed:38 /255.0 green:38 /255.0 blue:38 /255.0 alpha:0.6];
        [_skipBtn setTitle:[NSString stringWithFormat:@"跳过%ld", ShowTime] forState:UIControlStateNormal];
        _skipBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_skipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _skipBtn.layer.cornerRadius = 4;
        _skipBtn.layer.masksToBounds = YES;
        [_skipBtn addTarget:self action:@selector(skipAD) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_skipBtn];
        
        if ([self existsADFile]) {
            _adView.image = [UIImage imageWithContentsOfFile:[self getADFilePath]];
            _handler = handler;
        }
        
        
    }
    
    return self;
}



// MARK: Public

- (void)show {
    if ([self existsADFile]) {
        [[UIApplication sharedApplication].delegate.window addSubview:self];
        [self startTimer];
    }
    [self requestLastestADImg];
}



// MARK: Action

- (void)goToADDetail {
    [self clearTimer];
    [self removeFromSuperview];
    !self.handler ?: self.handler();
}

- (void)skipAD {
    [self disappear];
}

// MARK: Private

- (void)startTimer {
    _count = ShowTime;
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)countDown {
    _count--;
    if (_count <= 0) {
        [self disappear];
        return;
    }
    [_skipBtn setTitle:[NSString stringWithFormat:@"跳过%ld", _count] forState:UIControlStateNormal];
    
}

- (void)clearTimer {
    [_timer invalidate];
    _timer = nil;
    _count = ShowTime;
}

- (void)disappear {
    [self clearTimer];
    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0;
        [self setTransform:CGAffineTransformMakeScale(1.8, 1.8)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (NSString *)getADFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *cachesPath = paths.firstObject;
    NSString *adDirectory = [cachesPath stringByAppendingPathComponent:@"AD"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:adDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:adDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *filePath = [[adDirectory stringByAppendingPathComponent:ADImgName] stringByAppendingPathExtension:@"jpg"];
    return filePath;
}

- (BOOL)existsADFile {
    return [[NSFileManager defaultManager] fileExistsAtPath:[self getADFilePath]];
}

- (void)requestLastestADImg {
    // TODO: 下载最新广告
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://imgsrc.baidu.com/forum/pic/item/9213b07eca80653846dc8fab97dda144ad348257.jpg"]];
    UIImage *image = [UIImage imageWithData:data];
    [UIImageJPEGRepresentation(image, 1) writeToFile:[self getADFilePath] atomically:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
