//
//  BaseTableViewCell.h
//  AppFrame
//
//  Created by icebrk on 2018/8/20.
//  Copyright © 2018年 Firebrk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell

/** 更新数据 */
- (void)updateData:(id)model;

/** 高度 */
+ (CGFloat)heightForCell;

@end
