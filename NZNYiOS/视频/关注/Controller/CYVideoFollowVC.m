//
//  CYVideoFollowVC.m
//  nzny
//
//  Created by 男左女右 on 2016/11/22.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYVideoFollowVC.h"

// 视频cell模型
#import "CYVideoCollectionViewCellModel.h"

@interface CYVideoFollowVC ()

@end

@implementation CYVideoFollowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 背景颜色
//    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.00];
    self.baseCollectionView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.00];
    
}

- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
    
    
    // tabbar：显示
//    self.parentViewController.parentViewController.parentViewController.hidesBottomBarWhenPushed = NO;
    
    // cell Header重新加载：自带加载数据
    [self.baseCollectionView.header beginRefreshing];
    // 加载数据
//    [self loadData];

}



// 加载数据
- (void)loadData{
    
    
    NSDictionary *params = @{
                             @"userId":self.onlyUser.userID,
                             @"pageNum":@(self.curPage),
                             @"pageSize":@(10)
                             };
    
    // 网络请求：主视频关注界面
    [CYNetWorkManager getRequestWithUrl:cFollowsVideoListUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取主视频关注界面进度：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"主视频关注界面：请求成功！");
        
        // 停止刷新
        [self.baseCollectionView.header endRefreshing];
        [self.baseCollectionView.footer endRefreshing];
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"主视频关注界面：获取成功！：%@",responseObject);
            
            // 清空：每次刷新都需要：但是上拉加载、下拉刷新的不需要；
            if (self.curPage == 1) {
                
                [self.dataArray removeAllObjects];
            }
            
            
            // 先把没有数据label删除
            [self.noDataLab removeFromSuperview];
            
            
            
            // 解析数据，模型存到数组
            [self.dataArray addObjectsFromArray:[CYVideoCollectionViewCellModel arrayOfModelsFromDictionaries:responseObject[@"res"][@"data"][@"list"]]];
            
            if (self.dataArray.count == 0) {
                
                // 如果没有直播，添加提示
                [self addLabelToShowNoVideo];
            }
            
            // 刷新数据
            [self.baseCollectionView reloadData];
            
        }
        else{
            NSLog(@"主视频关注界面：获取失败:responseObject:%@",responseObject);
            NSLog(@"主视频关注界面：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            
            
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"主视频关注界面：请求失败！失败原因：error：%@",error);
        
        // 停止刷新
        [self.baseCollectionView.header endRefreshing];
        [self.baseCollectionView.footer endRefreshing];
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
    
}

// 如果没有视频，添加提示
- (void)addLabelToShowNoVideo{
    NSLog(@"如果没有视频，添加提示");
    
    self.noDataLab = [[UILabel alloc] initWithFrame:CGRectMake((12.0 / 750.0) * cScreen_Width, (80.0 / 1334.0) * cScreen_Height, (726.0 / 750.0) * cScreen_Width, (30.0 / 1334.0) * cScreen_Height)];
    
    
    self.noDataLab.text = @"暂时没有关注的人视频";
    
    self.noDataLab.textAlignment = NSTextAlignmentCenter;
    self.noDataLab.font = [UIFont systemFontOfSize:15];
    
    self.noDataLab.textColor = [UIColor colorWithRed:0.50 green:0.50 blue:0.50 alpha:1.00];
    
    [self.baseCollectionView addSubview:self.noDataLab];
}


@end
