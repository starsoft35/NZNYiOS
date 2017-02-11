//
//  CYPastReviewVC.m
//  nzny
//
//  Created by 男左女右 on 2017/2/5.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYPastReviewVC.h"


// 线下活动：cell
#import "CYOfflineActivityCell.h"
// 线下活动：cell：模型
#import "CYOfflineActivityCellModel.h"


// 社区活动详情:VC
#import "CYActiveDetailsVC.h"



@interface CYPastReviewVC ()

@end

@implementation CYPastReviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"往期回顾";
    
    // 背景颜色
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
    
    self.view.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height - 64);
    self.baseTableView.frame = self.view.frame;
    
    // 添加下拉刷新
    self.baseTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self refresh];
        
    }];
    
    // 添加上拉加载
    self.baseTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self loadMore];
        
    }];
    
    // 首次进入加载，其他时候手动加载。
    // cell Header重新加载：自带加载数据
    [self.baseTableView.header beginRefreshing];
    
    // 提前注册
    [self.baseTableView registerNib:[UINib nibWithNibName:@"CYOfflineActivityCell" bundle:nil] forCellReuseIdentifier:@"CYOfflineActivityCell"];
    
    
}


// 加载数据
- (void)loadData{
    
    // 网络请求：往期回顾列表
    NSDictionary *params = @{
                             @"pageNum":@(self.curPage),
                             @"pageSize":@(10)
                             };
    
    
    // 网络请求：往期回顾列表
    [CYNetWorkManager getRequestWithUrl:cPastActivityListUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取往期回顾列表进度：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"往期回顾列表：请求成功！");
        
        
        
        // 停止刷新
        [self.baseTableView.header endRefreshing];
        [self.baseTableView.footer endRefreshing];
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"往期回顾列表：获取成功！");
            NSLog(@"往期回顾列表：%@",responseObject);
            
            
            
            // 清空：每次刷新都需要：但是上拉加载、下拉刷新的不需要；
            if (self.curPage == 1) {
                
                [self.dataArray removeAllObjects];
            }
            
            // 解析数据，模型存到数组
            [self.dataArray addObjectsFromArray:[CYOfflineActivityCellModel arrayOfModelsFromDictionaries:responseObject[@"res"][@"data"][@"list"]]];
            
            
            [self.baseTableView reloadData];
            
        }
        else{
            NSLog(@"往期回顾列表：获取失败:responseObject:%@",responseObject);
            NSLog(@"往期回顾列表：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"往期回顾列表：请求失败！");
        NSLog(@"失败原因：error：%@",error);
        
        // 停止刷新
        [self.baseTableView.header endRefreshing];
        [self.baseTableView.footer endRefreshing];
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
    
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"第 %ld 行~~~~~~~~~~~~~~~~~",(long)indexPath.row);
    
    
    // cell
    CYOfflineActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CYOfflineActivityCell" forIndexPath:indexPath];
    
    // cell：模型
    CYOfflineActivityCellModel *offlineActivityCellModel = self.dataArray[indexPath.row];
    
    offlineActivityCellModel.Status = @"不显示";
    
    // 假数据
    cell.offlineActiveCellModel = offlineActivityCellModel;
    
    
    cell.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
    
    
    return cell;
}

// 选择cell：单击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击cell:%ld,%ld",(long)indexPath.section,(long)indexPath.row);
    
    //当离开某行时，让某行的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CYOfflineActivityCellModel *offlineActivityCellModel = self.dataArray[indexPath.row];
    
    
    CYActiveDetailsVC *activeDetailsVC = [[CYActiveDetailsVC alloc] init];
    
    activeDetailsVC.activeId = offlineActivityCellModel.ActivityContentId;
    NSLog(@"activeId:%@",activeDetailsVC.activeId);
    
    
    activeDetailsVC.hidesBottomBarWhenPushed = YES;
    
    
    //    [self.navigationController pushViewController:activeDetailsVC animated:YES];
    [[self navigationControllerWithView:self.view] pushViewController:activeDetailsVC animated:YES];
    
}


// cell 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return (650.0 / 1334.0) * cScreen_Height;
}

// header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 5;
}


@end
