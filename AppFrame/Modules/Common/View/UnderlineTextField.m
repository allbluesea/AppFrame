//
//  UnderLineTextField.m
//  TIY
//
//  Created by bxd on 16/6/1.
//  Copyright © 2016年 test. All rights reserved.
//

#import "UnderlineTextField.h"

@interface UnderlineTextField ()

@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UILabel *topPlaceholderLabel;

@end

@implementation UnderlineTextField


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
        self.delegate = self;
    }
    
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, self.tintColor.CGColor);
    CGContextSetLineWidth(ctx, 0.5f);
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds) - 0.5f);
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds) - 0.5f);
    CGContextClosePath(ctx);
    CGContextStrokePath(ctx);
}

- (void)setup {
    _normalTintColor = [[UIColor grayColor] colorWithAlphaComponent:0.8f];
    _highlightedTintColor =THEME_COLOR;
    _tintColor = _normalTintColor;
    _topPlaceholderLabel = [[UILabel alloc] init];
    _topPlaceholderLabel.textColor = _highlightedTintColor;
    _topPlaceholderLabel.font = [UIFont systemFontOfSize:10.f];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.tintColor = self.highlightedTintColor;
    self.topPlaceholderLabel.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame) - 12.f, CGRectGetWidth(self.frame), 12.f);
    self.topPlaceholderLabel.text = self.placeholder;
    self.placeholder = nil;
    [self.superview addSubview:self.topPlaceholderLabel];
    [self setNeedsDisplay];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    self.tintColor = self.normalTintColor;
    self.placeholder = self.topPlaceholderLabel.text;
    [self.topPlaceholderLabel removeFromSuperview];
    [self setNeedsDisplay];
    return YES;
}



@end
