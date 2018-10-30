//
//  CommonShareView.h
//  BTZC
//
//  Created by apple on 2018/9/12.
//  Copyright © 2018年 Ergu. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <UMShare/UMShare.h>

@interface CommonShareView : UIView

@property (nonatomic, copy) void(^cancelActionHandler)(void);
//@property (nonatomic, copy) void(^didSelectedPlatformHandler)(UMSocialPlatformType type);

+ (CGFloat)preferredHeight;

@end
