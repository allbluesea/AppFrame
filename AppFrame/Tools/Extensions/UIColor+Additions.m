
# import "UIColor+Additions.h"

@implementation UIColor (Additions)

const float FLOAT_1_255 = 1.f / 255;

# define RGB2FLOAT(val) ((val) * FLOAT_1_255)
# define FLOAT2RGB(val) ((val) * 255)

# define ARGB_ALPHA(val) (((val) & 0xff000000) >> 24)
# define RGB_RED(val) (((val) & 0xff0000) >> 16)
# define RGB_GREEN(val) (((val) & 0xff00) >> 8)
# define RGB_BLUE(val) ((val) & 0xff)


+ (UIColor*)black05 {
    return [UIColor colorWithRGB:0x050505];
}

+ (UIColor*)black33 {
    return [UIColor colorWithRGB:0x333333];
}

+ (UIColor*)black66 {
    return [UIColor colorWithRGB:0x666666];
}

+ (UIColor *)black99 {
    return [UIColor colorWithRGB:0x999999];
}

+ (UIColor*)blackE5{
    return [UIColor colorWithRGB:0xe5e5e5];
}


+ (UIColor*)blue {
    return [UIColor colorWithRGB:0x2692ff];
}

+ (UIColor*)red {
    return [UIColor colorWithRGB:0xeff3543];
}

+ (UIColor*)orange {
    return [UIColor colorWithRGB:0xf8b140];
}
+ (UIColor*)pink {
    return [UIColor colorWithRGB:0xfd9095];
}

+ (UIColor*)green {
    return [UIColor colorWithRedi:92 green:187 blue:25];
}


+ (UIColor*)colorWithRGB:(int)rgb {
    return [UIColor colorWithRed:RGB2FLOAT(RGB_RED(rgb)) green:RGB2FLOAT(RGB_GREEN(rgb)) blue:RGB2FLOAT(RGB_BLUE(rgb)) alpha:1];
}

+ (UIColor*)colorWithRedi:(Byte)red green:(Byte)green blue:(Byte)blue alpha:(Byte)alpha {
    return [UIColor colorWithRed:RGB2FLOAT(red) green:RGB2FLOAT(green) blue:RGB2FLOAT(blue) alpha:RGB2FLOAT(alpha)];
}

+ (UIColor*)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

+ (UIColor*)colorWithRedi:(Byte)red green:(Byte)green blue:(Byte)blue {
    return [self colorWithRedi:red green:green blue:blue alpha:255];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    NSInteger location = [hexString rangeOfString:@"#"].length;
    location = location >0?([hexString rangeOfString:@"#"].location+1):0;
    [scanner setScanLocation:location];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRGB:rgbValue];
}
+ (UIColor *)colorWithHexAString:(NSString *)hexColor{
    unsigned int alpha, red, green, blue;
    NSRange range;
    range.length =2;
    if (hexColor.length == 9) {//8位十六进制
        range.location =1;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&alpha];//透明度
        range.location =3;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
        range.location =5;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
        range.location =7;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
        return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green/255.0f)blue:(float)(blue/255.0f)alpha:(float)(alpha/255.0f)];
    } else {
        range.location =1;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
        range.location =3;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
        range.location =5;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
        return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green/255.0f)blue:(float)(blue/255.0f)];
    }
}

+ (UIColor*)randomColor {
    CGFloat r = arc4random_uniform(256) / 255.f;
    CGFloat g = arc4random_uniform(256) / 255.f;
    CGFloat b = arc4random_uniform(256) / 255.f;
    
    return [UIColor colorWithRed:r green:g blue:b];
}

+ (UIColor *)gradientColors:(NSArray*)colors
               gradientType:(GradientType)gradientType
                    imgSize:(CGSize)imgSize{
    NSMutableArray *ar = [NSMutableArray array];
    
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    
    UIGraphicsBeginImageContextWithOptions(imgSize, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    
    switch (gradientType) {
        case GradientTypeTopToBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, imgSize.height);
            break;
        case GradientTypeLeftToRight:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imgSize.width, 0.0);
            break;
        case GradientTypeUpleftToLowright:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imgSize.width, imgSize.height);
            break;
        case GradientTypeUprightToLowleft:
            start = CGPointMake(imgSize.width, 0.0);
            end = CGPointMake(0.0, imgSize.height);
            break;
        default:
            break;
    }
    
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    
    return [UIColor colorWithPatternImage:image];

}
@end
