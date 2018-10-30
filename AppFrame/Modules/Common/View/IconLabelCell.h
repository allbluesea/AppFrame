//
//  IconLabelCell.h
//  BTZC
//
//  Created by apple on 2018/9/10.
//  Copyright © 2018年 Ergu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IconLabelCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImgv;
@property (nonatomic, strong) UIImageView *arrowImgv;
@property (nonatomic, strong) UILabel *leftLbl;
@property (nonatomic, strong) UILabel *rightLbl;
@property (nonatomic, strong) UIView *bottomLine;

+ (CGFloat)heightForCell;
- (void)setImgSize:(CGSize)size;

@end
