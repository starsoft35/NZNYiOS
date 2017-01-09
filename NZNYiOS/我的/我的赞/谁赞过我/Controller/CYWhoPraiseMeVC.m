//
//  CYWhoPraiseMeVC.m
//  nzny
//
//  Created by 男左女右 on 2016/12/18.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYWhoPraiseMeVC.h"



// 换钱cell
#import "CYMyExchangePraiseCell.h"
// 换钱：模型
#import "CYMyExchangePraiseCellModel.h"

// 点赞的cell
#import "CYWhoPraiseMeCell.h"
// 点赞：模型
#import "CYWhoPraiseMeCellModel.h"


// 兑换赞：VC
#import "CYExchangeMoneyVC.h"



@interface CYWhoPraiseMeVC ()

@end

@implementation CYWhoPraiseMeVC

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
    //    [self.baseTableView registerNib:[UINib nibWithNibName:@"CYInfoHeaderCell" bundle:nil] forCellReuseIdentifier:@"CYInfoHeaderCell"];
    
    
    // 加载数据
    //    [self loadData];
    
}

//- (void)viewWillAppear:(BOOL)animated{
//    
//    [super viewWillAppear:animated];
//    
//    
//    // 热门视频：首次进入加载，其他时候手动加载。
//    // cell Header重新加载：自带加载数据
//    [self.baseTableView.header beginRefreshing];
//    
//}

// 加载数据
- (void)loadData{
    
    
    // 网络请求：用户积累的赞、可兑换的赞
    [self requestAllPraiseCountAndCanExchangePraiseCountWithCurrentUserId:self.onlyUser.userID];
    
    // 网络请求：谁赞过我
    [self requestGetWhoIPraiseWithCurrentUserId:self.onlyUser.userID andPageNum:self.curPage andPageSize:(10)];
    
    
}

