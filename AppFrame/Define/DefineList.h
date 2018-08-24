//
//  DefineList.h
//  AppFrame
//
//  Created by icebrk on 2018/8/20.
//  Copyright © 2018年 Firebrk. All rights reserved.
//


#ifndef DefineList_h
#define DefineList_h

#import <Foundation/Foundation.h>

// URL打印模式 0不打印 1打印
#define DEBUG_URL_MODE 0

// DEBUG打印模式
#ifndef __OPTIMIZE__
#define NSLog(...) printf("%f %s\n",[[NSDate date] timeIntervalSince1970],[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);
#else
#define NSLog(...)
#endif


// MARK: ----- Key -----

// app是否是第一次安装
#define INSTALLED [NSString stringWithFormat:@"%@-installed",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]]
static NSString * const kUserNotFoundId = @"-999"; // 用户不存在


// MARK:----- 单例 -----


// GlobalUser

// NSUserDefault
#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]
// NSFileManager
#define FILE_MANAGER [NSFileManager defaultManager]
// NSNotificationCenter
#define NOTI_CENTER [NSNotificationCenter defaultCenter]

#endif /* DefineList_h */
