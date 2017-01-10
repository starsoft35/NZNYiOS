//
//  CYMyLiveRecordVC.m
//  nzny
//
//  Created by 男左女右 on 2016/12/11.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYMyLiveRecordVC.h"

// 模型
#import "CYMyLiveRecordCellModel.h"

// viewCell
#import "CYMyLiveRecordCell.h"


@interface CYMyLiveRecordVC ()

@end

@implementation CYMyLiveRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 背景颜色
//    self.view.backgroundColor = [UIColor cyanColor];
    self.baseTableView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.00];
    
    
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
    [self.baseTableView registerNib:[UINib nibWithNibName:@"CYMyLiveRecordCell" bundle:nil] forCellReuseIdentifier:@"CYMyLiveRecordCell"];
    
    // 加载数据
//    [self loadData];
    
}

// 加载数据
- (void)loadData{
    
    
#warning 我的直播预告：注意参数：用户的ID
    // 网络请求：我的直播预告
    NSDictionary *params = @{
                             
                             @"userId":self.onlyUser.userID
                             
                             };
    
    
    
    
    //    [self showLoadingView];
    
    // 网络请求：直播详情页
    [CYNetWorkManager getRequestWithUrl:cMyLiveRecirdListUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取我的直播预告进度：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"我的直播预告：请求成功！");
        
        
        
        // 停止刷新
        [self.baseTableView.header endRefreshing];
        [self.baseTableView.footer endRefreshing];
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"我的直播预告：获取成功！");
            NSLog(@"我的直播预告：%@",responseObject);
            
            // 清空：每次刷新都需要
            [self.dataArray removeAllObjects];
            
            // 解析数据，模型存到数组
            [self.dataArray addObjectsFromArray:[CYMyLiveRecordCellModel arrayOfModelsFromDictionaries:responseObject[@"res"][@"data"][@"list"]]];
            
            if (self.dataArray.count == 0) {
                
                // 如果没有直播，添加提示
                [self addLabelToShowNoLive];
            }
            
            [self.baseTableView reloadData];
            
            // 请求数据结束，取消加载
            //            [self hidenLoadingView];
            
        }
        else{
            NSLog(@"我的直播预告：获取失败:responseObject:%@",responseObject);
            NSLog(@"我的直播预告：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"我的直播预告：请求失败！");
        NSLog(@"失败原因：error：%@",error);
        
        // 停止刷新
        [self.baseTableView.header endRefreshing];
        [self.baseTableView.footer endRefreshing];
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
}

// 如果没有直播，添加提示
- (void)addLabelToShowNoLive{
    NSLog(@"如果没有直播，添加提示");
    
    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake((12.0 / 750.0) * self.view.frame.size.width, (80.0 / 1334.0) * self.view.frame.size.height, (726.0 / 750.0) * self.view.frame.size.width, (30.0 / 1334.0) * self.view.frame.size.height)];
    
    
    tipLab.text = @"暂时没有直播预告";
    
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.font = [UIFont systemFontOfSize:15];
    
    tipLab.textColor = [UIColor colorWithRed:0.50 green:0.50 blue:0.50 alpha:1.00];
    
    [self.baseTableView addSubview:tipLab];
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
    
    
    // cell
    CYMyLiveRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CYMyLiveRecordCell" forIndexPath:indexPath];
    
    
    // 假数据
    cell.myLiveRecordCellModel = self.dataArray[indexPath.row];
    
    cell.nextPageImgView.hidden = YES;
    
    
    return cell;
    
}


// cell 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return (128.0 / 1334.0) * cScreen_Height;
}


// header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}


@end
