//
//  WebTransitionView.m
//  BTZC
//
//  Created by apple on 2018/9/12.
//  Copyright © 2018年 Ergu. All rights reserved.
//

#import "WebTransitionView.h"

@interface WebTransitionView ()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation WebTransitionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CALayer *layer = [self triangleReplicatorLayer];
        [self.layer addSublayer:layer];
    }
    return self;
}


- (void)display:(BOOL)display {
    if (display == self.hidden) {
        self.hidden = !display;
        if (display) {
            [self.shapeLayer addAnimation:[self rotationAnimation] forKey:@"rotate"];
            if (self.gradientLayer) [self.gradientLayer addAnimation:[self gradientAnimation] forKey:@"bling"];
        } else {
            [self.shapeLayer removeAnimationForKey:@"rotate"];
            if (self.gradientLayer) [self.gradientLayer removeAnimationForKey:@"bling"];
        }
    }
}

- (CALayer *)triangleReplicatorLayer {
    CGFloat radius = 20.f;
    
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.frame = CGRectMake(0, 0, radius, radius);
    _shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, radius, radius)].CGPath;
    _shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    _shapeLayer.fillColor = [UIColor whiteColor].CGColor;
    _shapeLayer.lineWidth = 1.f;
    [_shapeLayer addAnimation:[self rotationAnimation] forKey:@"rotate"];
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = CGRectMake((self.bounds.size.width - 60) / 2.f, self.bounds.size.height / 4.f, radius, radius);
    replicatorLayer.instanceCount = 3;
    replicatorLayer.instanceDelay = 0;
    replicatorLayer.instanceColor = [UIColor blue].CGColor;
    replicatorLayer.instanceRedOffset = +0.3;
//    replicatorLayer.instanceGreenOffset = +0.5;
    replicatorLayer.instanceBlueOffset = +0.3;
    CATransform3D trans3D = CATransform3DIdentity;
    trans3D = CATransform3DTranslate(trans3D, 60, 0, 0);
    trans3D = CATransform3DRotate(trans3D, 120.0*M_PI/180.0, 0, 0, 1);
    replicatorLayer.instanceTransform = trans3D;
    [replicatorLayer addSublayer:_shapeLayer];
    
    return replicatorLayer;
}

- (CABasicAnimation *)rotationAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D fromValue = CATransform3DScale(CATransform3DIdentity, 0.5, 0.5, 1);
    fromValue = CATransform3DTranslate(fromValue, 0, 0, 0);
    fromValue = CATransform3DRotate(fromValue, 0, 0, 0.0, 0.0);
    animation.fromValue = [NSValue valueWithCATransform3D:fromValue];
    
    CATransform3D toValue = CATransform3DScale(CATransform3DIdentity, 1, 1, 0.5);
    toValue = CATransform3DTranslate(toValue, 60, 0.0, 0.0);
    toValue = CATransform3DRotate(toValue,120.0*M_PI/180.0, 0.0, 0.0, 1.0);
    animation.toValue = [NSValue valueWithCATransform3D:toValue];
    
    animation.autoreverses = YES;
    animation.repeatCount = INFINITY;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 1;
    
//    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
//    animationGroup.animations = @[];
    
    return animation;
}

- (CABasicAnimation *)gradientAnimation {
    // 创建动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"locations"];
    animation.duration = 3.0f;
    animation.toValue = @[@(0.9), @(1.0), @(1.0)];
    animation.removedOnCompletion = NO;
    animation.repeatCount = INFINITY;
    animation.fillMode = kCAFillModeForwards;
    
    return animation;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.frame = CGRectMake(12, self.bounds.size.height / 2.f, self.bounds.size.width - 24, 40);
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont boldSystemFontOfSize:28];
        _textLabel.textColor = [UIColor lightGrayColor];
        _textLabel.transform = CGAffineTransformMake(1, 0, tanf(-20 * (CGFloat)M_PI / 180), 1, 0, 0);
        [self addSubview:_textLabel];
        
        // 创建渐变效果的layer
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.textLabel.bounds;
        _gradientLayer.colors = @[(__bridge id)[[UIColor greenColor] colorWithAlphaComponent:0.3].CGColor,
                                 (__bridge id)[UIColor yellowColor].CGColor,
                                 (__bridge id)[[UIColor yellowColor] colorWithAlphaComponent:0.3].CGColor];
        
        _gradientLayer.startPoint = CGPointMake(0, 0.1);//设置渐变方向起点
        _gradientLayer.endPoint = CGPointMake(1, 0);  //设置渐变方向终点
        _gradientLayer.locations = @[@(0.0), @(0.0), @(0.1)]; //colors中各颜色对应的初始渐变点
        [_gradientLayer addAnimation:[self gradientAnimation] forKey:@"bling"];
        
        // 将graLayer设置成textLabel的遮罩
        _textLabel.layer.mask = _gradientLayer;
    }
    return _textLabel;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
