//
//  CoreDataDAO.m
//
//
//
//  Open the comments after you create the data model.

#import "CoreDataDAO.h"
#import "CoreDataManager.h"
//#import "User+CoreDataClass.h"
#import "GlobalUser.h"
#import <MJExtension.h>

#define CD_MANAGER [CoreDataManager sharedManager]

NSString * const UserEntity = @"User";
NSString * const UserID = @"userid";

@implementation CoreDataDAO

+ (BOOL)insertModelWithDictionary:(NSDictionary *)dict {
    if (!dict) {
        return NO;
    }

    NSString *condition = [NSString stringWithFormat:@"%@==%@", UserID, [dict objectForKey:UserID]];
    NSArray *arr = [self queryWithCondition:condition];
    // 去重处理...
    if (arr.count > 0) {
        [self deleteModelWithCondition:condition];
    }
    
    // TODO: Open the comments after you create the data model
    /*
    User *user = [NSEntityDescription insertNewObjectForEntityForName:UserEntity inManagedObjectContext:CD_MANAGER.managedObjectContext];
    [user mj_setKeyValues:dict];

    [GlobalUser parseModel:user];
    */
    
    NSError *err;
    BOOL ret = [CD_MANAGER.managedObjectContext save:&err];
    if (!ret) {
        NSLog(@"Coredata insert err: %@", err.localizedDescription);
    }
    return ret;
}

+ (NSArray *)queryWithCondition:(NSString *)condition {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:UserEntity inManagedObjectContext:CD_MANAGER.managedObjectContext];
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:entityDescription.name];
    // 设置查询条件
    if (condition) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:condition];
        [req setPredicate:predicate];
    }
    
    NSError *err;
    NSArray *list = [CD_MANAGER.managedObjectContext executeFetchRequest:req error:&err];
    if (err) {
        NSLog(@"Coredata query err: %@", err.localizedDescription);
    }
    return list;
}

+ (void)deleteModelWithCondition:(NSString *)condition {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:UserEntity inManagedObjectContext:CD_MANAGER.managedObjectContext];
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:entityDescription.name];
    // 设置查询条件
    if (condition) {
        @try {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:condition];
            [req setPredicate:predicate];
        } @catch (NSException *exception) {
            return;
        }
    }
    
    NSError *err;
    NSArray *list = [CD_MANAGER.managedObjectContext executeFetchRequest:req error:&err];
    for (NSManagedObject *object in list) {
        [CD_MANAGER.managedObjectContext deleteObject:object];
    }
    [CD_MANAGER.managedObjectContext save:&err];
}

+ (void)deleteModel {
    [self deleteModelWithCondition:[NSString stringWithFormat:@"%@==%@", UserID, [GlobalUser sharedInstance].userId]];
}

+ (BOOL)updateValue:(id)value forKey:(NSString *)key {
    if ([value isKindOfClass:[NSString class]]) {
        if (!value) {
            return NO;
        }
    }
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:UserEntity inManagedObjectContext:CD_MANAGER.managedObjectContext];
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:entityDescription.name];
    // 设置查询条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@==%@", UserID, [GlobalUser sharedInstance].userId]];
    [req setPredicate:predicate];
    NSError *err;
    NSArray *list = [CD_MANAGER.managedObjectContext executeFetchRequest:req error:&err];
    if (list.count <= 0) {
        return NO;
    }
    NSManagedObject *object = list.lastObject;
    @try {
        //更新后要进行保存，否则没更新
        if ([[object valueForKey:key] isKindOfClass:[NSString class]]) {
            [object setValue:value forKey:key];
        } else {
            [object setValue:value forKey:key];
        }
    } @catch (NSException *exception) {
        //未赋值之前[object valueForKey:key]有可能为nil，将会crash
        NSLog(@"Coredata update err: %@", exception.reason);
        return NO;
    }
    
    BOOL ret = [CD_MANAGER.managedObjectContext save:&err];
    if (!ret) {
        NSLog(@"Coredata update err: %@", err.localizedDescription);
    }
    
    return ret;
}

+ (void)configModel {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:UserEntity inManagedObjectContext:CD_MANAGER.managedObjectContext];
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:entityDescription.name];
    NSError *err;
    NSArray *list = [CD_MANAGER.managedObjectContext executeFetchRequest:req error:&err];
    // TODO: Open the comments after you create the data model
//    User *user = list.lastObject;
//    [GlobalUser parseModel:user];
}


@end
