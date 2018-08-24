//
//  Util.m
//  XYIOT
//
//  Created by stary on 2017/10/30.
//  Copyright © 2017年 XYWL. All rights reserved.
//

#import "Util.h"

@implementation Util

+ (BOOL)checkPhone:(NSString *)phoneStr {
    NSString *regexPhone = @"^((13[0-9])|(14[5,7])|(15[^4,\\D])|(18[0-9])|(17[0-9])|(19[0-9]))\\d{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexPhone];
    return [predicate evaluateWithObject:phoneStr];
}

+ (BOOL)checkURLStr:(NSString *)str {
    NSString *lowercaseStr = [str lowercaseString];
    NSString *regexURL = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@",
                          @"^((https|http|ftp|rtsp|mms)?://)",
                          @"?(([0-9a-z_!~*'().&=+$%-]+: )?[0-9a-z_!~*'().&=+$%-]+@)?",
                          @"(([0-9]{1,3}\\.){3}[0-9]{1,3}",
                          @"|",
                          @"([0-9a-z_!~*'()-]+\\.)*",
                          @"([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]\\.",
                          @"[a-z]{2,6})",
                          @"(:[0-9]{1,4})?",
                          @"((/?)|",
                          @"(/[0-9a-z_!~*'().;?:@&=+$,%#-]+)+/?)$"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexURL];
    
    return [predicate evaluateWithObject:lowercaseStr];
}

+ (NSString *)currentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [formatter stringFromDate:[NSDate date]];
    
    return time;
}

+ (NSString *)timeFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [formatter stringFromDate:date];
    
    return time;

}

+ (NSDate *)dateFromTime:(NSString *)time {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:time];
    
    return date;
}

+ (NSDate *)localDateFromDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [formatter stringFromDate:date];
    NSDate *localDate = [formatter dateFromString:time];
    
    return localDate;
}

+ (UIViewController *)topmostViewController {
    UIViewController *rootController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    if([rootController isKindOfClass:[UITabBarController class]]){
        UITabBarController *tabBarController = (UITabBarController *)rootController;
        UINavigationController *selectController = tabBarController.selectedViewController;
        UIViewController *viewController = (UIViewController *)selectController.visibleViewController;
        while (viewController.presentedViewController) {
            viewController = viewController.presentedViewController;
        }
        return viewController;
    }else if ([rootController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *selectController = (UINavigationController *)rootController;
        return selectController.visibleViewController;
    }else if ([rootController isKindOfClass:[UIViewController class]]) {
        return rootController;
    }
    return nil;
}

/**
 *  消息中心plist路径
 *
 *  @return 路径
 */
//+ (NSString *)findMsgFilePath {
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentPath = paths[0];
//    NSString *userPath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"user%@",[GM.user_id ] ? GM.user_id : kUserNotFoundId]];
//    NSString *filePath = [userPath stringByAppendingPathComponent:@"message.plist"];
//
//    return filePath;
//}

/**
 *  缓存列表plist路径
 *
 *  @return 路径
 */
+ (NSString *)findListCachesFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesPath = paths[0];
    NSString *filePath = [cachesPath stringByAppendingPathComponent:@"listCaches.plist"];
    
    return filePath;
}

/**
 *  写入数据到缓存plist
 *
 *  @param anObject 数据
 *  @param aKey    数据对应的key
 *
 *  @return 写入的结果
 */
+ (BOOL)writeFileWithObject:(id)anObject forKey:(NSString *)aKey {
    NSMutableDictionary *cacheDic = [NSMutableDictionary dictionaryWithContentsOfFile:[self findListCachesFilePath]];
    if (!cacheDic) {
        cacheDic = [NSMutableDictionary dictionary];
    }
    [cacheDic setObject:anObject forKey:aKey];
    
    BOOL ret = [cacheDic writeToFile:[self findListCachesFilePath] atomically:YES];
    
    return ret;
}

/**
 *  获取缓存数据
 *
 *  @param aKey 数据对应的key
 *
 *  @return 缓存的数据
 */
+ (NSArray *)cacheArrayForKey:(NSString *)aKey {
    NSMutableDictionary *cacheDic = [NSMutableDictionary dictionaryWithContentsOfFile:[self findListCachesFilePath]];
    NSArray *arr = [cacheDic objectForKey:aKey];
    return arr;
}

+ (NSArray *)removeNullFromArray:(NSArray *)originArr {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:originArr.count];
    for (NSDictionary *dic in originArr) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:dic];
            for (NSString *key in newDict.allKeys) {
                if ([[newDict objectForKey:key] isKindOfClass:[NSNull class]] || [[newDict objectForKey:key] isEqual:[NSNull null]]) {
                    [newDict removeObjectForKey:key];
                }
            }
            
            [array addObject:newDict];
        }
        
    }
    
    
    return [array copy];
}



@end
