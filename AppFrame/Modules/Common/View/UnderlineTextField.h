//
//  UnderLineTextField.h
//  TIY
//
//  Created by bxd on 16/6/1.
//  Copyright © 2016年 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnderlineTextField : UITextField <UITextFieldDelegate>

/// 普通状态颜色 默认灰色
@property (nonatomic, strong) UIColor *normalTintColor;
/// 高亮状态颜色 默认蓝色
@property (nonatomic, strong) UIColor *highlightedTintColor;

@end
