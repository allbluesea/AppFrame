//
//  LabelOnlyCell.m
//  BTZC
//
//  Created by apple on 2018/9/10.
//  Copyright © 2018年 Ergu. All rights reserved.
//

#import "LabelOnlyCell.h"

#define ARROW_WIDTH 9

@implementation LabelOnlyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _leftLbl = [[UILabel alloc] init];
        _leftLbl.frame = CGRectMake(MARGIN, 0, (SCREEN_WIDTH-MARGIN*2)/2, [self.class heightForCell]);
        _leftLbl.backgroundColor = [UIColor clearColor];
        _leftLbl.textColor = [UIColor black33];
        _leftLbl.font = FONT(15);
        [self.contentView addSubview:_leftLbl];
        
        UIImage *arrow = [UIImage imageNamed:@"common_arrow_next"];
        _arrowImgv = [[UIImageView alloc] init];
        _arrowImgv.frame = CGRectMake(SCREEN_WIDTH - arrow.size.width - MARGIN, ([self.class heightForCell] - arrow.size.height)/2, arrow.size.width, arrow.size.height);
        _arrowImgv.backgroundColor = [UIColor clearColor];
        _arrowImgv.image = arrow;
        [self.contentView addSubview:_arrowImgv];
        
        _rightLbl = [[UILabel alloc] init];
        _rightLbl.frame = CGRectMake(CGRectGetMaxX(_leftLbl.frame) , 0,
                                    (SCREEN_WIDTH-MARGIN*2)/2, [self.class heightForCell]);
        _rightLbl.backgroundColor = [UIColor clearColor];
        _rightLbl.textAlignment = NSTextAlignmentRight;
        _rightLbl.textColor = [UIColor black99];
        _rightLbl.font = FONT(12);
        [self.contentView addSubview:_rightLbl];
        
        
//        _bottomLine = [[UIView alloc] init];
//        _bottomLine.frame = CGRectMake(MARGIN, [self.class heightForCell] - 0.5, SCREEN_WIDTH - MARGIN, 0.5);
//        _bottomLine.backgroundColor = LINE_COLOR;
//        [self.contentView addSubview:_bottomLine];
        
    }
    
    return self;
}

+ (CGFloat)heightForCell {
    return 60;
}

- (void)hidesArrow:(BOOL)hidden {
    _arrowImgv.hidden = hidden;
    [self updateSubviewsLayout];
}

- (void)setLeftLabelWidth:(CGFloat)width {
    UIViewSetFrameWidth(_leftLbl, width);
    [self updateSubviewsLayout];
    
}

/**
 布局发生改变后更新
 */
- (void)updateSubviewsLayout {
    CGFloat width = _arrowImgv.hidden ? SCREEN_WIDTH - 3 * MARGIN - CGRectGetWidth(_leftLbl.frame) : SCREEN_WIDTH - 4 * MARGIN - ARROW_WIDTH - CGRectGetWidth(_leftLbl.frame);
    UIViewSetFrameX(_rightLbl, CGRectGetMaxX(_leftLbl.frame) + MARGIN);
    UIViewSetFrameWidth(_rightLbl, width);
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
