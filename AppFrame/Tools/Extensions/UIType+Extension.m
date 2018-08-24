//
//  UIType+Extension.m
//

#import "UIType+Extension.h"
#import "NSDate+Additions.h"

// MARK: **** UIView ****

@implementation UIView (Extension)

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (UIViewController *)containedViewController {
    UIView * target = self.superview ? self.superview : self;
    return (UIViewController *)[target findTraverseResponderChainForUIViewController];
}

- (id)findTraverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]] || [nextResponder isKindOfClass:[UINavigationController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder findTraverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}

@end


@implementation NSRandom

+ (CGFloat)valueBoundary:(CGFloat)low To:(CGFloat)high {
    CGFloat val = rand();
    val /= RAND_MAX;
    val = val * (high - low) + low;
    return val;
}

@end

// MARK: ----- UIImage -----

@implementation UIImage (Extension)

+ (UIImage*)stretchImage:(NSString *)name {
    return [self stretchImage:name anchorPoint:kCGAnchorPointCenter];
}

+ (UIImage*)stretchImage:(NSString*)name anchorPoint:(CGPoint)pt {
    UIImage* image = nil;
    
    
    NSString* str = name;
    if (str.isNotEmpty)
        image = [UIImage imageWithContentsOfFile:str];
    
    if (image == nil)
        image = [self imageNamed:name];
    
    CGSize imgSize = image.size;
    
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(imgSize.height * pt.y,
                                                                imgSize.width * pt.x,
                                                                imgSize.height * (1 - pt.y),
                                                                imgSize.width * (1 - pt.x))];
    return image;
}

+ (UIImage*)stretchImage:(NSString*)name atPoint:(CGPoint)pt {
    UIImage* image = nil;
    
    NSString* str = name;
    if (str.isNotEmpty)
        image = [UIImage imageWithContentsOfFile:str];
    
    if (image == nil)
        image = [self imageNamed:name];
    
    CGSize imgSize = image.size;
    
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(pt.y,
                                                                pt.x,
                                                                imgSize.height - pt.y,
                                                                imgSize.width - pt.x)];
    return image;
}

+ (UIImage*)stretchImageHov:(NSString*)name {
    return [UIImage stretchImage:name anchorPoint:kCGAnchorPointTC];
}

+ (UIImage*)stretchImageVec:(NSString*)name {
    return [UIImage stretchImage:name anchorPoint:kCGAnchorPointLC];
}

- (UIImage*)imageClip:(CGRect)rc {
    UIGraphicsBeginImageContextWithOptions(rc.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextTranslateCTM(ctx, 0, -self.size.height);
    
    CGContextDrawImage(ctx, CGRectMake(-rc.origin.x, rc.origin.y, self.size.width, self.size.height), self.CGImage);
    UIImage* ret = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return ret;
}

+ (UIImage *)retinaImage:(UIImage *)image
{
    UIImage *scaledImage = image;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
    {
        CGFloat scale = 2.0;
        scaledImage = [[UIImage alloc] initWithCGImage:image.CGImage scale:scale orientation:image.imageOrientation];
    }
    return scaledImage;
}

- (UIImage *)imageByScalingToSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor < heightFactor) {
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    // this is actually the interesting part:
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    return newImage ;
}

@end

// MARK: ----- NSString -----

@implementation NSString (Extension)

- (BOOL)isNotEmpty {
    if ([self isEqualToString:@""])
        return NO;
    if (self.length != 0) {
        return [self stringByReplacingOccurrencesOfString:@" " withString:@""].length != 0;
    }
    return self.length != 0;
}

+ (NSString*)randomString {
    return [NSString randomString:0];
}

+ (NSString*)randomString:(NSUInteger)length {
    static unichar chars[] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', ' ', '\n', '\t'};
    if (length == 0)
        length = [NSRandom valueBoundary:0 To:sizeof(chars)];
    NSMutableString* str = [NSMutableString stringWithCapacity:length];
    for (int i = 0; i < length; ++i) {
        int idx = [NSRandom valueBoundary:0 To:sizeof(chars)/sizeof(unichar)];
        [str appendString:[NSString stringWithCharacters:(chars + idx) length:1]];
    }
    return str;
}

+ (NSString*)randomStringWithNoSpace:(NSUInteger)length{
    static unichar chars[] = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};
    if (length == 0)
        length = [NSRandom valueBoundary:0 To:sizeof(chars)];
    NSMutableString* str = [NSMutableString stringWithCapacity:length];
    for (int i = 0; i < length; ++i) {
        int idx = [NSRandom valueBoundary:0 To:sizeof(chars)/sizeof(unichar)];
        [str appendString:[NSString stringWithCharacters:(chars + idx) length:1]];
    }
    return str;
}

@end

// MARK: ----- NSDate -----

static NSDateFormatter * dateFormatter_ = nil;
static NSDateFormatter * dateFormatterMonth_ = nil;
static NSDateFormatter * dateFormatterHour_ = nil;

