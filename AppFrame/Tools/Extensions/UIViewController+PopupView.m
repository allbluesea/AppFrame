//
//  UIViewController+PopupView.m
//

#import "UIViewController+PopupView.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

#define kPopupModalAnimationDuration 0.35
#define kPopupViewTag 23456
#define kBackgroundViewTag 23457
#define kSourceViewTag 23458
#define kLoadingViewTag 23459
#define kOverlayViewTag 23460


@implementation UIViewController (PopupView)

static NSString * const kDismissWhenClick = @"dismissWhenClick";

#pragma mark - Property

- (void)setDismissWhenClick:(BOOL)dismissWhenClick {
    if (dismissWhenClick != self.dismissWhenClick) {
        objc_setAssociatedObject(self, &kDismissWhenClick, @(dismissWhenClick), OBJC_ASSOCIATION_ASSIGN);
    }
    
}

- (BOOL)dismissWhenClick {
    return [objc_getAssociatedObject(self, &kDismissWhenClick) boolValue];
}

#pragma mark --- Fade

- (void)fadeViewIn:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView
{
    UIView *backgroundView = [overlayView viewWithTag:kBackgroundViewTag];
    // Generating Start and Stop Positions
    CGSize sourceSize = sourceView.bounds.size;
    CGSize popupSize = popupView.bounds.size;
    CGRect popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2, 
                                     (sourceSize.height - popupSize.height) / 2,
                                     popupSize.width, 
                                     popupSize.height);
    
    // Set starting properties
    popupView.frame = popupEndRect;
    popupView.alpha = 0.0f;
    
    [UIView animateWithDuration:kPopupModalAnimationDuration animations:^{
        backgroundView.alpha = 1.0f;
        popupView.alpha = 1.0f;
    } completion:^(BOOL finished) {
    }];
}

- (void)fadeViewOut:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView completion:(void (^)(BOOL finished)) fadeViewOutCompletion
{
    UIView *backgroundView = [overlayView viewWithTag:kBackgroundViewTag];
    [UIView animateWithDuration:kPopupModalAnimationDuration animations:^{
        backgroundView.alpha = 0.0f;
        popupView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        if(fadeViewOutCompletion !=nil)
            fadeViewOutCompletion(YES);
        [popupView removeFromSuperview];
        [overlayView removeFromSuperview];
    }];
}


#pragma mark Animations

#pragma mark - Slide

- (void)slideViewIn:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView WithAnimationType:(PopupViewAnimation)animationType
{
    UIView *backgroundView = [overlayView viewWithTag:kBackgroundViewTag];
    // Generating Start and Stop Positions
    CGSize sourceSize = sourceView.bounds.size;
    CGSize popupSize = popupView.bounds.size;
    CGRect popupStartRect;
    switch (animationType) {
        case PopupViewAnimationSlideBottomTop:
        case PopupViewAnimationSlideBottomBottom:
            popupStartRect = CGRectMake((sourceSize.width - popupSize.width) / 2, 
                                        sourceSize.height + popupSize.height, 
                                        popupSize.width, 
                                        popupSize.height);
            
            break;
        case PopupViewAnimationSlideLeftRight:
            popupStartRect = CGRectMake(-sourceSize.width, 
                                        (sourceSize.height - popupSize.height) / 2,
                                        popupSize.width, 
                                        popupSize.height);
            break;
            
        default:
            popupStartRect = CGRectMake(sourceSize.width, 
                                        (sourceSize.height - popupSize.height) / 2,
                                        popupSize.width, 
                                        popupSize.height);
            break;
    }        
    CGRect popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2, 
                                     (sourceSize.height - popupSize.height),
                                     popupSize.width, 
                                     popupSize.height);
    // NSLog(@"source y = %f  pop y = %f",sourceSize.height, popupSize.height);
    //  NSLog(@"start y =%f  end y=%f",popupStartRect.origin.y, popupEndRect.origin.y);
    // Set starting properties
    popupView.frame = popupStartRect;
    popupView.alpha = 1.0f;
    [UIView animateWithDuration:kPopupModalAnimationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        backgroundView.alpha = 1.0f;
        popupView.frame = popupEndRect;
    } completion:^(BOOL finished) {
    }];
}

