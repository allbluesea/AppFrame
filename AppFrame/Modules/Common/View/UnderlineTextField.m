//
//  UnderLineTextField.m
//  TIY
//
//  Created by bxd on 16/6/1.
//  Copyright © 2016年 test. All rights reserved.
//

#import "UnderlineTextField.h"

@implementation UnderlineTextField


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _underlineColor = [[UIColor grayColor] colorWithAlphaComponent:0.8f];
    }
    
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, self.underlineColor.CGColor);
    CGContextSetLineWidth(ctx, 0.5f);
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds) - 0.5f);
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds) - 0.5f);
    CGContextClosePath(ctx);
    CGContextStrokePath(ctx);
}


@end
