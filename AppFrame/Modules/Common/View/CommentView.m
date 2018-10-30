//
//  CommentView.m
//  BTZC
//
//  Created by apple on 2018/9/12.
//  Copyright © 2018年 Ergu. All rights reserved.
//

#import "CommentView.h"

@interface CommentView () <UITextViewDelegate>

/** 输入框 */
@property (nonatomic, strong) UITextView *textView;
/** 键盘的高度 */
@property (nonatomic, assign) CGFloat keyboardHeight;
/** 半透明背景 */
@property (nonatomic, strong) UIView *maskView;
/** 发送按钮 */
@property (nonatomic, strong) UIButton *sendBtn;
/** 字数 */
@property (nonatomic, strong) UILabel *numLbl;

@end

@implementation CommentView

static NSInteger const __maxNum = 200; // 最大字数

- (instancetype)init {
    if (self = [super init]) {
        self.dynamicHeight = 90; // 初始高度值为90
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *topLine = [[UIView alloc] init];
        topLine.backgroundColor = LINE_COLOR;
        [self addSubview:topLine];
        [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
        
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = LINE_COLOR;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.enablesReturnKeyAutomatically = YES;
        _textView.font = FONT(16);
        _textView.layer.cornerRadius = 32 / 2.f;
        _textView.layer.masksToBounds = YES;
        _textView.textColor = [UIColor colorWithRGB:0x555555];
        _textView.textContainerInset = UIEdgeInsetsMake(8, 10, 8, 10);
        _textView.delegate = self;
        _textView.scrollEnabled = NO;
        [self addSubview:_textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(MARGIN);
            make.right.mas_offset(-MARGIN);
            make.top.mas_offset(9);
            make.height.mas_equalTo(32);
        }];
        
        UIView *midLine = [[UIView alloc] init];
        midLine.backgroundColor = LINE_COLOR;
        [self addSubview:midLine];
        [midLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.mas_offset(-40);
            make.height.mas_equalTo(0.5);
        }];
        
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.backgroundColor = [UIColor colorWithRGB:0xcccccc];
        _sendBtn.titleLabel.font = FONT(13);
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        _sendBtn.layer.cornerRadius = 2;
        _sendBtn.layer.masksToBounds = YES;
        _sendBtn.enabled = NO;
        [_sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sendBtn];
        [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-15);
            make.bottom.mas_offset(-6);
            make.width.mas_equalTo(54);
            make.height.mas_equalTo(28);
        }];
        
        _numLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_sendBtn.frame) - 15 - 25, CGRectGetMinY(_sendBtn.frame), 25, CGRectGetHeight(_sendBtn.frame))];
        _numLbl.textAlignment = NSTextAlignmentRight;
        _numLbl.textColor = [UIColor black99];
        _numLbl.font = FONT(11);
        _numLbl.text = [NSString stringWithFormat:@"%ld", __maxNum];
        [self addSubview:_numLbl];
        [_numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.equalTo(_sendBtn);
            make.right.equalTo(_sendBtn.mas_left).offset(-15);
            make.width.mas_equalTo(25);
        }];
        
        // 键盘frame改变通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillChangeFrameNotification:)
                                                     name:UIKeyboardWillChangeFrameNotification
                                                   object:nil];
    }
    
    return self;
}

#pragma mark - Public Method

- (void)show:(BOOL)enable {
    [self showMaskView:enable];
    if (enable) {
        [self.textView becomeFirstResponder];
    } else {
        [self.textView resignFirstResponder];
    }
}

- (void)willAppear {
    // 注册键盘frame改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrameNotification:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}

- (void)willDisappear {
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)clearText {
    _textView.text = nil;
    _sendBtn.backgroundColor = [UIColor colorWithRGB:0xcccccc];
    _sendBtn.enabled = NO;
    _numLbl.textColor = [UIColor black99];
    _numLbl.text = [NSString stringWithFormat:@"%ld", __maxNum];
    _textView.layer.cornerRadius = 16;
    self.dynamicHeight = 90;
    [_textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(32);
    }];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.dynamicHeight);
    }];
}

#pragma mark - Private Method

/**
 是否显示半透明背景
 
 @param enable 布尔值
 */
- (void)showMaskView:(BOOL)enable {
    self.maskView.hidden = !enable;
}

#pragma mark - NSNotification

/**
 键盘frame即将发生改变
 
 @param note 通知
 */
- (void)keyboardWillChangeFrameNotification:(NSNotification *)note {
    // 设置动画速率
    NSInteger curve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    // 设置动画时间
    NSTimeInterval duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 获取键盘位置改变后的frame
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 记录键盘高度
    self.keyboardHeight = rect.size.height;
    
    // 显示半透明背景
    [self showMaskView:rect.origin.y != SCREEN_HEIGHT];
    
    // 开始动画
    CGFloat offsetY = rect.origin.y == SCREEN_HEIGHT ? self.dynamicHeight : -self.keyboardHeight;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(offsetY);
    }];
    [UIView setAnimationCurve:curve];
    [UIView animateWithDuration:duration animations:^{
        //        self.transform = CGAffineTransformMakeTranslation(0, offsetY);
        [self.superview setNeedsLayout];
        [self.superview layoutIfNeeded];
    }];
    
    
}

#pragma mark - UITextView

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self show:NO];
        if (textView.text.length > __maxNum) {
            [MBProgressHUD showMessage:@"字数超过最大限制" toView:self.superview afterDelay:1];
            return NO;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(sendText:)]) {
            [self.delegate sendText:textView.text];
        }
        return NO;
    }
    
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        _sendBtn.backgroundColor = [UIColor blue];
        _sendBtn.enabled = YES;
        if (textView.text.length >= __maxNum) {
            _numLbl.textColor = [UIColor colorWithRGB:0xfa533d];
        } else {
            _numLbl.textColor = [UIColor black99];
        }
        _numLbl.text = [NSString stringWithFormat:@"%ld", __maxNum - textView.text.length];
    } else {
        _sendBtn.backgroundColor = [UIColor colorWithRGB:0xcccccc];
        _sendBtn.enabled = NO;
        _numLbl.text = [NSString stringWithFormat:@"%ld", __maxNum];
    }
    
    CGSize constraintSize = CGSizeMake(SCREEN_WIDTH - 2 * MARGIN, CGFLOAT_MAX);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height > 35.5) {
        // 多行
        textView.layer.cornerRadius = 4;
        self.dynamicHeight = 40 + 18 + size.height;
        [textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(size.height);
        }];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.dynamicHeight);
        }];
    } else {
        // 单行
        textView.layer.cornerRadius = 16;
        self.dynamicHeight = 90;
        [textView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(32);
        }];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.dynamicHeight);
        }];
    }
}

#pragma mark - Action
// 点击发送按钮
- (void)sendBtnClick:(UIButton *)sender {
    [self show:NO];
    if (_textView.text.length > __maxNum) {
        [MBProgressHUD showMessage:@"字数超过最大限制" toView:self.superview afterDelay:1];
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendText:)]) {
        [self.delegate sendText:self.textView.text];
    }
}
// 点击半透明背景
- (void)clickMaskView:(UITapGestureRecognizer *)tap {
    [self show:NO];
}

#pragma mark - Getter

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        _maskView.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMaskView:)];
        [_maskView addGestureRecognizer:tap];
        [self.superview insertSubview:_maskView belowSubview:self];
        [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.superview);
        }];
        [self.superview layoutIfNeeded];
    }
    
    return _maskView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
