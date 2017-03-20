//
//  CYMemberVC.m
//  nzny
//
//  Created by 男左女右 on 2017/3/16.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYMemberVC.h"


// cell
#import "CYMemberViewCell.h"

// cell：模型
#import "CYMemberViewCellModel.h"



// 他人详情页
#import "CYOthersInfoVC.h"



@interface CYMemberVC ()

@end

@implementation CYMemberVC

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
    [self.baseTableView registerNib:[UINib nibWithNibName:@"CYMemberViewCell" bundle:nil] forCellReuseIdentifier:@"CYMemberViewCell"];
    
    
    // 加载数据
    //    [self loadData];
    
    self.baseTableView.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height - 64 - 49 - (76.0 / 1334) * cScreen_Height);
    self.baseTableView.backgroundColor = [UIColor whiteColor];
    
    
}

// 加载数据
- (void)loadData{
    
    
    
    // 网络请求：会员列表
    
    NSDictionary *params = @{
                             @"pageNum":@(self.curPage),
                             @"pageSize":@(10)
                             };
    
    
    // 网络请求：会员列表
    [CYNetWorkManager getRequestWithUrl:cAllMembersListUrl params:params progress:^(NSProgress *uploadProgress) {
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



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"第 %ld 行~~~~~~~~~~~~~~~~~",(long)indexPath.row);
    
    
    // cell
    CYMemberViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CYMemberViewCell" forIndexPath:indexPath];
    
    // cell：模型
    CYMemberViewCellModel *memberViewCellModel = self.dataArray[indexPath.row];
    
    
    cell.headImgView.layer.cornerRadius = (75.0 / 1334.0) * cScreen_Height;
    
    // 假数据
    cell.memberViewCellModel = memberViewCellModel;
    
    cell.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00];
    
    return cell;
}


//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //当离开某行时，让某行的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    CYMemberViewCellModel *memberViewCellModel = self.dataArray[indexPath.row];
    
    // 他人详情页
    CYOthersInfoVC *othersInfoVC = [[CYOthersInfoVC alloc] init];
    
    //    othersInfoVC.view.frame = CGRectMake(0, 0, 400, 400);
    
    othersInfoVC.oppUserId = memberViewCellModel.Id;
    
    othersInfoVC.hidesBottomBarWhenPushed = YES;
    
    //    [self.navigationController pushViewController:othersInfoVC animated:YES];
    // 导航VC：获取当前视图所在位置的导航控制器
    [[self navigationControllerWithView:self.view] pushViewController:othersInfoVC animated:YES];
    
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
