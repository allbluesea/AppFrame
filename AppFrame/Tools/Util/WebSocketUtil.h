//
//  WebSocketUtil.h
//  AppFrame
//
//  Created by icebrk on 2018/8/20.
//  Copyright © 2018年 Firebrk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SocketRocket/SRWebSocket.h>

FOUNDATION_EXTERN NSString * const SocketURL;///< websocket

@protocol WebSocketUtilDelegate <NSObject>

/// websocket已打开
- (void)didOpenWebSocket:(SRWebSocket *)webSocket;
/// 接收websocket msg
- (void)webSocket:(SRWebSocket *)webSocket didReceiveWebSocketMessage:(id)message;


@end


@interface WebSocketUtil : NSObject


/** 单例 */
+ (instancetype)sharedUtil;

@property (nonatomic, strong) SRWebSocket *webSocket;

/** 代理 */
@property (nonatomic, weak) id<WebSocketUtilDelegate> delegate;

/** WebSocket状态 */
@property (nonatomic, readonly) SRReadyState wsState;

/**
 打开webSocket

 @param url URL or string
 */
- (void)openWebSocketWithURL:(id)url;

/**
 关闭webSocket
 */
- (void)closeWebSocket;

/**
 重连webSocket
 */
- (void)reconnectWebSocket;

/**
 发送数据
 */
- (void)send:(id)data;

@end


