//
//  CYBaseCollectionViewController.h
//  nzny
//
//  Created by 男左女右 on 2016/11/19.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseViewController.h"

// 下拉刷新下拉加载
#import "MJRefresh.h"

@interface CYBaseCollectionViewController : CYBaseViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


// collectionView
@property (nonatomic, strong) UICollectionView *baseCollectionView;


// 页码
@property (nonatomic,assign)NSInteger curPage;


// 下拉刷新
- (void)refresh;

// 上拉加载
- (void)loadMore;


// 创建视图
- (void)creatView;

// 加载数据
- (void)loadData;


@end
