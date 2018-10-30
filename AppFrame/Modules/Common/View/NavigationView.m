//
//  NavigationView.m
//  BTZC
//
//  Created by apple on 2018/9/3.
//  Copyright © 2018年 Ergu. All rights reserved.
//

#import "NavigationView.h"

#define ITEM_MARGIN 12.f

@implementation NavigationView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = NAV_COLOR;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, NAV_STATUS_HEIGHT);
        [self addSubview:self.naviBar];
        [self addSubview:self.edgeLine];
        [self setupConstraints];
    }
    return self;
}

- (void)setupConstraints {
    [self.naviBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(STATUS_BAR_HEIGHT);
        make.left.right.bottom.equalTo(self);
    }];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ITEM_MARGIN);
        make.centerY.equalTo(self.naviBar);
        make.width.mas_equalTo(NAVBAR_BTN_LENGTH);
        make.height.mas_equalTo(NAVBAR_BTN_LENGTH);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-ITEM_MARGIN);
        make.centerY.height.equalTo(self.leftBtn);
        make.width.mas_equalTo(NAVBAR_BTN_LENGTH);
        make.height.mas_equalTo(NAVBAR_BTN_LENGTH);

    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.naviBar);
        make.left.equalTo(self.leftBtn.mas_right).offset(ITEM_MARGIN);
        make.right.equalTo(self.rightBtn.mas_left).offset(-ITEM_MARGIN);
    }];
    
    [self.edgeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(ITEM_MARGIN);
        make.right.mas_equalTo(-ITEM_MARGIN);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(0.5f);
    }];
}


#pragma mark - Getter

- (UIView *)naviBar {
    if (!_naviBar) {
        _naviBar = [UIView new];
        _naviBar.backgroundColor = [UIColor clearColor];
        [_naviBar addSubview:self.leftBtn];
        [_naviBar addSubview:self.rightBtn];
        [_naviBar addSubview:self.titleLbl];
    }
    return _naviBar;
}

- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _leftBtn;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _rightBtn;
}

- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [UILabel new];
        _titleLbl.font = FONT(18);
        _titleLbl.textColor = [UIColor black33];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLbl;
}

- (UIView *)edgeLine {
    if (!_edgeLine) {
        _edgeLine = [UIView new];
        _edgeLine.backgroundColor = LINE_COLOR;
    }
    return _edgeLine;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
