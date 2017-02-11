//
//  CYMyReceivedVC.m
//  nzny
//
//  Created by 男左女右 on 2016/12/20.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYMyReceivedVC.h"

// 点赞的cell
#import "CYWhoPraiseMeCell.h"
// 点赞：模型
#import "CYWhoPraiseMeCellModel.h"

@interface CYMyReceivedVC ()

@end

@implementation CYMyReceivedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加下拉刷新
    self.baseTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self refresh];
        
    }];
    
    // 添加上拉加载
    self.baseTableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self loadMore];
        
    }];
    
    // 热门视频：首次进入加载，其他时候手动加载。
    // cell Header重新加载：自带加载数据
    [self.baseTableView.header beginRefreshing];
    
    // 提前注册
    [self.baseTableView registerNib:[UINib nibWithNibName:@"CYWhoPraiseMeCell" bundle:nil] forCellReuseIdentifier:@"CYWhoPraiseMeCell"];
    
    
    // 加载数据
    //    [self loadData];
    
}

// 加载数据
- (void)loadData{
    
    
    // 网络请求：用户积累的赞、可兑换的赞
//    [self requestAllPraiseCountAndCanExchangePraiseCountWithCurrentUserId:self.onlyUser.userID];
    
    // 网络请求：我收到的礼物
    [self requestGetWhoIPraiseWithCurrentUserId:self.onlyUser.userID andPageNum:self.curPage andPageSize:(10)];
    
    
}


// 网络请求：我收到的礼物
- (void)requestGetWhoIPraiseWithCurrentUserId:(NSString *)userId andPageNum:(NSInteger)pageNum andPageSize:(NSInteger)pageSize{
    
    NSDictionary *params = @{
                             @"userId":userId,
//                                                          @"userId":@"136a0cee-d2f9-4316-b34f-5f0507fe0cb8",
                             @"pageNum":@(pageNum),
                             @"pageSize":@(pageSize)
                             };
    
    
    // 网络请求：我收到的礼物
    [CYNetWorkManager getRequestWithUrl:cMyReceiveFlowersListUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取我收到的礼物进度：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"我收到的礼物：请求成功！");
        
        
        
        // 停止刷新
        [self.baseTableView.header endRefreshing];
        [self.baseTableView.footer endRefreshing];
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"我收到的礼物：获取成功！");
            NSLog(@"我收到的礼物：%@",responseObject);
            
            
            
            // 清空：每次刷新都需要：但是上拉加载、下拉刷新的不需要；
            if (self.curPage == 1) {
                
                [self.dataArray removeAllObjects];
            }
            
            // 解析数据，模型存到数组
            [self.dataArray addObjectsFromArray:[CYWhoPraiseMeCellModel arrayOfModelsFromDictionaries:responseObject[@"res"][@"data"][@"list"]]];
            
            
            [self.baseTableView reloadData];
            
        }
        else{
            NSLog(@"我收到的礼物：获取失败:responseObject:%@",responseObject);
            NSLog(@"我收到的礼物：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"我收到的礼物：请求失败！");
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
    CYWhoPraiseMeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CYWhoPraiseMeCell" forIndexPath:indexPath];
    
    // cell：模型
    CYWhoPraiseMeCellModel *whoPraiseMeCellModel = self.dataArray[indexPath.row];
    whoPraiseMeCellModel.isPraise = NO;
    
    cell.headImgView.layer.cornerRadius = (75.0 / 1334.0) * cScreen_Height;
    
    // 假数据
    cell.whoPraiseMeCellModel = whoPraiseMeCellModel;
    
    
    return cell;
}


// cell 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return (190.0 / 1334.0) * cScreen_Height;
}

// header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 5;
}




@end
