//
//  CYBaseCollectionViewController.m
//  nzny
//
//  Created by 男左女右 on 2016/11/19.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseCollectionViewController.h"

// cell
#import "CYLiveCollectionViewCell.h"

// 模型
#import "CYLiveCollectionViewCellModel.h"

#define cCollectionCellWidth ((340.0 / 750.0) * self.view.frame.size.width)
#define cCollectionCellHeight ((390.0 / 1334.0) * self.view.frame.size.height)
#define cCellMinLine ((20.0 / 750.0) * self.view.frame.size.width)
#define cCellMinInteritem ((20.0 / 1334.0) * self.view.frame.size.height)
#define cCellEdgeTop ((10.0 / 1334.0) * self.view.frame.size.height)
#define cCellEdgeLeft ((25.0 / 750.0) * self.view.frame.size.width)
#define cCellEdgeDown ((10.0 / 1334.0) * self.view.frame.size.height)
#define cCellEdgeRight ((25.0 / 750.0) * self.view.frame.size.width)

@interface CYBaseCollectionViewController ()

@end

@implementation CYBaseCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 加载数据
//    [self loadData];
    
    
    // 创建视图
    [self creatView];
    NSLog(@"collection 的 size.height%f",self.view.frame.size.height);
    
}

// 下拉刷新
- (void)refresh{
    
    _curPage = 1;
    
    [self loadData];
    
}

// 上拉加载
- (void)loadMore{
    
    _curPage++;
    
    [self loadData];
    
}

//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    
////    [self.baseCollectionView reloadData];
////    [self loadData];
//}


// 加载数据
- (void)loadData{
    
    NSArray *tempArr = @[
                       @{
                           @"liveBgImgName":@"默认头像",
                           @"liveStatusBgImgName":@"直播预告",
                           @"liveStatusTitle":@"预告",
                           @"liveTimeOrWatchNum":@"11/19 08:00",
                           @"genderImgName":@"女",
                           @"name":@"张小小",
                           @"liveTitle":@"# 预谋邂逅 #"
                           },
                       @{
                           @"liveBgImgName":@"默认头像",
                           @"liveStatusBgImgName":@"直播预告",
                           @"liveStatusTitle":@"预告",
                           @"liveTimeOrWatchNum":@"11/19 08:00",
                           @"genderImgName":@"女",
                           @"name":@"张小小",
                           @"liveTitle":@"# 预谋邂逅 #"
                           },
                       @{
                           @"liveBgImgName":@"默认头像",
                           @"liveStatusBgImgName":@"直播预告",
                           @"liveStatusTitle":@"预告",
                           @"liveTimeOrWatchNum":@"11/19 08:00",
                           @"genderImgName":@"女",
                           @"name":@"张小小",
                           @"liveTitle":@"# 预谋邂逅 #"
                           },
                       @{
                           @"liveBgImgName":@"默认头像",
                           @"liveStatusBgImgName":@"直播预告",
                           @"liveStatusTitle":@"预告",
                           @"liveTimeOrWatchNum":@"11/19 08:00",
                           @"genderImgName":@"女",
                           @"name":@"张小小",
                           @"liveTitle":@"# 预谋邂逅 #"
                           },
                       @{
                           @"liveBgImgName":@"默认头像",
                           @"liveStatusBgImgName":@"直播预告",
                           @"liveStatusTitle":@"预告",
                           @"liveTimeOrWatchNum":@"11/19 08:00",
                           @"genderImgName":@"女",
                           @"name":@"张小小",
                           @"liveTitle":@"# 预谋邂逅 #"
                           },
                       @{
                           @"liveBgImgName":@"默认头像",
                           @"liveStatusBgImgName":@"直播预告",
                           @"liveStatusTitle":@"预告",
                           @"liveTimeOrWatchNum":@"11/19 08:00",
                           @"genderImgName":@"女",
                           @"name":@"张小小",
                           @"liveTitle":@"# 预谋邂逅 #"
                           },
                       @{
                           @"liveBgImgName":@"默认头像",
                           @"liveStatusBgImgName":@"直播预告",
                           @"liveStatusTitle":@"预告",
                           @"liveTimeOrWatchNum":@"11/19 08:00",
                           @"genderImgName":@"女",
                           @"name":@"张小小",
                           @"liveTitle":@"# 预谋邂逅 #"
                           },
                       @{
                           @"liveBgImgName":@"默认头像",
                           @"liveStatusBgImgName":@"直播预告",
                           @"liveStatusTitle":@"预告",
                           @"liveTimeOrWatchNum":@"11/19 08:00",
                           @"genderImgName":@"女",
                           @"name":@"张小小",
                           @"liveTitle":@"# 预谋邂逅 #"
                           },
                       @{
                           @"liveBgImgName":@"默认头像",
                           @"liveStatusBgImgName":@"直播预告",
                           @"liveStatusTitle":@"预告",
                           @"liveTimeOrWatchNum":@"11/19 08:00",
                           @"genderImgName":@"女",
                           @"name":@"张小小",
                           @"liveTitle":@"# 预谋邂逅 #"
                           },
                       @{
                           @"liveBgImgName":@"默认头像",
                           @"liveStatusBgImgName":@"直播预告",
                           @"liveStatusTitle":@"预告",
                           @"liveTimeOrWatchNum":@"11/19 08:00",
                           @"genderImgName":@"女",
                           @"name":@"张小小",
                           @"liveTitle":@"# 预谋邂逅 #"
                           },
                       @{
                           @"liveBgImgName":@"默认头像",
                           @"liveStatusBgImgName":@"直播预告",
                           @"liveStatusTitle":@"预告",
                           @"liveTimeOrWatchNum":@"11/19 08:00",
                           @"genderImgName":@"女",
                           @"name":@"张小小",
                           @"liveTitle":@"# 预谋邂逅 #"
                           }
                       
                       
                       
                       
                       ];
    
    [self.dataArray addObjectsFromArray:[CYLiveCollectionViewCellModel arrayOfModelsFromDictionaries:tempArr]];
}

