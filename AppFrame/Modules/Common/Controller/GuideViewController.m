//
//  GuideViewController.m
//  AppFrame
//
//  Created by icebrk on 2018/8/20.
//  Copyright © 2018年 Firebrk. All rights reserved.
//

#import "GuideViewController.h"

@interface GuideViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scroll.backgroundColor = [UIColor clearColor];
    scroll.pagingEnabled = YES;
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.bounces = NO;
    scroll.delegate = self;
    scroll.contentSize = CGSizeMake(self.imgGroup.count * SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:scroll];
    
    for (int i = 0; i < self.imgGroup.count; i++) {
        UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imgv.image = [UIImage imageNamed:self.imgGroup[i]];
        [scroll addSubview:imgv];
        
        if (i == self.imgGroup.count - 1) {
            UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            startBtn.frame = CGRectMake(i * SCREEN_WIDTH, SCREEN_HEIGHT - 200, SCREEN_WIDTH, 200);
            startBtn.backgroundColor = [UIColor clearColor];
            [startBtn addTarget:self action:@selector(startBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [scroll addSubview:startBtn];
        }
    }
    
    if (!self.hidesPageIndicator) {
        [self.view addSubview:self.pageControl];
    }
    
}

// MARK: UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat index = scrollView.contentOffset.x / SCREEN_WIDTH;
    if (_pageControl) _pageControl.currentPage = index;
}

// MARK: Action

- (void)startBtnClick {
    [SeekAppDelegate() goToLogin];
    [USER_DEFAULTS setBool:YES forKey:INSTALLED];
    [USER_DEFAULTS synchronize];
}

// MARK: Getter

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100) / 2, SCREEN_HEIGHT - 15, 100, 2)];
        _pageControl.numberOfPages = self.imgGroup.count;
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    
    return _pageControl;
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
