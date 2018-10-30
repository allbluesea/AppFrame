//
//  Util.m
//
//  Created by stary on 2017/10/30.
//  Copyright © 2017年 Firebrk. All rights reserved.
//

#import "Util.h"

static NSString * const APP_ID_IN_APP_STORE = @"1436279425"; ///< AppStore中应用id
static NSString * const VERSION_INFO_URL = @""; ///< 企业应用

@implementation Util

+ (BOOL)checkPhone:(NSString *)str {
    NSString *regexPhone = @"^((13[0-9])|(14[5,7])|(15[^4,\\D])|(18[0-9])|(17[0-9])|(19[0-9]))\\d{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexPhone];
    return [predicate evaluateWithObject:str];
}

+ (BOOL)dimCheckPhone:(NSString *)str {
    NSString *regexPhone = @"^1[3-9]\\d{9}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexPhone];
    return [predicate evaluateWithObject:str];
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
    return [self timeFromDate:[NSDate date]];
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

+ (NSString *)periodTimeFromDateString:(NSString *)dateStr {
    NSString *period = dateStr;
    if (dateStr) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *date = [formatter dateFromString:dateStr];
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:date];
        if (interval < 60) {
            period = @"刚刚";
        } else if (interval < 3600) {
            period = [NSString stringWithFormat:@"%d分钟前", (int)(interval / 60)];
        } else if (interval < 86400) {
            period = [NSString stringWithFormat:@"%d小时前", (int)(interval / 3600)];
        } else if (interval < 604800) {
            period = [NSString stringWithFormat:@"%d天前", (int)(interval / 86400)];
        } else {
            [formatter setDateFormat:@"yyyy年MM月dd日"];
            period = [formatter stringFromDate:date];
        }
    }
    
    return period;
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

+ (NSString *)documentPathAppendPathComonent:(NSString *)component {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = paths[0];
    NSString *filePath = [documentPath stringByAppendingPathComponent:component];
    return filePath;
}

+ (NSString *)cachesPathAppendPathComonent:(NSString *)component {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesPath = paths[0];
    NSString *filePath = [cachesPath stringByAppendingPathComponent:component];
    return filePath;
}

+ (NSString *)msgCenterFilePath {
    return [self documentPathAppendPathComonent:@"msg.plist"];
}

// 已读资讯plist路径
+ (NSString *)readedInfosFilePath {
    return [self cachesPathAppendPathComonent:@"readedInfos.plist"];
}

// 记录已读资讯
+ (void)recordReadedInfoWithID:(NSInteger)infoID {
    NSString *path = [self readedInfosFilePath];
    NSMutableArray *tmpArr = [NSMutableArray arrayWithContentsOfFile:path];
    if (!tmpArr) {
        tmpArr = [NSMutableArray arrayWithCapacity:500];
    }
    if (tmpArr.count >= 500) {
        [tmpArr removeObjectsInRange:NSMakeRange(0, 20)];
    }
    if (![tmpArr containsObject:@(infoID)]) {
        [tmpArr addObject:@(infoID)];
        [tmpArr writeToFile:path atomically:YES];
    }
}

// 缓存列表plist路径
+ (NSString *)listCachesFilePath {
    return [self cachesPathAppendPathComonent:@"listCaches.plist"];
}

// 写入数据到缓存plist
+ (BOOL)writeListCachesWithObject:(id)anObject forKey:(NSString *)aKey {
    NSMutableDictionary *cacheDic = [NSMutableDictionary dictionaryWithContentsOfFile:[self listCachesFilePath]];
    if (!cacheDic) {
        cacheDic = [NSMutableDictionary dictionary];
    }
    [cacheDic setObject:anObject forKey:aKey];
    
    BOOL ret = [cacheDic writeToFile:[self listCachesFilePath] atomically:YES];
    
    return ret;
}

