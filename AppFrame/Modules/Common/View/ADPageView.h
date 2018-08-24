//
//  ADPageView.h
//  AppFrame
//
//  Created by icebrk on 2018/8/20.
//  Copyright © 2018年 Firebrk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EventHandler)(void);

@interface ADPageView : UIView

- (instancetype)initWithFrame:(CGRect)frame eventHandler:(EventHandler)handler;

- (void)show;


@end
