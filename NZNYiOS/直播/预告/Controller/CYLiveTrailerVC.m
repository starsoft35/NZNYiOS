//
//  CYLiveTrailerVC.m
//  nzny
//
//  Created by 男左女右 on 2016/11/22.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYLiveTrailerVC.h"



// 直播cell模型
#import "CYLiveCollectionViewCellModel.h"

// 直播cell
#import "CYLiveCollectionViewCell.h"

// 直播详情页:VC
#import "CYLivePlayDetailsVC.h"

@interface CYLiveTrailerVC ()

@end

@implementation CYLiveTrailerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    self.baseCollectionView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.00];
    
    
    // 直播：首次进入加载，其他时候手动加载。
    // cell Header重新加载：自带加载数据
    [self.baseCollectionView.header beginRefreshing];
    
    // 加载数据
//    [self loadData];
    
}

// 加载数据
- (void)loadData{
    
    // 网络请求：直播界面
    NSDictionary *params = @{
                             @"pageNum":@(self.curPage),
                             @"pageSize":@(10)
                             };
    
    
    // 网络请求：直播界面
    [CYNetWorkManager getRequestWithUrl:cLiveTrailerListUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取直播界面进度：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"直播界面：请求成功！");
        
        
        // 停止刷新
        [self.baseCollectionView.header endRefreshing];
        [self.baseCollectionView.footer endRefreshing];
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"直播界面：获取成功！：%@",responseObject);
            
            // 清空：每次下拉刷新都需要：但是上拉加载的不需要；
            if (self.curPage == 1) {
                
                [self.dataArray removeAllObjects];
            }
            
            // 先把没有数据label删除
            [self.noDataLab removeFromSuperview];
            
            // 解析数据，模型存到数组
            [self.dataArray addObjectsFromArray:[CYLiveCollectionViewCellModel arrayOfModelsFromDictionaries:responseObject[@"res"][@"data"][@"list"]]];
            
            
            if (self.dataArray.count == 0) {
                
                // 如果没有直播，添加提示
                [self addLabelToShowNoLive];
            }
            
            // 刷新数据
            [self.baseCollectionView reloadData];
            
            
        }
        else{
            NSLog(@"直播界面：获取失败:responseObject:%@",responseObject);
            NSLog(@"直播界面：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            
            
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"直播界面：请求失败！失败原因：error：%@",error);
        
        // 停止刷新
        [self.baseCollectionView.header endRefreshing];
        [self.baseCollectionView.footer endRefreshing];
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
}


// 如果没有直播，添加提示
- (void)addLabelToShowNoLive{
    NSLog(@"如果没有直播，添加提示");
    
    self.noDataLab = [[UILabel alloc] initWithFrame:CGRectMake((12.0 / 750.0) * cScreen_Width, (80.0 / 1334.0) * cScreen_Height, (726.0 / 750.0) * cScreen_Width, (30.0 / 1334.0) * cScreen_Height)];
    
    
    self.noDataLab.text = @"暂时没有直播预告";
    
    self.noDataLab.textAlignment = NSTextAlignmentCenter;
    self.noDataLab.font = [UIFont systemFontOfSize:15];
    
    self.noDataLab.textColor = [UIColor colorWithRed:0.50 green:0.50 blue:0.50 alpha:1.00];
    
    [self.baseCollectionView addSubview:self.noDataLab];
}


// collectionCell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CYLiveCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CYLiveCollectionViewCell" forIndexPath:indexPath];
    
    
    // 联系他按钮：点击事件
    [cell.liveContactBtn addTarget:self action:@selector(connectBtnClickWithConnectBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    // 联系他：button：添加到最上层
    [cell bringSubviewToFront:cell.liveContactBtn.superview];
    [cell bringSubviewToFront:cell.liveContactBtn];
    
    
    // 模型赋值
    CYLiveCollectionViewCellModel *model = self.dataArray[indexPath.row];
    
    // 直播状态标题
    model.liveStatusTitle = @"预告";
    
    // 直播状态背景图
    model.liveStatusBgImgName = @"直播预告";
    
    // 观看人数
    model.isWatchCount = NO;
    
    cell.liveCellModel = model;
    
    return cell;
    
}

// 选中了collectionCell：点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了第 %ld 个collectionCell",(long)indexPath.row);
    
    
    //    // 融云SDK
    //    // 新建一个聊天会话viewController 对象
    //    CYChatVC *chatVC = [[CYChatVC alloc] init];
    //
    //
    //
    //    // 设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    //
    //    // 聊天室
    //    chatVC.conversationType = ConversationType_CHATROOM;
    //
    //    // 模型
    ////    CYMyFriendViewCellModel *tempMyFriendModel = self.dataArray[indexPath.row];
    //
    //    // 设置会话的目标会话ID。（单聊、客服、公众服务号会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    //    chatVC.targetId = @"聊天室1";
    //
    //    // 设置聊天会话界面要显示的标题
    //    chatVC.title = @"聊天室1~~";
    //
    //    chatVC.hidesBottomBarWhenPushed = YES;
    //
    //    // 显示聊天会话界面
    //    [self.navigationController pushViewController:chatVC animated:YES];
    //
    //    self.hidesBottomBarWhenPushed = NO;
    
    
    // 模型
    CYLiveCollectionViewCellModel *liveCellModel = self.dataArray[indexPath.row];
    
    // 直播详情页
    CYLivePlayDetailsVC *livePlayDetailsVC = [[CYLivePlayDetailsVC alloc] init];
    
    
    
    livePlayDetailsVC.liveID = liveCellModel.LiveId;
    livePlayDetailsVC.isTrailer = YES;
    
    //  导航条设置为不透明的（这样创建的视图（0，0）点，是在导航条左下角开始的。）
    UINavigationController *tempVideoNav = [CYUtilities createDefaultNavCWithRootVC:livePlayDetailsVC BgColor:nil TintColor:[UIColor whiteColor] translucent:NO titleColor:[UIColor whiteColor] title:@"" bgImg:[UIImage imageNamed:@"Title1"]];
    
    [self showViewController:tempVideoNav sender:self];
    
//    self.parentViewController.hidesBottomBarWhenPushed = YES;
//    [self showViewController:livePlayDetailsVC sender:self];
    
}

@end
