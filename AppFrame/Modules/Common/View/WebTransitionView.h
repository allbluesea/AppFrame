//
//  WebTransitionView.h
//  BTZC
//
//  Created by apple on 2018/9/12.
//  Copyright © 2018年 Ergu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebTransitionView : UIView

@property (nonatomic, strong) UILabel *textLabel;

- (void)display:(BOOL)display;

@end
