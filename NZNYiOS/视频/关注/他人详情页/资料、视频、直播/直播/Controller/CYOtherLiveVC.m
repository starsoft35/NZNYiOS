//
//  CYOtherLiveVC.m
//  nzny
//
//  Created by 男左女右 on 2016/11/23.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYOtherLiveVC.h"


// 直播VC模型
//#import "CYLiveCollectionViewCellModel.h"

// 直播cell
#import "CYTitleTimeCountStatusCell.h"


// 模型
#import "CYOtherLiveCellModel.h"

// 他人详情页：模型
#import "CYOthersInfoViewModel.h"


@interface CYOtherLiveVC ()

@end

@implementation CYOtherLiveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 添加下拉刷新
//    self.baseCollectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        
//        [self refresh];
//        
//    }];
//    
//    // 添加上拉加载
//    self.baseCollectionView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        
//        [self loadMore];
//        
//    }];
    
    // View的背景颜色
    self.baseTableView.backgroundColor = [UIColor whiteColor];
    
    // 加载数据
    [self loadData];
    
    
    
    
    // 提前注册
    [self.baseTableView registerNib:[UINib nibWithNibName:@"CYTitleTimeCountStatusCell" bundle:nil] forCellReuseIdentifier:@"CYTitleTimeCountStatusCell"];
    
    // 加载数据
//    [self loadData];
    
}


// 加载数据
- (void)loadData{
    
    // 网络请求：他人详情页
    
    // 新地址
    NSDictionary *params = @{
                             @"userId":self.onlyUser.userID,
                             @"oppUserId":self.oppUserId,
                             };
    NSLog(@"params:oppUserId:%@",self.oppUserId);
    
    //    [self showLoadingView];
    
    // 网络请求：他人详情页
    [CYNetWorkManager getRequestWithUrl:cOppUserInfoUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取他人详情页进度：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"他人详情页：请求成功！");
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"他人详情页：获取成功！");
            NSLog(@"他人详情页：%@",responseObject);
            
            // 清空：每次刷新都需要
            [self.dataArray removeAllObjects];
            [self.noDataLab removeFromSuperview];
            
            // 解析数据，模型存到数组
            [self.dataArray addObject:[[CYOthersInfoViewModel alloc] initWithDictionary:responseObject[@"res"][@"data"][@"model"] error:nil]];
            
            
            if (self.dataArray.count != 0) {
                
                // 有视频，创建新的视频数据源
                [self loadNewData];
            }
            
            [self.baseTableView reloadData];
            
            // 请求数据结束，取消加载
            [self hidenLoadingView];
            
        }
        else{
            NSLog(@"他人详情页：获取失败:responseObject:%@",responseObject);
            NSLog(@"他人详情页：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"他人详情页：请求失败！");
        NSLog(@"失败原因：error：%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
    
    
}

// 有视频，创建新的视频数据源
- (void)loadNewData{
    
    // 他人详情页模型
    CYOthersInfoViewModel *tempOthersInfoModel = self.dataArray[0];
    
    NSLog(@"tempOthersInfoModel:%@",tempOthersInfoModel);
    // 清空：每次刷新都需要
    [self.liveListDataArr removeAllObjects];
    
    
    self.liveListDataArr = (NSMutableArray *)tempOthersInfoModel.LiveList;
    
    
    if (self.liveListDataArr.count == 0) {
        
        // 如果没有直播，添加提示
        [self addLabelToShowNoLive];
    }
    
    
    NSLog(@"self.liveListDataArr:%@",self.liveListDataArr);
    
}

// 如果没有直播，添加提示
- (void)addLabelToShowNoLive{
    NSLog(@"如果没有直播，添加提示");
    
    self.noDataLab = [[UILabel alloc] initWithFrame:CGRectMake((12.0 / 750.0) * self.view.frame.size.width, (80.0 / 1334.0) * self.view.frame.size.height, (726.0 / 750.0) * self.view.frame.size.width, (30.0 / 1334.0) * self.view.frame.size.height)];
    
    
    self.noDataLab.text = @"暂时没有直播";
    
    self.noDataLab.textAlignment = NSTextAlignmentCenter;
    self.noDataLab.font = [UIFont systemFontOfSize:15];
    
    self.noDataLab.textColor = [UIColor colorWithRed:0.50 green:0.50 blue:0.50 alpha:1.00];
    
    [self.baseTableView addSubview:self.noDataLab];
}

// 几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.liveListDataArr.count;
}



// 创建tableView（即tableView要展示的内容）
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CYTitleTimeCountStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CYTitleTimeCountStatusCell" forIndexPath:indexPath];
    
    
    CYOtherLiveCellModel *liveCellModel = self.liveListDataArr[indexPath.row];
    
    cell.liveCellModel = liveCellModel;
    
    
    return cell;
    
    
    
}


// 选择cell：单击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击cell:%ld,%ld",(long)indexPath.section,(long)indexPath.row);
    
    //当离开某行时，让某行的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

// cell 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return (88.0 / 1246.0) * self.view.frame.size.height;
}

// header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}


@end
