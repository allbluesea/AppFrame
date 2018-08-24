//
//  Util.h
//  XYIOT
//
//  Created by stary on 2017/10/30.
//  Copyright © 2017年 XYWL. All rights reserved.
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
+ (BOOL)checkPhone:(NSString *)phoneStr;
/** 验证URL */
+ (BOOL)checkURLStr:(NSString *)str;
/** 当前时间 */
+ (NSString *)currentTime;
/** 日期转时间 */
+ (NSString *)timeFromDate:(NSDate *)date;
/** 时间转日期 */
+ (NSDate *)dateFromTime:(NSString *)time;
/** 当地日期 */
+ (NSDate *)localDateFromDate:(NSDate *)date;

+ (UIViewController *)topmostViewController;

/** 消息中心plist路径 */
+ (NSString *)findMsgFilePath;
/**
 *  缓存列表plist路径
 *
 *  @return 路径
 */
+ (NSString *)findListCachesFilePath;
/**
 *  写入数据到缓存plist
 *
 *  @param anObject 数据
 *  @param aKey    数据对应的key
 *
 *  @return 写入的结果
 */
+ (BOOL)writeFileWithObject:(id)anObject forKey:(NSString *)aKey;
/**
 *  获取缓存数据
 *
 *  @param aKey 数据对应的key
 *
 *  @return 缓存的数据
 */
+ (NSArray *)cacheArrayForKey:(NSString *)aKey;
/** 重置数组 */
+ (NSArray *)removeNullFromArray:(NSArray *)originArr;

@end