NSString * getLatestTimeStrWithInterval(NSTimeInterval seconds) {
    NSDate * today = [NSDate date];
    NSDate * createDate = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    NSTimeInterval interval = MAX(0, [today timeIntervalSince1970]-seconds);
    NSString * str = @"";
    if (interval < 60) {
        str = @"刚刚";
    }else if (interval < 60*60) {
        if ((int)interval/60<=0) {
            str = @"刚刚";
        }else{
            str = [NSString stringWithFormat:@"%d分钟前",(int)interval/60];
        }
    }else if (interval < 60*60*24) {
        str = [NSString stringWithFormat:@"%d小时前",(int)interval/(60*60)];
    }else if (interval < 60*60*24*3) {
        str = [NSString stringWithFormat:@"%d天前",(int)interval/(60*60*24)];
    }
    else if ([createDate isThisYear]) {
        if (dateFormatterMonth_ == nil) {
            dateFormatterMonth_ = [[NSDateFormatter alloc] init];
            [dateFormatterMonth_ setDateFormat:@"MM-dd"]; // HH:mm
        }
        str = [dateFormatterMonth_ stringFromDate:createDate];
    }
    else {
        if (dateFormatter_ == nil) {
            dateFormatter_ = [[NSDateFormatter alloc] init];
            [dateFormatter_ setDateFormat:@"yyyy-MM-dd"];
        }
        str = [dateFormatter_ stringFromDate:createDate];
    }
    return str;
}

NSString * getLatestTimeStrWithStr(NSString * str) {
    if (dateFormatter_ == nil) {
        dateFormatter_ = [[NSDateFormatter alloc] init];
        [dateFormatter_ setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSDate * createdate = [dateFormatter_ dateFromString:str];
    if (createdate == nil) {
        createdate = [NSDate date];
    }
    NSTimeInterval interval = [createdate timeIntervalSince1970];
    return getLatestTimeStrWithInterval(interval);
}

NSString * getTimeWithDayFormatStr(NSString * str) {
    if (dateFormatter_ == nil) {
        dateFormatter_ = [[NSDateFormatter alloc] init];
        [dateFormatter_ setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    NSDate * createDate = [dateFormatter_ dateFromString:str];
    if (!str || [str length] == 0 || !createDate) {
        createDate = [NSDate date];
    }
    
    if (dateFormatterHour_ == nil) {
        dateFormatterHour_ = [[NSDateFormatter alloc] init];
    }
    NSString * hourTimeStr = str;
    if ([createDate isToday]) {
        [dateFormatterHour_ setDateFormat:@"今天HH:mm"];
        hourTimeStr = [dateFormatterHour_ stringFromDate:createDate];
    }
    else if ([createDate isYesterday]) {
        [dateFormatterHour_ setDateFormat:@"昨天HH:mm"];
        hourTimeStr = [dateFormatterHour_ stringFromDate:createDate];
    }
    else if ([createDate isEqualToDateIgnoringTime:[NSDate dateWithDaysBeforeNow:2]]) {
        [dateFormatterHour_ setDateFormat:@"前天HH:mm"];
        hourTimeStr = [dateFormatterHour_ stringFromDate:createDate];
    }
    else if ([createDate isThisYear]) {
        [dateFormatterHour_ setDateFormat:@"MM-dd HH:mm"];
        hourTimeStr = [dateFormatterHour_ stringFromDate:createDate];
    }
    else {
        [dateFormatterHour_ setDateFormat:@"yyyy-MM-dd"];
        hourTimeStr = [dateFormatterHour_ stringFromDate:createDate];
    }
    return hourTimeStr;
	   
}

NSString * getDayFormatStr(NSString * str) {
//    if (dateFormatter_ == nil) {
        dateFormatter_ = [[NSDateFormatter alloc] init];
        [dateFormatter_ setDateFormat:@"yyyy-MM-dd"];
//    }
    
    NSDate * createDate = [dateFormatter_ dateFromString:str];
    if (!str || [str length] == 0 || !createDate) {
        createDate = [NSDate date];
    }
    
    if (dateFormatterHour_ == nil) {
        dateFormatterHour_ = [[NSDateFormatter alloc] init];
    }
    NSString * hourTimeStr = str;
    if ([createDate isToday]) {
        [dateFormatterHour_ setDateFormat:@"今天"];
        hourTimeStr = [dateFormatterHour_ stringFromDate:createDate];
    }
    else if ([createDate isYesterday]) {
        [dateFormatterHour_ setDateFormat:@"昨天"];
        hourTimeStr = [dateFormatterHour_ stringFromDate:createDate];
    }
    else if ([createDate isEqualToDateIgnoringTime:[NSDate dateWithDaysBeforeNow:2]]) {
        [dateFormatterHour_ setDateFormat:@"前天"];
        hourTimeStr = [dateFormatterHour_ stringFromDate:createDate];
    }
    else if ([createDate isThisYear]) {
        [dateFormatterHour_ setDateFormat:@"MM-dd"];
        hourTimeStr = [dateFormatterHour_ stringFromDate:createDate];
    }
    else {
        [dateFormatterHour_ setDateFormat:@"yyyy-MM-dd"];
        hourTimeStr = [dateFormatterHour_ stringFromDate:createDate];
    }
    return hourTimeStr;
}

// MARK: ----- NSArray -----

@implementation NSArray (Extension)

- (id)objectAtIndexSafe:(NSUInteger)index {
    if (self.count > index) {
        id ret = [self objectAtIndex:index];
        if ([ret isKindOfClass:[NSNull class]])
            return nil;
        return ret;
    }
    return nil;
}
@end



