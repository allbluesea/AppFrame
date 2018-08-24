////
//  NSDictionary+ValuePath.m
//  Aloha
//
//  Created by Joe on 12-9-19.
//
//

#import "NSDictionary+ValuePath.h"

@implementation NSDictionary(ValuePath)



- (NSInteger)integerValue:(NSString *)path {
    return [self integerValue:path default:0];
}

- (NSInteger)integerValue:(NSString *)path default:(NSInteger)defValue {
    NSObject* obj = [self valueForKeyPath:path];
    if ([obj isKindOfClass:[NSNumber class]])
        return [(NSNumber*)obj integerValue];
    else if ([obj isKindOfClass:[NSString class]])
        return [(NSString*)obj integerValue];
    else
        return defValue;
}

- (float)floatValue:(NSString*)path
{
    return [self floatValue:path default:0.0];
}

- (float)floatValue:(NSString*)path default:(float)defValue
{
    NSObject* obj = [self valueForKeyPath:path];
    if ([obj isKindOfClass:[NSNumber class]])
        return [(NSNumber*)obj floatValue];
    else if ([obj isKindOfClass:[NSString class]])
    {
        return [(NSString*)obj floatValue];
    }
    else
        return defValue;
}

- (NSString*)strValue:(NSString*)path {
    return [self strValue:path default:@""];
}

- (NSString*)strValue:(NSString*)path default:(NSString*)defValue {
    NSObject* obj = [self valueForKeyPath:path];
    if ([obj isKindOfClass:[NSNumber class]])
        return [(NSNumber*)obj stringValue];
    else if ([obj isKindOfClass:[NSString class]])
        return (NSString*)obj;
    else
        return defValue;
}

- (NSArray *)arrayValue:(NSString *)path
{
    NSObject* obj = [self valueForKeyPath:path];
    if(obj && [obj isKindOfClass:[NSArray class]])
    {
        return (NSArray *)obj;
    }
    return nil;
}

- (NSDictionary *)dictionaryValue:(NSString *)path
{
    NSObject* obj = [self valueForKeyPath:path];
    if(obj && [obj isKindOfClass:[NSDictionary class]])
    {
        return (NSDictionary *)obj;
    }
    return nil;
}

@end
