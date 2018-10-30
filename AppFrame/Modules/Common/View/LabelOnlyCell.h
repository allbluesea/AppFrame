//
//  LabelOnlyCell.h
//  BTZC
//
//  Created by apple on 2018/9/10.
//  Copyright © 2018年 Ergu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LabelOnlyCell : UITableViewCell

@property (nonatomic, strong) UILabel *leftLbl;
@property (nonatomic, strong) UILabel *rightLbl;
@property (nonatomic, strong) UIImageView *arrowImgv;
@property (nonatomic, strong) UIView *bottomLine;

+ (CGFloat)heightForCell;

/**
 隐藏箭头
 
 @param hidden 布尔值
 */
- (void)hidesArrow:(BOOL)hidden;

/**
 重设左侧Label宽度
 
 @param width 宽度值
 */
- (void)setLeftLabelWidth:(CGFloat)width;

@end
