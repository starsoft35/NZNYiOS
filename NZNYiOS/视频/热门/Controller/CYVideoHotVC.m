//
//  CYVideoHotVC.m
//  nzny
//
//  Created by 男左女右 on 2016/11/22.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYVideoHotVC.h"

// 视频cell模型
#import "CYVideoCollectionViewCellModel.h"

@interface CYVideoHotVC ()

@end

@implementation CYVideoHotVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 热门视频：首次进入加载，其他时候手动加载。
    // cell Header重新加载：自带加载数据
    [self.baseCollectionView.header beginRefreshing];
    // 加载数据
//    [self loadData];
    
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    
//    //    [self loadData];
//    // tabbar：显示
////    self.parentViewController.hidesBottomBarWhenPushed = NO;
//    
//}

// 加载数据
- (void)loadData{
    
    
    NSDictionary *params = @{
                             @"pageNum":@(self.curPage),
                             @"pageSize":@(10)
                             };
    
    
    // 网络请求：主视频热门界面
    [CYNetWorkManager getRequestWithUrl:cHotVideoListUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取主视频热门界面进度：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"主视频热门界面：请求成功！");
        
        
        // 停止刷新
        [self.baseCollectionView.header endRefreshing];
        [self.baseCollectionView.footer endRefreshing];
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"主视频热门界面：获取成功！：%@",responseObject);
            
            // 清空：每次刷新都需要：但是上拉加载、下拉刷新的不需要；
            if (self.curPage == 1) {
                
                [self.dataArray removeAllObjects];
            }
            
            // 解析数据，模型存到数组
            [self.dataArray addObjectsFromArray:[CYVideoCollectionViewCellModel arrayOfModelsFromDictionaries:responseObject[@"res"][@"data"][@"list"]]];
            
            
            // 刷新数据
            [self.baseCollectionView reloadData];
            
            
        }
        else{
            NSLog(@"主视频热门界面：获取失败:responseObject:%@",responseObject);
            NSLog(@"主视频热门界面：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            
            
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"主视频热门界面：请求失败！失败原因：error：%@",error);
        
        // 停止刷新
        [self.baseCollectionView.header endRefreshing];
        [self.baseCollectionView.footer endRefreshing];
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
    
}


@end
