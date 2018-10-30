//
//  GlobalUser.h
//  BTZC
//
//  Created by apple on 2018/9/14.
//  Copyright © 2018年 Ergu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GU [GlobalUser sharedInstance]

@interface GlobalUser : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) NSInteger sex;

/// 单例
+ (GlobalUser *)sharedInstance;
/// 配置
+ (void)config;
/// 解析coredata对象
+ (void)parseModel:(NSManagedObject *)model;
/// 更新用户信息
+ (void)updateValue:(id)value forKey:(NSString *)key;
/// 清除用户信息
+ (void)clear;
/// 是否已登录
+ (BOOL)hasLogined;
/// 登录状态是否有效
+ (BOOL)validLoginStatus;


@end
