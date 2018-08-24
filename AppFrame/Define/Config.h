//
//  Config.h
//  AppFrame
//
//  Created by icebrk on 2018/8/20.
//  Copyright © 2018年 Firebrk. All rights reserved.
//

#ifndef Config_h
#define Config_h

// MARK: ----- Environment -----

#define ONLINE 1 // 环境切换 线上1 线下0

#define HOST_ONLINE @""// 线上
#define HOST_OFFLINE @""// 线下

#define HOST_URL [NSString stringWithFormat:@"%@", HOST]

#if ONLINE
#define HOST HOST_ONLINE
#else
#define HOST HOST_OFFLINE
#endif


// MARK: ----- Static URL -----

// 用户协议
#define USER_PROTOCOL_URL @""



// MARK: ----- Platform Secret -----

// 友盟
static NSString * const UMENG_KEY = @"xxxxxx";

// 推送
static NSString * const JPUSH_KEY = @"xxxxxx";
static NSString * const JPUSH_SECRET = @"xxxxxx";

// 分享
static NSString * const MOB_KEY = @"xxxxxx";
static NSString * const MOB_SECRET = @"xxxxxx";

static NSString * const WECHAT_KEY = @"xxxxxx";
static NSString * const WECHAT_SECRET = @"xxxxxx";

static NSString * const QQ_KEY = @"xxxxxx";
static NSString * const QQ_SECRET = @"xxxxxx";

static NSString * const SINA_KEY = @"xxxxxx";
static NSString * const SINA_SECRET = @"xxxxxx";
static NSString * const SINA_REDIRECT_URI = @"xxxxxx";

// 支付
static NSString * const ALIPAY_KEY = @"xxxxxx";



// MARK: ----- ENUM -----








#endif /* Config_h */
