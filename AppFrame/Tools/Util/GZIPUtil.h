//
//  GZIPUtil.h
//  

#import <Foundation/Foundation.h>

@interface GZIPUtil : NSObject

// 数据压缩

+ (NSData *)compressData:(NSData*)uncompressedData;

// 数据解压缩

+ (NSData *)decompressData:(NSData *)compressedData;

@end
