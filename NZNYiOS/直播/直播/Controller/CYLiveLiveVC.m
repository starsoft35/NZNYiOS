//
//  CYLiveLiveVC.m
//  nzny
//
//  Created by 男左女右 on 2016/11/22.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYLiveLiveVC.h"


// 直播cell模型
#import "CYLiveCollectionViewCellModel.h"

// 直播cell
#import "CYLiveCollectionViewCell.h"

// 直播详情页:VC
#import "CYLivePlayDetailsVC.h"

// 聊天界面：VC
#import "CYChatVC.h"

// 阿里播放器：界面：VC
#import "AliVcMoiveViewController.h"


// 融云播放界面：
#import "RCDLiveChatRoomViewController.h"
// 管理融云核心类
#import "RCDLive.h"


// 阿里播放器和融云IM：界面：VC
#import "CYLiveALiPlayAndRCIMVC.h"



@interface CYLiveLiveVC ()

@end

@implementation CYLiveLiveVC

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
    [CYNetWorkManager getRequestWithUrl:cLiveOnAirListUrl params:params progress:^(NSProgress *uploadProgress) {
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
    
    self.noDataLab = [[UILabel alloc] initWithFrame:CGRectMake((12.0 / 750.0) * self.view.frame.size.width, (80.0 / 1334.0) * self.view.frame.size.height, (726.0 / 750.0) * self.view.frame.size.width, (30.0 / 1334.0) * self.view.frame.size.height)];
    
    
    self.noDataLab.text = @"暂时没有正在进行的直播";
    
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
    model.liveStatusTitle = @"正在直播";
    
    // 直播状态背景图
//    model.liveStatusBgImgName = @"直播预告";
    
    // 观看人数
    model.isWatchCount = YES;
    
    cell.liveCellModel = model;
    cell.liveStatusTitleLab.textColor = [UIColor colorWithRed:0.91 green:0.51 blue:0.23 alpha:1.00];
    
    return cell;
    
}

// 选中了collectionCell：点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了第 %ld 个collectionCell",(long)indexPath.row);
    
    CYLiveCollectionViewCellModel *model = self.dataArray[indexPath.row];
    
    
    // 网络请求：进入直播间
    [self requestAudienceEnterLiveRoomWithLiveId:model.LiveId andOppUserId:model.LiveUserId andDiscussionId:model.DiscussionId];
    
}

// 网络请求：观众进入直播间
- (void)requestAudienceEnterLiveRoomWithLiveId:(NSString *)liveId andOppUserId:(NSString *)oppUserId andDiscussionId:(NSString *)discussionId{
    NSLog(@"网络请求：观众进入直播间");
    
    // 网络请求：观众进入直播间
    // 新地址
    NSString *newUrl = [NSString stringWithFormat:@"%@?userId=%@&liveId=%@",cEnterLiveRoomUrl,self.onlyUser.userID,liveId];
    
    
    [self showLoadingView];
    
    // 网络请求：观众进入直播间
    [CYNetWorkManager postRequestWithUrl:newUrl params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取观众进入直播间进度：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"观众进入直播间：请求成功！");
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"观众进入直播间：获取成功！");
            NSLog(@"观众进入直播间：%@",responseObject);
            
            // 取消加载
            [self hidenLoadingView];
            
            // 直播间Id
            NSString *liveRoomId = responseObject[@"res"][@"data"][@"liveRoomId"];
//            liveRoomId = @"f643314d-0e29-4e16-915d-b36364c46416";
            
            // 直播播放地址
            NSString *livePlayUrl = responseObject[@"res"][@"data"][@"url"];
            
            NSLog(@"livePlayUrl:%@",livePlayUrl);
            
            
            // 连接RCDLive
            [self connectRCDLiveWithUrl:livePlayUrl andOppUserId:oppUserId andLiveId:liveId andLiveRoomId:liveRoomId andDiscussionId:discussionId];
            
            
            // 阿里播放和融云IM界面：VC
//            [self pushAliPlayAndRCIMVCWithUrl:livePlayUrl andOppUserId:userId andLiveId:liveId andLiveRoomId:liveRoomId andDiscussionId:discussionId];
            
            
        }
        else{
            NSLog(@"观众进入直播间：获取失败:responseObject:%@",responseObject);
            NSLog(@"观众进入直播间：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"观众进入直播间：请求失败！");
        NSLog(@"失败原因：error：%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
}



// 连接RCDLive
- (void)connectRCDLiveWithUrl:(NSString *)livePlayUrl andOppUserId:(NSString *)oppUserId andLiveId:(NSString *)liveId andLiveRoomId:(NSString *)liveRoomId andDiscussionId:(NSString *)discussionId{
    NSLog(@"连接RCDLive");
    
    
    
    
    
    // 请求数据：获取用户在融云的token
    NSDictionary *params = @{
                             @"userId":self.onlyUser.userID
                             };
    
    // 请求数据：获取用户在融云的token
    [CYNetWorkManager getRequestWithUrl:cRongTokenUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取用户在融云的token进度：%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"获取用户在融云的token：请求成功！");
        
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"获取用户在融云的token：获取成功！");
            NSLog(@"获取用户在融云的token：%@",responseObject);
            
            NSString *rongToken = [[NSString alloc] init];
            
            rongToken = responseObject[@"res"][@"data"][@"rongToken"];
            
            
            // 融云：初始化：使用RCDLive进行初始化
            [self setRongCloudWithRCDLiveWithUrl:livePlayUrl andOppUserId:oppUserId andLiveId:liveId andLiveRoomId:liveRoomId andDiscussionId:discussionId];
            
        }
        else{
            NSLog(@"获取用户在融云的token：获取失败:responseObject:%@",responseObject);
            NSLog(@"获取用户在融云的token：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            //            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"获取用户在融云的token：请求失败！:error:%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
        
    } withToken:self.onlyUser.userToken];
    
}