// 获取缓存数据列表
+ (NSArray *)cacheArrayForKey:(NSString *)aKey {
    NSMutableDictionary *cacheDic = [NSMutableDictionary dictionaryWithContentsOfFile:[self listCachesFilePath]];
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

+ (id)convertNullToEmptyString:(id)object {
    // 转空字符串
    if ([object isEqual:[NSNull null]] || [object isKindOfClass:[NSNull class]] || object==nil) {
        return @"";
    }
    return object;
}

+ (void)checkVersionUpdate {
    static NSString * kLastUpdateAlertDate = @"lastUpdateAlertDate";
    
    NSDate *lastAlertDate = [[NSUserDefaults standardUserDefaults] objectForKey:kLastUpdateAlertDate];
    
    NSDate *date = [NSDate date];
    
    NSTimeInterval interval = [date timeIntervalSinceDate:lastAlertDate];
    
    // 提醒频率为1天
    if (interval < 86400) {
        return;
    }
    
    static NSString * kIgnoredVersion = @"ignoredVersion";
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *jsonStr = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?id=%@", APP_ID_IN_APP_STORE]] encoding:NSUTF8StringEncoding error:nil];
        
        if (!jsonStr) return;
        
        NSDictionary *versionDict = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers error:nil];
        
        NSArray *arr = [versionDict objectForKey:@"results"];
        
        if (arr.count > 0) {
            NSDictionary *dic = arr.firstObject;
            
            NSString *latestVersion = [dic objectForKey:@"version"];
            
            if (!latestVersion) {
                return;
            }
            
            
            // 忽略版本
            NSString *ignoredVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kIgnoredVersion];
            
            NSString *localVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
            
            if (ignoredVersion && [localVersion compare:ignoredVersion options:NSNumericSearch] != NSOrderedAscending) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:kIgnoredVersion];
            }
            
            // 忽略版本与最新版比较
            if (ignoredVersion && [ignoredVersion compare:latestVersion options:NSNumericSearch] == NSOrderedSame) {
                return;
            }
            
            NSComparisonResult ret = [localVersion compare:latestVersion options:NSNumericSearch];
            
            if (ret == NSOrderedAscending) {
                // 更新
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIViewController *topController = [self topmostViewController];
                    
                    NSString *title = [NSString localizedStringWithFormat:NSLocalizedString(@"发现新版本(%@)", nil), latestVersion];
                    
                    NSMutableString *detail = [NSMutableString stringWithString:@"\n"];
                    
                    [detail appendString:[dic objectForKey:@"releaseNotes"]];
                    
                    NSString *url = [dic objectForKey:@"trackViewUrl"];
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:detail preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"立即更新" , nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                        }
                    }];
                    
                    UIAlertAction *skipAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"忽略此版本" , nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [[NSUserDefaults standardUserDefaults] setObject:latestVersion forKey:kIgnoredVersion];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"放弃更新" , nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kLastUpdateAlertDate];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }];
                    
                    [alert addAction:action];
                    [alert addAction:skipAction];
                    [alert addAction:cancelAction];
                    
                    [topController presentViewController:alert animated:YES completion:nil];
                });
                
            }
        }
        
    });
    
}

+ (UIImageView *)imageFromView:(UIView *)snapView {
    
    UIGraphicsBeginImageContextWithOptions(snapView.frame.size, NO, 0.0);
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    [snapView.layer renderInContext:context];
    
    UIImage* targetImage =UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImageView* imageView = [[UIImageView alloc]initWithImage:targetImage];
    
    imageView.frame= snapView.frame;
    
    return imageView;
    
}

/// 检测版本更新(适用企业应用)
+ (void)checkEnterpriseVersionUpdate {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:VERSION_INFO_URL]];
        NSString *latestVersion = [dic objectForKey:@"version"];
        
        if (!latestVersion) {
            return;
        }
        NSString *localVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        
        NSComparisonResult ret = [localVersion compare:latestVersion options:NSNumericSearch];
        
        if (ret == NSOrderedAscending) {
            // 更新
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *detail = [dic objectForKey:@"description"];
                
                detail = [detail stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
                
                NSString *url = [dic objectForKey:@"url"];
                
                UIViewController *topController = [self topmostViewController];
                
                NSString *title = [NSString localizedStringWithFormat:NSLocalizedString(@"发现新版本(%@)", nil),latestVersion];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:detail preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"立即更新" , nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                    }
                }];
                
                [alert addAction:action];
                
                [topController presentViewController:alert animated:YES completion:nil];
            });
            
        }
    });
    
}



@end
