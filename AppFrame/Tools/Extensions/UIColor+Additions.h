
typedef NS_ENUM(NSUInteger, GradientType) {// 渐变方向
    GradientTypeTopToBottom      = 0,//从上到下
    GradientTypeLeftToRight      = 1,//从左到右
    GradientTypeUpleftToLowright = 2,//左上到右下
    GradientTypeUprightToLowleft = 3,//右上到左下
};

// RGB颜色
#define RGB(h) [UIColor colorWithRGB:(h)]
#define RGB_SAME(a) RGB3(a, a, a)
#define RGB3(r, g, b) RGB_A(r, g, b, 1)
#define RGB_A(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

// 16进制颜色
#define HEX_COLOR(h) [UIColor colorWithHexString:h]
#define HEX_COLOR_A(h, a) [UIColor colorWithHexString:h alpha:(a)]

@interface UIColor (Additions)

// 黑色
+ (UIColor*)black05;
+ (UIColor*)black33;
+ (UIColor*)black66;
+ (UIColor*)black99;
+ (UIColor*)blackE5;


+ (UIColor*)blue;
+ (UIColor*)red;
+ (UIColor*)orange;
+ (UIColor*)green;
+ (UIColor*)pink;

+ (UIColor*)colorWithRGB:(int)rgb;
+ (UIColor*)colorWithRedi:(Byte)red green:(Byte)green blue:(Byte)blue alpha:(Byte)alpha;
+ (UIColor*)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
+ (UIColor*)colorWithRedi:(Byte)red green:(Byte)green blue:(Byte)blue;
+ (UIColor*)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHexAString:(NSString *)hexColor;

/** 随机颜色 */
+ (UIColor*)randomColor;

/** 渐变色 */
+ (UIColor *)gradientColors:(NSArray*)colors
               gradientType:(GradientType)gradientType
                    imgSize:(CGSize)imgSize;

@end
