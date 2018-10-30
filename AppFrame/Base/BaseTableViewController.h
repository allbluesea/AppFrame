//
//  BaseTableViewController.h
//  AppFrame
//
//  Created by icebrk on 2018/8/20.
//  Copyright © 2018年 Firebrk. All rights reserved.
//

#import "BaseViewController.h"

FOUNDATION_EXTERN NSString * const DefaultCellIdentifier;
FOUNDATION_EXTERN NSString * const DefaultHeaderIdentifier;

@interface BaseTableViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

/**
 table
 */
@property (nonatomic, strong) UITableView *table;

/**
 分页
 */
@property (nonatomic, assign) NSInteger page;

/**
 数据源
 */
@property (nonatomic, strong) NSMutableArray *dataArray;

/**
 请求参数
 */
@property (nonatomic, strong) NSMutableDictionary *parameters;

/**
 未分页，默认为NO
 */
@property (nonatomic, assign) BOOL unpaged;


/**
 加载列表数据
 */
- (void)loadList;

/**
 加载其他数据
 */
- (void)loadOtherData;

/**
 加载新列表数据
 */
- (void)loadNewTableData;

/**
 成功handler
 
 @param arr 数据源
 */
- (void)successHandler:(NSArray *)arr;

/**
 成功handler
 
 @param arr 数据源
 @param modelName 类名
 */
- (void)successHandler:(NSArray *)arr modelName:(NSString *)modelName;

/**
 成功handler
 
 @param arr 数据源
 @param modelClass 类
 */
- (void)successHandler:(NSArray *)arr modelClass:(Class)modelClass;

/**
 失败handler
 
 @param errMsg 错误信息
 */
- (void)failedHandler:(NSString *)errMsg;


/**
 加载缓存数据
 
 @param arr 缓存数据
 */
- (void)loadCaches:(NSArray *)arr;

/**
 加载缓存数据
 
 @param arr 缓存数据
 @param modelName 模型
 */
- (void)loadCaches:(NSArray *)arr withModelName:(NSString *)modelName;

/**
 加载缓存数据
 
 @param arr 缓存数据
 @param modelClass 类
 */
- (void)loadCaches:(NSArray *)arr withModelClass:(Class)modelClass;

/**
 开始刷新 （调用下拉刷新方法）
 */
- (void)startRefreshing;

/**
 注册cellNib
 
 @param nibName cellNib名
 */
- (void)registerCellNib:(NSString *)nibName;

/**
 注册cellNib
 
 @param nibName cellNib名
 @param identifier 标识
 */
- (void)registerCellNib:(NSString *)nibName forIdentifier:(NSString *)identifier;

/**
 注册cellClass
 
 @param className cell类名
 */
- (void)registerCellClass:(NSString *)className;

/**
 注册headerNib
 
 @param nibName headerNib名
 */
- (void)registerHeaderNib:(NSString *)nibName;

/**
 注册headerClass
 
 @param className header类名
 */
- (void)registerHeaderClass:(NSString *)className;

/**
 隐藏分割线
 */
- (void)hidesSeparatorLine;

/**
 隐藏刷新头部
 */
- (void)hidesTableHeader;

/**
 隐藏刷新底部
 */
- (void)hidesTableFooter;

/**
 隐藏刷新
 */
- (void)hidesTableRefresh;

@end
