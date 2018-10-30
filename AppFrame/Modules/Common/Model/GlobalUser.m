//
//  GlobalUser.m
//  BTZC
//
//  Created by apple on 2018/9/14.
//  Copyright © 2018年 Ergu. All rights reserved.
//

#import "GlobalUser.h"
#import "CoreDataDAO.h"
#import <objc/runtime.h>

@implementation GlobalUser

+ (GlobalUser *)sharedInstance {
    static GlobalUser *user;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [self new];
    });
    
    return user;
}

+ (void)config {
    [CoreDataDAO configModel];
}

+ (void)parseModel:(NSManagedObject *)model {
    GlobalUser *user = [self sharedInstance];
    [user mj_setKeyValues:[model mj_JSONObject]];
}

+ (void)updateValue:(id)value forKey:(NSString *)key {
    if (value) {
        [[self sharedInstance] setValue:value forKey:key];
        [CoreDataDAO updateValue:value forKey:key];
    }
}

+ (void)clear {
    [CoreDataDAO deleteModel];
    [self clearSession];
    [self setNil];
    
}

+ (void)clearSession {
    NSData *cookieData = [USER_DEFAULTS objectForKey:kSession];
    if ([cookieData length]) {
        NSHTTPCookie *sessionCookie = [NSKeyedUnarchiver unarchiveObjectWithData:cookieData];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:sessionCookie];
    }
}

+ (BOOL)hasLogined {
    BOOL ret = NO;
    GlobalUser *user = [self sharedInstance];
    if ([user.userId isNotEmpty] && user.userId != nil) {
        ret = YES;
    }
    
    return ret;
}

+ (BOOL)validLoginStatus {
    BOOL ret = NO;
    NSDate *expiredDate = [USER_DEFAULTS objectForKey:kSessionExpiresDate];
    if (expiredDate) {
        NSComparisonResult comparisonResult = [expiredDate compare:[NSDate date]];
        ret = comparisonResult == NSOrderedDescending ? YES : NO;
    }
    
    return ret;
}

+ (void)setNil {
    // 获取当前类的所有属性
    unsigned int count;// 记录属性个数
    objc_property_t *properties = class_copyPropertyList(self, &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        // 获取属性的名称
        const char *nameChar = property_getName(property);
        NSString *name = [NSString stringWithCString:nameChar encoding:NSUTF8StringEncoding];
        // 获取属性类型
//        const char *typeChar = property_getAttributes(property);
//        NSString *type = [NSString stringWithCString:typeChar encoding:NSUTF8StringEncoding];
        
        [[self sharedInstance] setNilValueForKey:name];
    }
    free(properties);
    
}


- (void)setNilValueForKey:(NSString *)key {
    id value = [self valueForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        [self setValue:@"" forKey:key];
    } else if ([value isKindOfClass:[NSNumber class]]) {
        [self setValue:@0 forKey:key];
    } else if ([value isKindOfClass:[NSArray class]]) {
        if ([value isKindOfClass:[NSMutableArray class]]) {
            [self setValue:@[].mutableCopy forKey:key];
        } else {
            [self setValue:@[] forKey:key];
        }
    } else if ([value isKindOfClass:[NSDictionary class]]) {
        if ([value isKindOfClass:[NSMutableDictionary class]]) {
            [self setValue:@{}.mutableCopy forKey:key];
        } else {
            [self setValue:@{} forKey:key];
        }
    }
    
}

@end