- (void)slideViewOut:(UIView*)popupView sourceView:(UIView*)sourceView overlayView:(UIView*)overlayView WithAnimationType:(PopupViewAnimation)animationType completion:(void (^)(BOOL finished))slideViewOutCompletion
{
    UIView *backgroundView = [overlayView viewWithTag:kBackgroundViewTag];
    // Generating Start and Stop Positions
    CGSize sourceSize = sourceView.bounds.size;
    CGSize popupSize = popupView.bounds.size;
    CGRect popupEndRect;
    switch (animationType) {
        case PopupViewAnimationSlideBottomTop:
            popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2, 
                                      -popupSize.height, 
                                      popupSize.width, 
                                      popupSize.height);
            break;
        case PopupViewAnimationSlideBottomBottom:
            popupEndRect = CGRectMake((sourceSize.width - popupSize.width) / 2, 
                                      sourceSize.height, 
                                      popupSize.width, 
                                      popupSize.height);
            break;
        case PopupViewAnimationSlideLeftRight:
            popupEndRect = CGRectMake(sourceSize.width, 
                                      popupView.frame.origin.y, 
                                      popupSize.width, 
                                      popupSize.height);
            break;
        default:
            popupEndRect = CGRectMake(-popupSize.width, 
                                      popupView.frame.origin.y, 
                                      popupSize.width, 
                                      popupSize.height);
            break;
    }
    
    
    [UIView animateWithDuration:kPopupModalAnimationDuration delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        popupView.frame = popupEndRect;
        backgroundView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        if(slideViewOutCompletion)
            slideViewOutCompletion(YES);
        [popupView removeFromSuperview];
        [overlayView removeFromSuperview];
        
    }];
}


////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark View Handling
- (void)presentPopupView:(UIView*)popupView animationType:(PopupViewAnimation)animationType dismissWhenClickBackground:(BOOL) dismissWhenClick inView:(UIView *)topView
{
    self.dismissWhenClick = dismissWhenClick;
    UIView *sourceView = topView;
    sourceView.tag = kSourceViewTag;
    popupView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    popupView.tag = kPopupViewTag;
    
    // check if source view controller is not in destination
    if ([sourceView.subviews containsObject:popupView]) return;
    
    // customize popupView
    popupView.layer.shadowPath = [UIBezierPath bezierPathWithRect:popupView.bounds].CGPath;
    popupView.layer.masksToBounds = NO;
    
    /*popupView.layer.shadowOffset = CGSizeMake(5, 5);
     popupView.layer.shadowRadius = 5;
     popupView.layer.shadowOpacity = 0.5;*/
    
    // Add semi overlay
    UIView *overlayView = [[UIView alloc] initWithFrame:sourceView.bounds];
    overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    overlayView.tag = kOverlayViewTag;
    overlayView.backgroundColor = [UIColor clearColor];
    
    // BackgroundView
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:sourceView.bounds];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    backgroundView.tag = kBackgroundViewTag;
    backgroundView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
    backgroundView.alpha = 0.0f;
    [overlayView addSubview:backgroundView];
    
    
    // Make the Background Clickable
    UIButton * dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    dismissButton.backgroundColor = [UIColor clearColor];
    dismissButton.frame = sourceView.bounds;
    [overlayView addSubview:dismissButton];
    
    popupView.alpha = 0.0f;
    [overlayView addSubview:popupView];
    [sourceView addSubview:overlayView];
    
    if (self.dismissWhenClick) {
        [dismissButton addTarget:self action:@selector(doPredissmissPopViewController:) forControlEvents:UIControlEventTouchUpInside];
    }
    switch (animationType) {
        case PopupViewAnimationSlideBottomTop:
        case PopupViewAnimationSlideBottomBottom:
        case PopupViewAnimationSlideRightLeft:
        case PopupViewAnimationSlideLeftRight:
            dismissButton.tag = animationType;
            [self slideViewIn:popupView sourceView:sourceView overlayView:overlayView WithAnimationType:animationType];
            break;
        default:
            dismissButton.tag = PopupViewAnimationFade;
            [self fadeViewIn:popupView sourceView:sourceView overlayView:overlayView];
            break;
    }    
    
}
- (void)presentPopupView:(UIView*)popupView animationType:(PopupViewAnimation)animationType dismissWhenClickBackground:(BOOL)dismissWhenClick
{
    self.dismissWhenClick = dismissWhenClick;
    UIView *sourceView = [self topmostView];
    sourceView.tag = kSourceViewTag;
    popupView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    popupView.tag = kPopupViewTag;
    
    // check if source view controller is not in destination
    if ([sourceView.subviews containsObject:popupView]) return;
    
    // customize popupView
    popupView.layer.shadowPath = [UIBezierPath bezierPathWithRect:popupView.bounds].CGPath;
    popupView.layer.masksToBounds = NO;
    
    /*popupView.layer.shadowOffset = CGSizeMake(5, 5);
     popupView.layer.shadowRadius = 5;
     popupView.layer.shadowOpacity = 0.5;*/
    
    // Add semi overlay
    UIView *overlayView = [[UIView alloc] initWithFrame:sourceView.bounds];
    overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    overlayView.tag = kOverlayViewTag;
    overlayView.backgroundColor = [UIColor clearColor];
    
    // BackgroundView
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:sourceView.bounds];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    backgroundView.tag = kBackgroundViewTag;
    backgroundView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
    backgroundView.alpha = 0.0f;
    [overlayView addSubview:backgroundView];
    
    
    // Make the Background Clickable
    UIButton * dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    dismissButton.backgroundColor = [UIColor clearColor];
    dismissButton.frame = sourceView.bounds;
    [overlayView addSubview:dismissButton];
    
    popupView.alpha = 0.0f;
    [overlayView addSubview:popupView];
    [sourceView addSubview:overlayView];
    
    if (dismissWhenClick) {
        [dismissButton addTarget:self action:@selector(doPredissmissPopViewController:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [dismissButton addTarget:self action:@selector(didClickBackgound:) forControlEvents:UIControlEventTouchUpInside];
    }
    switch (animationType) {
        case PopupViewAnimationSlideBottomTop:
        case PopupViewAnimationSlideBottomBottom:
        case PopupViewAnimationSlideRightLeft:
        case PopupViewAnimationSlideLeftRight:
            dismissButton.tag = animationType;
            [self slideViewIn:popupView sourceView:sourceView overlayView:overlayView WithAnimationType:animationType];
            break;
        default:
            dismissButton.tag = PopupViewAnimationFade;
            [self fadeViewIn:popupView sourceView:sourceView overlayView:overlayView];
            break;
    }    
}

- (UIView *)topmostView {
    UIViewController *recentView = [self topmostViewController];
    
    return recentView.view;
}

- (UIViewController *)topmostViewController {
    UIViewController *rootController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    if([rootController isKindOfClass:[UITabBarController class]]){
        UITabBarController *tabBarController = (UITabBarController *)rootController;
        UINavigationController *selectController = tabBarController.selectedViewController;
        UIViewController *viewController = (UIViewController *)selectController.visibleViewController;
        while (viewController.presentedViewController) {
            viewController = viewController.presentedViewController;
        }
        
        return viewController;
    }else if ([rootController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *selectController = (UINavigationController *)rootController;
        return selectController.visibleViewController;
    }else if ([rootController isKindOfClass:[UIViewController class]]) {
        return rootController;
    }
    return nil;
}

- (void)doPredissmissPopViewController:(id)sender
{
    if (self.dismissWhenClick) {
        [self dismissPopupViewWithAnimation:sender];
    }
}

- (void)dismissPopupView {
    [self dismissPopupViewWithAnimationType:PopupViewAnimationFade completion:nil];
}

- (void)didClickBackgound:(id)sender{
    [self dismissPopupView];
}

- (void)dismissPopupViewWithAnimation:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton* dismissButton = sender;
        switch (dismissButton.tag) {
            case PopupViewAnimationSlideBottomTop:
            case PopupViewAnimationSlideBottomBottom:
            case PopupViewAnimationSlideRightLeft:
            case PopupViewAnimationSlideLeftRight:
                [self dismissPopupViewWithAnimationType:dismissButton.tag completion:^(BOOL finished) {
                    
                } ];
                break;
            default:
                [self dismissPopupViewWithAnimationType:PopupViewAnimationFade completion:^(BOOL finished){
                    
                }];
                break;
        }
    } else {
        [self dismissPopupViewWithAnimationType:PopupViewAnimationFade completion:^(BOOL finished) {
            
        }];
    }
}