// 融云：初始化：使用RCDLive进行初始化
- (void)setRongCloudWithRCDLiveWithUrl:(NSString *)livePlayUrl andOppUserId:(NSString *)oppUserId andLiveId:(NSString *)liveId andLiveRoomId:(NSString *)liveRoomId andDiscussionId:(NSString *)discussionId{
    
    
    [[RCDLive sharedRCDLive] initRongCloud:cRongAppKey];
    
    //注册自定义消息：送礼
    [[RCDLive sharedRCDLive] registerRongCloudMessageType:[RCDLiveGiftMessage class]];
    
    // 阿里播放和融云IM界面：VC
    [self pushAliPlayAndRCIMVCWithUrl:livePlayUrl andOppUserId:oppUserId andLiveId:liveId andLiveRoomId:liveRoomId andDiscussionId:discussionId];
    
    
}


// 阿里播放和融云IM界面：VC
- (void)pushAliPlayAndRCIMVCWithUrl:(NSString *)playUrl andOppUserId:(NSString *)oppUserId andLiveId:(NSString *)liveId andLiveRoomId:(NSString *)LiveRoomId andDiscussionId:(NSString *)discussionId{
    NSLog(@"阿里播放和融云IM界面：VC");
    
    CYLiveALiPlayAndRCIMVC *aliPlayAndRCIMVC = [[CYLiveALiPlayAndRCIMVC alloc] init];
    
    aliPlayAndRCIMVC.conversationType = ConversationType_CHATROOM;
    
    // targetId：为聊天室Id，由直播详情页给出
    aliPlayAndRCIMVC.targetId = discussionId;
    aliPlayAndRCIMVC.targetId = oppUserId;
//    aliPlayAndRCIMVC.targetId = self.onlyUser.userID;
    aliPlayAndRCIMVC.targetId = liveId;
    NSLog(@"play:targetId:%@",aliPlayAndRCIMVC.targetId);
    
    // 自定义需要的
    aliPlayAndRCIMVC.playUrl = playUrl;
    aliPlayAndRCIMVC.oppUserId = oppUserId;
    aliPlayAndRCIMVC.liveID = liveId;
    // 观众在直播间的拥有的id，用于观众离开直播间时调用；
    aliPlayAndRCIMVC.liveRoomId = LiveRoomId;
    
    UINavigationController *tempVideoNav = [CYUtilities createDefaultNavCWithRootVC:aliPlayAndRCIMVC BgColor:nil TintColor:[UIColor whiteColor] translucent:NO titleColor:[UIColor whiteColor] title:@"" bgImg:[UIImage imageNamed:@"Title1"]];
    
    [aliPlayAndRCIMVC.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self showViewController:tempVideoNav sender:self];
}

// 阿里播放界面：VC
- (void)pushALiPlayerViewControllerWithPlayUrl:(NSString *)playUrl{
    
    
    
//            NSString *newUrl = @"rtmp://106.14.61.197:1935/rtmplive/l01de63e610d1c28c647abb285334c55a";
    
    
    NSLog(@"newPlayUrl：%@",playUrl);
    
    TBMoiveViewController *aLiPlayerVC = [[TBMoiveViewController alloc] init];
    //        NSString* strUrl = urlField.text;
    
    
    NSURL* url = [NSURL URLWithString:playUrl];
    
    
    if(url == nil) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"错误" message:@"输入地址无效" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alter show];
        return;
    }
    [aLiPlayerVC SetMoiveSource:url];
    
    //    [self presentViewController:currentView animated:YES completion:nil ];
    UINavigationController *tempVideoNav = [CYUtilities createDefaultNavCWithRootVC:aLiPlayerVC BgColor:nil TintColor:[UIColor whiteColor] translucent:NO titleColor:[UIColor whiteColor] title:@"" bgImg:[UIImage imageNamed:@"Title1"]];
    
    [aLiPlayerVC.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self showViewController:tempVideoNav sender:self];
    
}


// 融云播放界面：
- (void)pushRongCloudPlayView{
    
    // 融云播放界面：
    RCDLiveChatRoomViewController *chatRoomVC = [[RCDLiveChatRoomViewController alloc]init];
    chatRoomVC.conversationType = ConversationType_CHATROOM;
    chatRoomVC.targetId = @"ChatRoom01";
    //    chatRoomVC.contentURL = videoUrl;
    //    chatRoomVC.isScreenVertical = _isScreenVertical;
    //    [self.navigationController setNavigationBarHidden:YES];
    //    [self.navigationController pushViewController:chatRoomVC animated:NO];
    
    
    
    UINavigationController *tempVideoNav = [CYUtilities createDefaultNavCWithRootVC:chatRoomVC BgColor:nil TintColor:[UIColor whiteColor] translucent:NO titleColor:[UIColor whiteColor] title:@"" bgImg:[UIImage imageNamed:@"Title1"]];
    
    [chatRoomVC.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self showViewController:tempVideoNav sender:self];
    
    
}




@end
