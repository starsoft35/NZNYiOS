//
//  CYNearbyPeopleVC.m
//  nzny
//
//  Created by 男左女右 on 2017/1/5.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYNearbyPeopleVC.h"



// 附近的人：cell
#import "CYNearbyPeopleCell.h"


// 他人详情页
#import "CYOthersInfoVC.h"

// 附近的人：模型
#import "CYNearbyPeopleCellModel.h"




@interface CYNearbyPeopleVC ()

@end

@implementation CYNearbyPeopleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"附近";
    
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
    
    
    // 加载数据
//    [self loadData];
    
    // 提前注册
    
    [self.baseTableView registerNib:[UINib nibWithNibName:@"CYNearbyPeopleCell" bundle:nil] forCellReuseIdentifier:@"CYNearbyPeopleCell"];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    // 隐藏tabbar
    self.hidesBottomBarWhenPushed = YES;
}


// 加载数据：附近的人列表
- (void)loadData{
    
    // 参数
    NSDictionary *params = @{
                             @"userId":self.onlyUser.userID,
                             @"pageNum":@(self.curPage),
                             @"pageSize":@(10)
                             };
    
//    [self showLoadingView];
    
    // 网络请求：附近的人
    [CYNetWorkManager getRequestWithUrl:cNearbyUserListUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"附近的人请求：进度：%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"附近的人请求：请求成功！");
        
        
        // 停止刷新
        [self.baseTableView.header endRefreshing];
        [self.baseTableView.footer endRefreshing];
        
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"附近的人：结果成功！");
            NSLog(@"附近的人：responseObject：%@",responseObject);
            
            
            // 清空：每次刷新都需要：但是上拉加载、下拉刷新的不需要；
            if (self.curPage == 1) {
                
                [self.dataArray removeAllObjects];
            }
            
            
            
            // 先把没有数据label删除
            [self.noDataLab removeFromSuperview];
            
            
            
            // 解析数据，模型存到数组
            [self.dataArray addObjectsFromArray:[CYNearbyPeopleCellModel arrayOfModelsFromDictionaries:responseObject[@"res"][@"data"][@"list"]]];
            
            
            if (self.dataArray.count == 0) {
                
                // 如果没有附近的人，添加提示
                [self addLabelToShowNoNearPeople];
            }
            
            
            [self.baseTableView reloadData];
            
        }
        else{
            NSLog(@"附近的人：结果失败:responseObject:%@",responseObject);
            NSLog(@"附近的人：结果失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            
            // 1.2.1.1.2.2、我的粉丝失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"附近的人请求：请求失败！");
        
        // 停止刷新
        [self.baseTableView.header endRefreshing];
        [self.baseTableView.footer endRefreshing];
        
        [self showHubWithLabelText:@"请检查网络" andHidAfterDelay:3.0];
        
    } withToken:self.onlyUser.userToken];
    
}

// 如果没有附近的人，添加提示
- (void)addLabelToShowNoNearPeople{
    NSLog(@"如果没有视频，添加提示");
    
    self.noDataLab = [[UILabel alloc] initWithFrame:CGRectMake((12.0 / 750.0) * cScreen_Width, (80.0 / 1334.0) * cScreen_Height, (726.0 / 750.0) * cScreen_Width, (30.0 / 1334.0) * cScreen_Height)];
    
    
    self.noDataLab.text = @"暂时没有附近的人";
    
    self.noDataLab.textAlignment = NSTextAlignmentCenter;
    self.noDataLab.font = [UIFont systemFontOfSize:15];
    
    self.noDataLab.textColor = [UIColor colorWithRed:0.50 green:0.50 blue:0.50 alpha:1.00];
    
    [self.baseTableView addSubview:self.noDataLab];
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
    
    CYNearbyPeopleCell *nearbyPeopleCell = [tableView dequeueReusableCellWithIdentifier:@"CYNearbyPeopleCell" forIndexPath:indexPath];
    
    
    CYNearbyPeopleCellModel *nearbyPeopleCellModel = self.dataArray[indexPath.row];
    
    nearbyPeopleCell.nearbyPeopleCellModel = nearbyPeopleCellModel;
    
    
    
    return nearbyPeopleCell;
    
}


// cell：点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第 %ld 行 cell",(long)indexPath.row);
    
    //当离开某行时，让某行的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CYNearbyPeopleCellModel *nearbyPeopleCellModel = self.dataArray[indexPath.row];
    
    
    // 他人详情页
    CYOthersInfoVC *othersInfoVC = [[CYOthersInfoVC alloc] init];
    
    //    othersInfoVC.view.frame = CGRectMake(0, 0, 400, 400);
    
    othersInfoVC.oppUserId = nearbyPeopleCellModel.UserId;
    
    othersInfoVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:othersInfoVC animated:YES];
    
    
    
}

// cell 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return (190.0 / 1334.0) * cScreen_Height;
}

// 为了设置第一行距顶部navigation 的距离
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}


@end
