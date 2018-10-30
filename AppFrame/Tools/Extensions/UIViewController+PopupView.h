//
//  UIViewController+PopupView.h
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PopupViewAnimation) {
    PopupViewAnimationFade = 0,
    PopupViewAnimationSlideBottomTop,
    PopupViewAnimationSlideRightLeft,
    PopupViewAnimationSlideLeftRight,
    PopupViewAnimationSlideBottomBottom,
};

@interface UIViewController (PopupView)

@property (nonatomic, assign) BOOL dismissWhenClick;

- (UIView *)topmostView;

- (void)presentPopupView:(UIView*)popupView animationType:(PopupViewAnimation)animationType dismissWhenClickBackground:(BOOL)dismissWhenClick;
- (void)dismissPopupViewWithAnimationType:(PopupViewAnimation)animationType completion:(void (^)(BOOL finished))completion;

- (void)presentPopupView:(UIView*)popupView animationType:(PopupViewAnimation)animationType dismissWhenClickBackground:(BOOL)dismissWhenClick inView:(UIView *)topView;
- (void)dismissPopupViewWithAnimationType:(PopupViewAnimation)animationType inView:(UIView *)topView completion:(void (^)(BOOL finished))completion;

- (void)dismissPopupView;

@end
