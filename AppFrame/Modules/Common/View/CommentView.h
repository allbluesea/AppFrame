//
//  CommentView.h
//  BTZC
//
//  Created by apple on 2018/9/12.
//  Copyright © 2018年 Ergu. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CommentViewDelegate <NSObject>

/**
 发送文本
 
 @param text 文本内容
 */
- (void)sendText:(NSString *)text;

@end

@interface CommentView : UIView

/** 代理 */
@property (nonatomic, weak) id<CommentViewDelegate> delegate;
/** 自身的动态高度 */
@property (nonatomic, assign) CGFloat dynamicHeight;


/**
 是否显示
 
 @param enable 布尔值
 */
- (void)show:(BOOL)enable;

/**
 写在控制器viewWillAppear里，用于注册通知，不建议打点调用
 */
- (void)willAppear;

/**
 写在控制器viewWillDisappear里，用于移除通知，不建议打点调用
 */
- (void)willDisappear;


/**
 清空输入内容
 */
- (void)clearText;

@end
