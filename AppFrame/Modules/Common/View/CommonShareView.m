//
//  CommonShareView.m
//  BTZC
//
//  Created by apple on 2018/9/12.
//  Copyright © 2018年 Ergu. All rights reserved.
//

#import "CommonShareView.h"




@interface ShareItemCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *itemImgv;
@property (nonatomic, strong) UILabel *nameLbl;

@end

@implementation ShareItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _itemImgv = [[UIImageView alloc] init];
        _itemImgv.frame = CGRectMake((CGRectGetWidth(frame) - 50) / 2.f, 0, 50, 50);
        [self.contentView addSubview:_itemImgv];
        
        _nameLbl = [[UILabel alloc] init];
        _nameLbl.frame = CGRectMake(0, CGRectGetHeight(frame) - 15, CGRectGetWidth(frame), 15);
        _nameLbl.font = FONT(12);
        _nameLbl.textAlignment = NSTextAlignmentCenter;
        _nameLbl.textColor = [UIColor black99];
        [self.contentView addSubview:_nameLbl];
        
    }
    return self;
}




@end


// 列数
static NSInteger Columns = 4;
// 横向和纵向的间距
static CGFloat Interval = 15.f;
static NSString * const ItemIdentifier = @"Item";
static NSString * const kName = @"name";
static NSString * const kImg = @"img";

@interface CommonShareView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, copy) NSArray *platformInfos;

@end

@implementation CommonShareView

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [self.class preferredHeight])];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        // 分享
        UILabel *titleLbl = [[UILabel alloc] init];
        titleLbl.frame = CGRectMake(0, 15, CGRectGetWidth(frame), 15);
        titleLbl.font = FONT(15);
        titleLbl.textAlignment = NSTextAlignmentCenter;
        titleLbl.textColor = [UIColor black33];
        titleLbl.text = @"分享";
        [self addSubview:titleLbl];
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemWidth = (self.bounds.size.width - (Columns + 1) * Interval) / Columns;
        CGFloat itemHeight = 50 + 10 + 15;
        flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
        flowLayout.sectionInset = UIEdgeInsetsZero;
        flowLayout.minimumLineSpacing = Interval;
        flowLayout.minimumInteritemSpacing = Interval;
//        flowLayout.headerReferenceSize = CGSizeMake(self.bounds.size.width, 50);
        
        // 分享平台
        _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLbl.frame) + 30, CGRectGetWidth(frame), CGRectGetHeight(frame) - 60 - 45) collectionViewLayout:flowLayout];
        _collection.showsHorizontalScrollIndicator = false;
        _collection.backgroundColor = [UIColor clearColor];
        [_collection registerClass:[ShareItemCell class] forCellWithReuseIdentifier:ItemIdentifier];
        _collection.delegate = self;
        _collection.dataSource = self;
        [self addSubview:_collection];
        
        // 分割线
        UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(12, CGRectGetHeight(frame) - 45.f, CGRectGetWidth(frame) - 2 * 12.f, 0.5)];
        separatorLine.backgroundColor = LINE_COLOR;
        [self addSubview:separatorLine];
        
        // 取消
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, CGRectGetMinY(separatorLine.frame), CGRectGetWidth(frame), 45);
        cancelBtn.backgroundColor = [UIColor clearColor];
        cancelBtn.titleLabel.font = FONT(15);
        [cancelBtn setTitleColor:[UIColor blue] forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
    }
    return self;
}

+ (CGFloat)preferredHeight {
    return 15 + 15 + 30 + 50 + 10 + 15 + 15 + 45;
}

#pragma mark - Action

- (void)cancelBtnClick:(UIButton *)sender {
    !self.cancelActionHandler ?: self.cancelActionHandler();
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.platformInfos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShareItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemIdentifier forIndexPath:indexPath];
    NSDictionary *dic = self.platformInfos[indexPath.item];
    cell.itemImgv.image = [UIImage imageNamed:[dic objectForKey:kImg]];
    cell.nameLbl.text = [dic objectForKey:kName];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    !self.didSelectedPlatformHandler ?: self.didSelectedPlatformHandler([self UMSocialPlatformTypeForIndexPath:indexPath]);
}

- (NSArray *)platformInfos {
    if (!_platformInfos) {
        // @{kName: @"QQ空间", kImg: @"common_share_qzone"}
        _platformInfos = @[@{kName: @"微信好友", kImg: @"common_share_wechat_session"},
                           @{kName: @"朋友圈", kImg: @"common_share_wechat_timeline"},
                           @{kName: @"QQ好友", kImg: @"common_share_qq"},
                           @{kName: @"新浪微博", kImg: @"common_share_weibo"}];
        

    }
    
    return _platformInfos;
}

/*
- (UMSocialPlatformType)UMSocialPlatformTypeForIndexPath:(NSIndexPath *)indexPath {
    UMSocialPlatformType type = UMSocialPlatformType_UnKnown;
    switch (indexPath.item) {
        case 0:
            type = UMSocialPlatformType_WechatSession;
            break;
        case 1:
            type = UMSocialPlatformType_WechatTimeLine;
            break;
        case 2:
            type = UMSocialPlatformType_QQ;
            break;
        case 3:
            type = UMSocialPlatformType_Sina;
            break;
        default:
            break;
    }
    
    return type;
}
*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
