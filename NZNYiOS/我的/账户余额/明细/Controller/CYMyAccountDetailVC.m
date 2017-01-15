//
//  CYMyAccountDetailVC.m
//  nzny
//
//  Created by 男左女右 on 2016/12/25.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYMyAccountDetailVC.h"

// cell
#import "CYMyAccountDetailCell.h"

// Cell：模型
#import "CYMyAccountDetailCellModel.h"

@interface CYMyAccountDetailVC ()

@end

@implementation CYMyAccountDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 背景颜色
    self.view.backgroundColor = [UIColor cyanColor];
    
    self.title = @"明细";
    
    
    // 添加下拉刷新
    self.baseTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self refresh];
        
    }];
    
    // 添加上拉加载
    self.baseTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self loadMore];
        
    }];
    
    // 直播：首次进入加载，其他时候手动加载。
    // cell Header重新加载：自带加载数据
    [self.baseTableView.header beginRefreshing];
    
    
    // 提前注册
    [self.baseTableView registerNib:[UINib nibWithNibName:@"CYMyAccountDetailCell" bundle:nil] forCellReuseIdentifier:@"CYMyAccountDetailCell"];
    
    self.baseTableView.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height - 64);
    
    // 加载数据
    //    [self loadData];
    
}

// 加载数据
- (void)loadData{
    
    // 网络请求：我的直播预告
    NSDictionary *params = @{
                             
                             @"userId":self.onlyUser.userID,
                             @"pageNum":@(self.curPage),
                             @"pageSize":@(20)
                             
                             };
    
    //    [self showLoadingView];
    
    // 网络请求：花费明细
    [CYNetWorkManager getRequestWithUrl:cMyPayListUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取我的花费明细进度：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"我的花费明细：请求成功！");
        
        
        // 停止刷新
        [self.baseTableView.header endRefreshing];
        [self.baseTableView.footer endRefreshing];
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"我的花费明细：获取成功！");
            NSLog(@"我的花费明细：%@",responseObject);
            
            
            // 如果是下拉加载则清空
            if (self.curPage == 1) {
                
                [self.dataArray removeAllObjects];
                
            }
            
            // 解析数据，模型存到数组
            [self.dataArray addObjectsFromArray:[CYMyAccountDetailCellModel arrayOfModelsFromDictionaries:responseObject[@"res"][@"data"][@"list"]]];
            
            [self.baseTableView reloadData];
            
            // 请求数据结束，取消加载
            //            [self hidenLoadingView];
            
        }
        else{
            NSLog(@"我的花费明细：获取失败:responseObject:%@",responseObject);
            NSLog(@"我的花费明细：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"我的花费明细：请求失败！");
        NSLog(@"失败原因：error：%@",error);
        
        // 停止刷新
        [self.baseTableView.header endRefreshing];
        [self.baseTableView.footer endRefreshing];
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
}

// 选择cell：单击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击cell:%ld,%ld",(long)indexPath.section,(long)indexPath.row);
    
    //当离开某行时，让某行的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


// tableView有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

// 每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //当离开某行时，让某行的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    // cell
    CYMyAccountDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CYMyAccountDetailCell" forIndexPath:indexPath];
    
    // 假数据
    cell.myAccountDetailCellModel = self.dataArray[indexPath.row];
    
    
    return cell;
    
}


// cell 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return (88.0 / 1334.0) * cScreen_Height;
}


// header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}

@end
