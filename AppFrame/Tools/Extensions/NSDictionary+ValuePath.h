//
//  NSDictionary+ValuePath.h
//  Aloha
//
//  Created by Joe on 12-9-19.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ValuePath)

- (NSInteger)integerValue:(NSString*)path;
- (NSInteger)integerValue:(NSString*)path default:(NSInteger)defValue;

- (float)floatValue:(NSString*)path;
- (float)floatValue:(NSString*)path default:(float)defValue;

- (NSString*)strValue:(NSString*)path;
- (NSString*)strValue:(NSString*)path default:(NSString*)defValue;

- (NSArray *)arrayValue:(NSString *) path;
- (NSDictionary *)dictionaryValue:(NSString *)path;

@end


