//
//  UIType+Extension.h
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIColor+Additions.h"
#import "UIImage+Color.h"

#pragma mark - UIView Inline Functions

UIKIT_STATIC_INLINE void
UIViewSetFrameOrigin(UIView *view, CGPoint origin) {
    view.frame = CGRectMake(origin.x, origin.y, view.frame.size.width, view.frame.size.height);
}

UIKIT_STATIC_INLINE void
UIViewSetFrameSize(UIView *view, CGSize size) {
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, size.width, size.height);
}

UIKIT_STATIC_INLINE void
UIViewSetFrameX(UIView *view, CGFloat x) {
    view.frame = CGRectMake(x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
}

UIKIT_STATIC_INLINE void
UIViewSetFrameY(UIView *view, CGFloat y) {
    view.frame = CGRectMake(view.frame.origin.x, y, view.frame.size.width, view.frame.size.height);
}

UIKIT_STATIC_INLINE void
UIViewSetFrameWidth(UIView *view, CGFloat width) {
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, width, view.frame.size.height);
}

UIKIT_STATIC_INLINE void
UIViewSetFrameHeight(UIView *view, CGFloat height) {
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, height);
}

UIKIT_STATIC_INLINE void
UIViewSetFrameCenterX(UIView *view, CGFloat x) {
    CGPoint center = view.center;
    center.x = x;
    view.center = center;
}

UIKIT_STATIC_INLINE void
UIViewSetFrameCenterY(UIView *view, CGFloat y) {
    CGPoint center = view.center;
    center.y = y;
    view.center = center;
}

#pragma mark UIView+Extension

@interface UIView (Extension)

@property (nonatomic) CGFloat left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint origin;      ///< Shortcut for frame.origin.
@property (nonatomic) CGSize  size;        ///< Shortcut for frame.size.

- (UIViewController *)containedViewController;
- (id)findTraverseResponderChainForUIViewController;

@end


#pragma mark NSString+Extension

@interface NSString (Extension)

// 安全判断是不是为空
- (BOOL)isNotEmpty;

// 随机字符串
+ (NSString*)randomString;

+ (NSString*)randomString:(NSUInteger)length;

+ (NSString*)randomStringWithNoSpace:(NSUInteger)length;

@end

#pragma mark UIColor+Extension

@interface NSRandom : NSObject

+ (CGFloat)valueBoundary:(CGFloat)low To:(CGFloat)high;

@end

#pragma mark  UIImage+Extension

static const CGPoint kCGAnchorPointCenter = { 0.5f, 0.5f };
static const CGPoint kCGAnchorPointTC = { .5f, 0.f };
static const CGPoint kCGAnchorPointLC = { 0.f, .5f };

@interface UIImage (Extension)

// 自动使用中心点拉大图片
+ (UIImage*)stretchImage:(NSString*)name;
+ (UIImage*)stretchImage:(NSString*)name anchorPoint:(CGPoint)pt;
+ (UIImage*)stretchImage:(NSString*)name atPoint:(CGPoint)pt;
+ (UIImage*)stretchImageHov:(NSString*)name;
+ (UIImage*)stretchImageVec:(NSString*)name;

// 裁剪图片
- (UIImage*)imageClip:(CGRect)rc;

+ (UIImage *)retinaImage:(UIImage *)image;
//修改图片大小
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
@end


NSString * getLatestTimeStrWithInterval(NSTimeInterval seconds);
NSString * getLatestTimeStrWithStr(NSString * str);

NSString * getTimeWithDayFormatStr(NSString * str);

NSString * getDayFormatStr(NSString * str);

@interface NSArray (Extension)
// 安全读取数据
- (id)objectAtIndexSafe:(NSUInteger)index;

@end



