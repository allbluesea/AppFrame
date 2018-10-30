//
//  Util.h
//
//  Created by stary on 2017/10/30.
//  Copyright © 2017年 Firebrk. All rights reserved.
//

#import <Foundation/Foundation.h>

//判断一个字符串是否是纯数字
static inline BOOL IsPureInt(NSString *s) {
    NSScanner* scan = [NSScanner scannerWithString:s];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

@interface Util : NSObject

/** 验证手机号 */
+ (BOOL)checkPhone:(NSString *)str;
/** 模糊验证手机号 */
+ (BOOL)dimCheckPhone:(NSString *)str;
/** 验证URL */
+ (BOOL)checkURLStr:(NSString *)str;
/// 检测版本更新(适用AppStore应用)
+ (void)checkVersionUpdate;
/// 检测版本更新(适用企业应用)
+ (void)checkEnterpriseVersionUpdate;


/** 当前时间 */
+ (NSString *)currentTime;
/** 日期转时间 */
+ (NSString *)timeFromDate:(NSDate *)date;
/** 时间转日期 */
+ (NSDate *)dateFromTime:(NSString *)time;
/** 当地日期 */
+ (NSDate *)localDateFromDate:(NSDate *)date;
/// 顶层控制器
+ (UIViewController *)topmostViewController;

/// DocumentPath追加路径
+ (NSString *)documentPathAppendPathComonent:(NSString *)component;
/// CachesPath追加路径
+ (NSString *)cachesPathAppendPathComonent:(NSString *)component;

/// 已读资讯plist路径
+ (NSString *)readedInfosFilePath;
/// 记录已读资讯
+ (void)recordReadedInfoWithID:(NSInteger)infoID;

/// 缓存列表plist路径
+ (NSString *)listCachesFilePath;
/// 消息中心plist路径
+ (NSString *)msgCenterFilePath;


/**
 *  写入数据到缓存plist
 *
 *  @param anObject 数据
 *  @param aKey 数据对应的key
 *
 *  @return 写入的结果
 */
+ (BOOL)writeListCachesWithObject:(id)anObject forKey:(NSString *)aKey;

/**
 *  获取缓存数据
 *
 *  @param aKey 数据对应的key
 *
 *  @return 缓存的数据
 */
+ (NSArray *)cacheArrayForKey:(NSString *)aKey;

/** 移除null返回新数组 */
+ (NSArray *)removeNullFromArray:(NSArray *)originArr;

/** null 转 @“” */
+ (id)convertNullToEmptyString:(id)object;

/** view 转图片 */
+ (UIImageView *)imageFromView:(UIView *)snapView;






@end
