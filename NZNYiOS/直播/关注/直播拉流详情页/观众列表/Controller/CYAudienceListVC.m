//
//  CYAudienceListVC.m
//  nzny
//
//  Created by 男左女右 on 2016/12/18.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYAudienceListVC.h"

//cell模型
#import "CYAudienceListCellModel.h"


#define cCollectionCellWidth ((340.0 / 750.0) * cScreen_Width)
#define cCollectionCellHeight ((390.0 / 1334.0) * cScreen_Height)
#define cCellMinLine ((20.0 / 750.0) * cScreen_Width)
#define cCellMinInteritem ((20.0 / 1334.0) * cScreen_Height)
#define cCellEdgeTop ((10.0 / 1334.0) * cScreen_Height)
#define cCellEdgeLeft ((25.0 / 750.0) * cScreen_Width)
#define cCellEdgeDown ((10.0 / 1334.0) * cScreen_Height)
#define cCellEdgeRight ((25.0 / 750.0) * cScreen_Width)

@interface CYAudienceListVC ()

@end

@implementation CYAudienceListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 加载数据
//    [self loadData];
    
    // 添加视图
//    [self addView];
    
    // 背景颜色
    self.view.backgroundColor = [UIColor redColor];
    // 背景颜色
    self.baseCollectionView.backgroundColor = [UIColor cyanColor];
    
    // 提前注册
//    [self.baseCollectionView registerNib:[UINib nibWithNibName:@"CYAudienceListCell" bundle:nil] forCellWithReuseIdentifier:@"CYAudienceListCell"];
    
}


//// 加载数据
//- (void)loadData{
//    
//    NSArray *tempArr = @[
//                         @{
//                             @"LiveId":@"112",
//                             @"UserId":@"112",
//                             @"Portrait":@"117.jpg"
//                             },
//                         @{
//                             @"LiveId":@"113",
//                             @"UserId":@"113",
//                             @"Portrait":@"117.jpg"
//                             },
//                         @{
//                             @"LiveId":@"111",
//                             @"UserId":@"111",
//                             @"Portrait":@"117.jpg"
//                             },
//                         @{
//                             @"LiveId":@"1141",
//                             @"UserId":@"114",
//                             @"Portrait":@"117.jpg"
//                             },
//                         
//                         
//                         ];
//    [self.dataArray removeAllObjects];
//    [self.dataArray addObjectsFromArray:[CYAudienceListCellModel arrayOfModelsFromDictionaries:tempArr]];
//}
//
// 创建视图
- (void)creatView{
    
    
    // 创建一个网格布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    // 设置最小行间距
    flowLayout.minimumLineSpacing = cCellMinLine;
    
    
    // 设置最小列间距
    flowLayout.minimumInteritemSpacing = cCellMinInteritem;
    
    // 设置方向：Horizontal：水平滑动
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    // 创建tableView
    CGRect tempFrame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height - 59);
    self.baseCollectionView = [[UICollectionView alloc] initWithFrame:tempFrame collectionViewLayout:flowLayout];
    
    self.baseCollectionView.backgroundColor = [UIColor whiteColor];
    
    // 代理
    self.baseCollectionView.delegate = self;
    self.baseCollectionView.dataSource = self;
    
    
    // 添加到控制器
    [self.view addSubview:self.baseCollectionView];
    
    
}
//
//// 多少组
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    
//    return 1;
//}
//
//// 每组几个
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    
//    return self.dataArray.count;
//}
//
//// collectionCell
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    
//    
//    
//    CYAudienceListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CYAudienceListCell" forIndexPath:indexPath];
//    
//    
//    // 假数据
//    cell.audienceListCellModel = self.dataArray[indexPath.row];
//    
//    
//    return cell;
//    
//}
//
//
//// 设置cell 的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return CGSizeMake(cCollectionCellWidth, cCollectionCellHeight);
//    
//}
//
//// 设置cell 的 边界距离
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    
//    // 上、左、下、右
////    return UIEdgeInsetsMake(cCellEdgeTop, cCellEdgeLeft, cCellEdgeDown, cCellEdgeRight);
//    return UIEdgeInsetsMake(0, cCellEdgeLeft, 0, cCellEdgeRight);
//}


@end