// 网络请求：用户积累的赞、可兑换的赞
- (void)requestAllPraiseCountAndCanExchangePraiseCountWithCurrentUserId:(NSString *)userId{
    
    // 网络请求：用户积累的赞、可兑换的赞
    NSDictionary *likeCountUrlParams = @{
                                         @"userId":userId
                                         //                                         @"userId":@"136a0cee-d2f9-4316-b34f-5f0507fe0cb8"
                                         };
    
    
    // 网络请求：用户累积的赞
    [CYNetWorkManager getRequestWithUrl:cUserLikeCountUrl params:likeCountUrlParams progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取用户积累的赞、可兑换的赞进度：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"用户积累的赞、可兑换的赞：请求成功！");
        
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"用户积累的赞、可兑换的赞：获取成功！");
            NSLog(@"用户积累的赞、可兑换的赞：%@",responseObject);
            
            
            //
            //            // 清空：每次刷新都需要
            //            [self.dataArray removeAllObjects];
            
            // 换钱模型
            _exchangePraiseCellModel = [[CYMyExchangePraiseCellModel alloc] initWithDictionary:responseObject[@"res"][@"data"] error:nil];
            
            
            
            
        }
        else{
            NSLog(@"用户积累的赞、可兑换的赞：获取失败:responseObject:%@",responseObject);
            NSLog(@"用户积累的赞、可兑换的赞：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"用户积累的赞、可兑换的赞：请求失败！");
        NSLog(@"失败原因：error：%@",error);
        
        // 停止刷新
        //        [self.baseTableView.header endRefreshing];
        //        [self.baseTableView.footer endRefreshing];
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
}

// 网络请求：谁赞过我
- (void)requestGetWhoIPraiseWithCurrentUserId:(NSString *)userId andPageNum:(NSInteger)pageNum andPageSize:(NSInteger)pageSize{
    
    NSDictionary *params = @{
                             @"userId":userId,
                             //                             @"userId":@"136a0cee-d2f9-4316-b34f-5f0507fe0cb8",
                             @"pageNum":@(pageNum),
                             @"pageSize":@(pageSize)
                             };
    
    
    // 网络请求：谁赞过我
    [CYNetWorkManager getRequestWithUrl:cMyReceiveLikeListUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取谁赞过我进度：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"谁赞过我：请求成功！");
        
        
        
        // 停止刷新
        [self.baseTableView.header endRefreshing];
        [self.baseTableView.footer endRefreshing];
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"谁赞过我：获取成功！");
            NSLog(@"谁赞过我：%@",responseObject);
            
            
            
            // 清空：每次刷新都需要：但是上拉加载、下拉刷新的不需要；
            if (self.curPage == 1) {
                
                [self.dataArray removeAllObjects];
            }
            
            // 解析数据，模型存到数组
            [self.dataArray addObjectsFromArray:[CYWhoPraiseMeCellModel arrayOfModelsFromDictionaries:responseObject[@"res"][@"data"][@"list"]]];
            
            
            [self.baseTableView reloadData];
            
        }
        else{
            NSLog(@"谁赞过我：获取失败:responseObject:%@",responseObject);
            NSLog(@"谁赞过我：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"谁赞过我：请求失败！");
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
    
    return self.dataArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"第 %ld 行~~~~~~~~~~~~~~~~~",(long)indexPath.row);
    
    if (indexPath.row == 0) {
        
        // 换钱
        
        [self.baseTableView registerNib:[UINib nibWithNibName:@"CYMyExchangePraiseCell" bundle:nil] forCellReuseIdentifier:@"CYMyExchangePraiseCell"];
        
        // cell
        CYMyExchangePraiseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CYMyExchangePraiseCell" forIndexPath:indexPath];
        
        cell.backgroundColor = [UIColor colorWithRed:0.98 green:0.91 blue:0.86 alpha:1.00];
        
        // 换钱button：点击事件
        [cell.changeMoneyBtn addTarget:self action:@selector(changeMoneyBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        //        cell.exchangePraiseCellModel = self.dataArray[indexPath.row];
        
        
        cell.exchangePraiseCellModel = self.exchangePraiseCellModel;
        
        
        return cell;
    }
    else {
        
        // 赞过的人
        
        [self.baseTableView registerNib:[UINib nibWithNibName:@"CYWhoPraiseMeCell" bundle:nil] forCellReuseIdentifier:@"CYWhoPraiseMeCell"];
        
        // cell
        CYWhoPraiseMeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CYWhoPraiseMeCell" forIndexPath:indexPath];
        
        // cell：模型
        CYWhoPraiseMeCellModel *whoPraiseMeCellModel = self.dataArray[indexPath.row - 1];
        whoPraiseMeCellModel.isPraise = YES;
        
        cell.headImgView.layer.cornerRadius = (75.0 / 150.0) * cell.headImgView.frame.size.height;
        
        // 假数据
        cell.whoPraiseMeCellModel = whoPraiseMeCellModel;
        
        
        return cell;
    }
}

// 换钱button：点击事件
- (void)changeMoneyBtnClick{
    NSLog(@"换钱button：点击事件");
    
    // 兑换赞：弹窗
    CYExchangeMoneyVC *exchangeMoneyVC = [[CYExchangeMoneyVC alloc] init];
    
//    [self.navigationController pushViewController:exchangeMoneyVC animated:YES];
//    [self.parentViewController presentViewController:exchangeMoneyVC animated:nil completion:nil];
    
    
    //  导航条设置为不透明的（这样创建的视图（0，0）点，是在导航条左下角开始的。）
//    UINavigationController *tempVideoNav = [CYUtilities createDefaultNavCWithRootVC:exchangeMoneyVC BgColor:nil TintColor:[UIColor whiteColor] translucent:YES titleColor:[UIColor whiteColor] title:@"" bgImg:[UIImage imageNamed:@"Title1"]];
    
    
//    [self showViewController:tempVideoNav sender:self];
    [self showViewController:exchangeMoneyVC sender:self];
    
}


// cell 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 && indexPath.row == 0 ) {
        
        return (150.0 / 1206.0) * self.view.frame.size.height;
    }
    else {
        
        return (190.0 / 1206.0) * self.view.frame.size.height;
    }
}

// header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 5;
}





@end
