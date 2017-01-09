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
    self.view.backgroundColor = [UIColor cyanColor];
    self.baseTableView.backgroundColor = [UIColor whiteColor];
    
    // 加载数据
    [self loadData];
    
    
    
    
    // 提前注册
    [self.baseTableView registerNib:[UINib nibWithNibName:@"CYInfoHeaderCell" bundle:nil] forCellReuseIdentifier:@"CYInfoHeaderCell"];
    
    // 加载数据
//    [self loadData];
    
}


// 加载数据
- (void)loadData{
    
//    NSArray *tempArr = @[
//                         @{
//                             @"Portrait":@"默认头像",
////                             @"liveStatusBgImgName":@"直播预告",
//////                             @"Title":@"预告",
////                             @"PlanStartTime":@"2016/11/19 08:00",
////                             @"LiveUserGender":@"",
////                             @"LiveUserName":@"",
////                             @"Title":@"# 预谋邂逅 #"
//                             },
//                         @{
//                             @"Portrait":@"默认头像",
////                             @"liveStatusBgImgName":@"直播预告",
////                             @"Title":@"预告",
////                             @"PlanStartTime":@"2016/11/19 08:00",
////                             @"LiveUserGender":@"",
////                             @"LiveUserName":@"",
////                             @"Title":@"# 预谋邂逅 #"
//                             }
//                         
//                         
//                         ];
//    
//    [self.dataArray addObjectsFromArray:[CYOthersInfoViewModel arrayOfModelsFromDictionaries:tempArr]];
    
    
    
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
            
#warning 还需要测试数据
            // 解析数据，模型存到数组
            [self.dataArray addObjectsFromArray:[CYOthersInfoViewModel arrayOfModelsFromDictionaries:responseObject[@"res"][@"data"][@"model"]]];
            
            if (self.dataArray.count == 0) {
                
                // 如果没有直播，添加提示
                [self addLabelToShowNoLive];
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


// 如果没有直播，添加提示
- (void)addLabelToShowNoLive{
    NSLog(@"如果没有直播，添加提示");
    
    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake((12.0 / 750.0) * self.view.frame.size.width, (50.0 / 1334.0) * self.view.frame.size.height, (726.0 / 750.0) * self.view.frame.size.width, (30.0 / 1334.0) * self.view.frame.size.height)];
    
    
    tipLab.text = @"暂时没有直播记录";
    
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.font = [UIFont systemFontOfSize:15];
    
    [self.view addSubview:tipLab];
}


// 创建tableView（即tableView要展示的内容）
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CYTitleTimeCountStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CYTitleTimeCountStatusCell" forIndexPath:indexPath];
    
    // 他人详情页模型：里面有直播列表：
    CYOthersInfoViewModel *othersInfoViewModel = self.dataArray[0];
    
    // 视频数组：从他人详情页获取
    NSArray *liveListArr = othersInfoViewModel.LiveList;
    
    CYOtherLiveCellModel *liveCellModel = liveListArr[indexPath.row];
    
    cell.liveCellModel = liveCellModel;
    
    
    return cell;
    
    
    
}


// 选择cell：单击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击cell:%ld,%ld",indexPath.section,indexPath.row);
    
    //当离开某行时，让某行的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

// 几个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.dataArray.count != 0) {
        
        CYOthersInfoViewModel *othersInfoViewModel = self.dataArray[0];
        NSArray *liveListArr = othersInfoViewModel.LiveList;
        
        return liveListArr.count;
    }
    else {
        
        return 0;
    }
}


@end
