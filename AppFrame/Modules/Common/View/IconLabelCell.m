
//
//  IconLabelCell.m
//  BTZC
//
//  Created by apple on 2018/9/10.
//  Copyright © 2018年 Ergu. All rights reserved.
//

#import "IconLabelCell.h"

#define ICON_WIDTH 16.f
#define ICON_HEIGHT 16.f
#define LEFTLBL_WIDTH 70.f

@implementation IconLabelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _iconImgv = [[UIImageView alloc] init];
        _iconImgv.frame = CGRectMake(MARGIN, ([self.class heightForCell] - ICON_HEIGHT) / 2, ICON_WIDTH, ICON_HEIGHT);
        _iconImgv.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_iconImgv];
        
        // 左label
        _leftLbl = [[UILabel alloc] init];
        _leftLbl.frame = CGRectMake(CGRectGetMaxX(_iconImgv.frame) + 12, 0, LEFTLBL_WIDTH, [self.class heightForCell]);
        _leftLbl.backgroundColor = [UIColor clearColor];
        _leftLbl.textColor = [UIColor colorWithRGB:0x666666];
        _leftLbl.font = FONT(14);
        [self.contentView addSubview:_leftLbl];
        
        // 右箭头
        UIImage *arrow = [UIImage imageNamed:@"common_arrow_next"];
        _arrowImgv = [[UIImageView alloc] init];
        _arrowImgv.frame = CGRectMake(SCREEN_WIDTH - MARGIN - arrow.size.width, ([self.class heightForCell] - arrow.size.height)/2, arrow.size.width, arrow.size.height);
        _arrowImgv.backgroundColor = [UIColor clearColor];
        _arrowImgv.image = arrow;
        [self.contentView addSubview:_arrowImgv];
        
        // 右label
        _rightLbl = [[UILabel alloc] init];
        _rightLbl.frame = CGRectMake(CGRectGetMaxX(_leftLbl.frame) + MARGIN, 0,
                                     SCREEN_WIDTH - ICON_WIDTH - 12 - LEFTLBL_WIDTH - CGRectGetWidth(_arrowImgv.frame) - 4 * MARGIN, [self.class heightForCell]);
        _rightLbl.backgroundColor = [UIColor clearColor];
        _rightLbl.textAlignment = NSTextAlignmentRight;
        _rightLbl.textColor = [UIColor colorWithRGB:0x959595];
        _rightLbl.font = FONT(12);
        [self.contentView addSubview:_rightLbl];
        
        // 底部线
        _bottomLine = [[UIView alloc] init];
        _bottomLine.frame = CGRectMake(MARGIN, [self.class heightForCell] - 0.5, SCREEN_WIDTH - MARGIN, 0.5);
        _bottomLine.backgroundColor = SEPARATOR_COLOR;
        [self.contentView addSubview:_bottomLine];
        
    }
    
    return self;
}

- (void)setImgSize:(CGSize)size {
    _iconImgv.frame = CGRectMake(MARGIN, ([self.class heightForCell] - size.height) / 2, size.width, size.height);
    _leftLbl.frame = CGRectMake(CGRectGetMaxX(_iconImgv.frame) + 12, 0, LEFTLBL_WIDTH, [self.class heightForCell]);
    _rightLbl.frame = CGRectMake(CGRectGetMaxX(_leftLbl.frame) + MARGIN, 0,
                                 SCREEN_WIDTH - size.width - 12 - LEFTLBL_WIDTH - CGRectGetWidth(_arrowImgv.frame) - 4 * MARGIN, [self.class heightForCell]);
}



+ (CGFloat)heightForCell {
    return 50.f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
