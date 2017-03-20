//
//  CYWomanMemberVC.m
//  nzny
//
//  Created by 男左女右 on 2017/3/16.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYWomanMemberVC.h"


// cell：模型
#import "CYMemberViewCellModel.h"


@interface CYWomanMemberVC ()

@end

@implementation CYWomanMemberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}


// 加载数据
- (void)loadData{
    
    
    
    // 网络请求：会员列表
    
    NSDictionary *params = @{
                             @"pageNum":@(self.curPage),
                             @"pageSize":@(10)
                             };
    
    
    // 网络请求：会员列表
    [CYNetWorkManager getRequestWithUrl:cGirlMembersListUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取会员列表进度：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"会员列表：请求成功！");
        
        
        
        // 停止刷新
        [self.baseTableView.header endRefreshing];
        [self.baseTableView.footer endRefreshing];
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"会员列表：获取成功！");
            NSLog(@"会员列表：%@",responseObject);
            
            
            
            // 清空：每次刷新都需要：但是上拉加载、下拉刷新的不需要；
            if (self.curPage == 1) {
                
                [self.dataArray removeAllObjects];
            }
            
            // 解析数据，模型存到数组
            [self.dataArray addObjectsFromArray:[CYMemberViewCellModel arrayOfModelsFromDictionaries:responseObject[@"res"][@"data"][@"list"]]];
            
            if (self.dataArray.count == 0) {
                
                // 如果没有直播，添加提示
                [self addLabelToShowNoVideo];
            }
            
            [self.baseTableView reloadData];
            
        }
        else{
            NSLog(@"会员列表：获取失败:responseObject:%@",responseObject);
            NSLog(@"会员列表：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"会员列表：请求失败！");
        NSLog(@"失败原因：error：%@",error);
        
        // 停止刷新
        [self.baseTableView.header endRefreshing];
        [self.baseTableView.footer endRefreshing];
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
}


// 如果没有视频，添加提示
- (void)addLabelToShowNoVideo{
    NSLog(@"如果没有视频，添加提示");
    
    self.noDataLab = [[UILabel alloc] initWithFrame:CGRectMake((12.0 / 750.0) * cScreen_Width, (80.0 / 1334.0) * cScreen_Height, (726.0 / 750.0) * cScreen_Width, (30.0 / 1334.0) * cScreen_Height)];
    
    
    self.noDataLab.text = @"暂时没有会员";
    
    self.noDataLab.textAlignment = NSTextAlignmentCenter;
    self.noDataLab.font = [UIFont systemFontOfSize:15];
    
    self.noDataLab.textColor = [UIColor colorWithRed:0.50 green:0.50 blue:0.50 alpha:1.00];
    
    [self.baseTableView addSubview:self.noDataLab];
}

@end
