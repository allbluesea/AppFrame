//
//  WebSocketUtil.m
//  AppFrame
//
//  Created by icebrk on 2018/8/20.
//  Copyright © 2018年 Firebrk. All rights reserved.
//

#import "WebSocketUtil.h"
#import "GZIPUtil.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>

NSString * const SocketURL = @"ws://xxx/webSocket";

static NSUInteger const MAX_RECONNECT_COUNT = 4;///< 最大重连次数

@interface WebSocketUtil () <SRWebSocketDelegate>

@property (nonatomic, assign) NSUInteger reconnectCount;///< 重连次数

@end

@implementation WebSocketUtil

+ (instancetype)sharedUtil {
    static WebSocketUtil *util;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        util = [self new];
    });
    
    return util;
}

- (instancetype)init {
    if (self = [super init]) {
        self.reconnectCount = 0;
    }
    
    return self;
}

- (SRReadyState)wsState {
    return self.webSocket.readyState;
}

#pragma mark - Public

- (void)openWebSocketWithURL:(id)url {
    if (!url) return;
    
    NSURL *wsURL = url;
    if ([url isKindOfClass:NSString.class]) {
        wsURL = [NSURL URLWithString:url];
    }
    
    if ([self.webSocket.url.absoluteString isEqualToString:wsURL.absoluteString] && self.webSocket.readyState == SR_OPEN) return;
    
    [self closeWebSocket];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:wsURL];
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:request];
    _webSocket.delegate = self;
    [_webSocket open];
}

- (void)closeWebSocket {
    if (self.webSocket) {
        [self.webSocket close];
        self.webSocket = nil;
    }
}

- (void)reconnectWebSocket {
    // 无调用层不重连
    if (!self.delegate) return;
    
    // 无网络时不重连
    [NetworkManager monitorNetworkStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusUnknown || status == AFNetworkReachabilityStatusNotReachable) {
            return;
        }
        
        // 尝试重连
        NSLog(@"ws try to reconnect...")
        
        if (self.reconnectCount + 1 > MAX_RECONNECT_COUNT) {
            NSLog(@"ws reconnect failed...")
            return;
        }
        
        dispatch_time_t time = pow(2, self.reconnectCount);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSURL *url = self.webSocket.url;
            [self closeWebSocket];
            [self openWebSocketWithURL:url];
        });
        
        self.reconnectCount++;
    }];
}

- (void)send:(id)data {
    if (self.webSocket.readyState == SR_OPEN) {
        [self.webSocket send:data];
    }
}

#pragma mark - SRWebSocketDelegate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSData *normalData = [GZIPUtil decompressData:message];
    NSDictionary *msgDict = [normalData mj_JSONObject];
    if ([msgDict.allKeys containsObject:@"ping"]) {// 心跳处理
        NSString *pongStr = [NSString stringWithFormat:@"{\"pong\": %@}", msgDict[@"ping"]];
        [webSocket send:pongStr];
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(webSocket:didReceiveWebSocketMessage:)]) {
            [self.delegate webSocket:webSocket didReceiveWebSocketMessage:msgDict];
        }
    }
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"ws did open");
    self.reconnectCount = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didOpenWebSocket:)]) {
        [self.delegate didOpenWebSocket:webSocket];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"ws error: %@, status %ld", error.localizedDescription, webSocket.readyState);
    [self reconnectWebSocket];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"ws close, reason %@(%ld)", reason, code);
    if (code == SRStatusCodeUnhandledType) {
        [self reconnectWebSocket];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    NSLog(@"ws received pong: %@", [[NSString alloc] initWithData:pongPayload encoding:NSUTF8StringEncoding]);
}



@end