// 创建视图
- (void)creatView{
    
    
    // 创建一个网格布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    // 设置最小行间距
    flowLayout.minimumLineSpacing = cCellMinLine;
    
    
    // 设置最小列间距
    flowLayout.minimumInteritemSpacing = cCellMinInteritem;
    
    // 设置方向
    //    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    // 创建tableView
    CGRect tempFrame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - 59);
    _baseCollectionView = [[UICollectionView alloc] initWithFrame:tempFrame collectionViewLayout:flowLayout];
    
    _baseCollectionView.backgroundColor = [UIColor whiteColor];
    
    // 代理
    _baseCollectionView.delegate = self;
    _baseCollectionView.dataSource = self;
    
    
    
    
    // 添加到控制器
    [self.view addSubview:_baseCollectionView];
    
    
}

// 多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

// 每组几个
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

// collectionCell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    // 提前注册
    [_baseCollectionView registerNib:[UINib nibWithNibName:@"CYLiveCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"CYLiveCollectionViewCell"];
    
    CYLiveCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CYLiveCollectionViewCell" forIndexPath:indexPath];
    
//    cell.liveCellModel = [];
    
    
    // 假数据
    CYLiveCollectionViewCellModel *model = self.dataArray[indexPath.row];
    
    cell.liveCellModel = model;
    
    
    return cell;
    
}


// 设置cell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(cCollectionCellWidth, cCollectionCellHeight);
    
}

// 设置cell 的 边界距离
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    // 上、左、下、右
    return UIEdgeInsetsMake(cCellEdgeTop, cCellEdgeLeft, cCellEdgeDown, cCellEdgeRight);
}

//// cell：点击事件
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"点击了第 %ld 个collectionCell~~",indexPath.item);
//    
//    
//}

@end
