//
//  GuideViewController.h
//  AppFrame
//
//  Created by icebrk on 2018/8/20.
//  Copyright © 2018年 Firebrk. All rights reserved.
//

#import "BaseViewController.h"

@interface GuideViewController : BaseViewController

/** 引导页图片组 */
@property (nonatomic, copy) NSArray<NSString *> *imgGroup;

/**
 隐藏指示器 默认NO
 */
@property (nonatomic, assign) BOOL hidesPageIndicator;

@end
