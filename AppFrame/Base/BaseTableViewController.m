//
//  BaseTableViewController.m
//  AppFrame
//
//  Created by icebrk on 2018/8/20.
//  Copyright © 2018年 Firebrk. All rights reserved.
//

#import "BaseTableViewController.h"
#import "UIScrollView+EmptyDataSet.h"

NSString * const DefaultCellIdentifier = @"Cell";
NSString * const DefaultHeaderIdentifier = @"Header";
static NSUInteger const REQUEST_PAGE_SIZE = 10;

@interface BaseTableViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, assign) BOOL showsEmptyDataView;

@end

@implementation BaseTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataArray = [NSMutableArray array];
    _parameters = [[NSMutableDictionary alloc] init];
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, NAV_STATUS_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_STATUS_HEIGHT)
                                          style:UITableViewStyleGrouped];
    _table.backgroundColor = BG_COLOR;
    _table.separatorColor = SEPARATOR_COLOR;
    _table.dataSource = self;
    _table.delegate = self;
    _table.estimatedRowHeight = 0;
    _table.estimatedSectionHeaderHeight = 0;
    _table.estimatedSectionFooterHeight = 0;
    _table.emptyDataSetSource = self;
    _table.emptyDataSetDelegate = self;
    if (@available(iOS 11.0, *)) {
        _table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTableData)];
    header.automaticallyChangeAlpha = YES;
    _table.mj_header = header;
    _table.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTableData)];
    
    [self.view addSubview:_table];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    if ([_table respondsToSelector:@selector(setLayoutMargins:)]) {
        [_table setLayoutMargins:SEPARATOR_INSET];
    }
    
    if ([_table respondsToSelector:@selector(setSeparatorInset:)]) {
        [_table setSeparatorInset:SEPARATOR_INSET];
    }
}


#pragma mark - HTTP

- (void)loadNewTableData {
    _page = 1;
    [self loadList];
    [self loadOtherData];
}

- (void)loadMoreTableData {
    _page ++;
    [self loadList];
    
}

- (void)loadList {
    if (!_unpaged) {
        [self.parameters setObject:@(_page) forKey:@"pageNum"];
        [self.parameters setObject:@(REQUEST_PAGE_SIZE) forKey:@"pageSize"];
    }
}

- (void)loadOtherData {}

- (void)loadCaches:(NSArray *)arr {
    [self loadCaches:arr withModelName:nil];
}

- (void)loadCaches:(NSArray *)arr withModelName:(NSString *)modelName {
    [self loadCaches:arr withModelClass:NSClassFromString(modelName)];
}

- (void)loadCaches:(NSArray *)arr withModelClass:(Class)modelClass {
    if (arr.count > 0) {
        if (modelClass) {
            for (NSDictionary *dict in arr) {
                id model = [modelClass mj_objectWithKeyValues:dict];
                [self.dataArray addObject:model];
            }
        } else {
            [self.dataArray addObjectsFromArray:arr];
        }
    }
}

- (void)successHandler:(NSArray *)arr modelName:(NSString *)modelName {
    [self successHandler:arr modelClass:NSClassFromString(modelName)];
}

- (void)successHandler:(NSArray *)arr modelClass:(Class)modelClass {
    if (!self.showsEmptyDataView) {
        self.showsEmptyDataView = YES;
        [self.table reloadEmptyDataSet];
    }
    if ([self.table.mj_header isRefreshing]) [self.table.mj_header endRefreshing];
    if ([self.table.mj_footer isRefreshing]) [self.table.mj_footer endRefreshing];
    if (!_unpaged) {
        self.table.mj_footer.hidden = arr.count >= REQUEST_PAGE_SIZE ? NO : YES;
    }
    if (self.dataArray.count > 0 && self.page == 1) {
        [self.dataArray removeAllObjects];
    }
    for (NSDictionary *dict in arr) {
        id model = [modelClass mj_objectWithKeyValues:dict];
        [self.dataArray addObject:model];
    }
    [self.table reloadData];
}

- (void)successHandler:(NSArray *)arr {
    if (!self.showsEmptyDataView) {
        self.showsEmptyDataView = YES;
        [self.table reloadEmptyDataSet];
    }
    if ([self.table.mj_header isRefreshing]) [self.table.mj_header endRefreshing];
    if ([self.table.mj_footer isRefreshing]) [self.table.mj_footer endRefreshing];
    if (!_unpaged) {
        self.table.mj_footer.hidden = arr.count >= REQUEST_PAGE_SIZE ? NO : YES;
    }
    if (self.dataArray.count > 0 && self.page == 1) {
        [self.dataArray removeAllObjects];
    }
    [self.dataArray addObjectsFromArray:arr];
    [self.table reloadData];
}

- (void)failedHandler:(NSString *)errMsg {
    if (!self.showsEmptyDataView) {
        self.showsEmptyDataView = YES;
        [self.table reloadEmptyDataSet];
    }
    if ([self.table.mj_header isRefreshing]) [self.table.mj_header endRefreshing];
    if ([self.table.mj_footer isRefreshing]) [self.table.mj_footer endRefreshing];
    if (!_unpaged && self.dataArray.count == 0) {
        self.table.mj_footer.hidden = YES;
    }
    [self showMessage:errMsg];
}

- (void)startRefreshing {
    [self.table.mj_header beginRefreshing];
}

// MARK: UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return WHITESPACE_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:SEPARATOR_INSET];
    }
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:SEPARATOR_INSET];
    }
}


// MARK: DZNEmptyDataSet

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"common_default_empty"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title = @"暂无内容";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    [paragraph setLineSpacing:3.0f];
    NSDictionary *attrs = @{NSFontAttributeName: FONT(13),
                            NSForegroundColorAttributeName: [UIColor black99],
                            NSParagraphStyleAttributeName: paragraph};
    
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:title
                                                                  attributes:attrs];
    
    return attrStr;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -50;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return 30;
}

//是否显示空白页，默认YES
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return self.showsEmptyDataView;
}

//是否允许点击，默认YES
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}

//是否允许滚动，默认NO
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

//点击空数据页面
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view {
    [self loadNewTableData];
}


// MARK: Method

- (void)registerCellNib:(NSString *)nibName {
    [_table registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:DefaultCellIdentifier];
}

- (void)registerCellNib:(NSString *)nibName forIdentifier:(NSString *)identifier {
    [_table registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:identifier];
}

- (void)registerCellClass:(NSString *)className {
    [_table registerClass:NSClassFromString(className) forCellReuseIdentifier:DefaultCellIdentifier];
}

- (void)registerHeaderNib:(NSString *)nibName {
    [_table registerNib:[UINib nibWithNibName:nibName bundle:nil] forHeaderFooterViewReuseIdentifier:DefaultHeaderIdentifier];
}

- (void)registerHeaderClass:(NSString *)className {
    [_table registerClass:NSClassFromString(className) forHeaderFooterViewReuseIdentifier:DefaultHeaderIdentifier];
}

- (void)hidesSeparatorLine {
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)hidesTableHeader {
    [self.table.mj_header setHidden:YES];
}

- (void)hidesTableFooter {
    [self.table.mj_footer setHidden:YES];
}

- (void)hidesTableRefresh {
    [self.table.mj_header setHidden:YES];
    [self.table.mj_footer setHidden:YES];
}

// MARK: Setter
- (void)setUnpaged:(BOOL)unpaged {
    _unpaged = unpaged;
    if (unpaged) {
        [self hidesTableFooter];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