////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public


- (void)dismissPopupViewWithAnimationType:(PopupViewAnimation)animationType inView:(UIView *)topView completion:(void (^)(BOOL finished))completion
{
    UIView *sourceView = topView;
    UIView *popupView = [sourceView viewWithTag:kPopupViewTag];
    UIView *overlayView = [sourceView viewWithTag:kOverlayViewTag];
    
    switch (animationType) {
        case PopupViewAnimationSlideBottomTop:
        case PopupViewAnimationSlideBottomBottom:
        case PopupViewAnimationSlideRightLeft:
        case PopupViewAnimationSlideLeftRight:
            [self slideViewOut:popupView sourceView:sourceView overlayView:overlayView WithAnimationType:animationType completion:completion];
            break;
            
        default:
            [self fadeViewOut:popupView sourceView:sourceView overlayView:overlayView completion:completion];
            break;
    }
    
}
- (void)dismissPopupViewWithAnimationType:(PopupViewAnimation)animationType completion:(void (^)(BOOL finished))completion
{
    UIView *sourceView = [self topmostView];
    UIView *popupView = [sourceView viewWithTag:kPopupViewTag];
    UIView *overlayView = [sourceView viewWithTag:kOverlayViewTag];
    
    switch (animationType) {
        case PopupViewAnimationSlideBottomTop:
        case PopupViewAnimationSlideBottomBottom:
        case PopupViewAnimationSlideRightLeft:
        case PopupViewAnimationSlideLeftRight:
            [self slideViewOut:popupView sourceView:sourceView overlayView:overlayView WithAnimationType:animationType completion:completion];
            break;
            
        default:
            [self fadeViewOut:popupView sourceView:sourceView overlayView:overlayView completion:completion];
            break;
    }
}



@end
