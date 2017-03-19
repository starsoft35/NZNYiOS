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


// 直播详情页:VC
//#import "CYLivePlayDetailsVC.h"


// 阿里播放器和融云IM：界面：VC
#import "CYLiveALiPlayAndRCIMVC.h"


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
            
            
            // 先把没有数据label删除
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
    
    self.noDataLab = [[UILabel alloc] initWithFrame:CGRectMake((12.0 / 750.0) * cScreen_Width, (80.0 / 1334.0) * cScreen_Height, (726.0 / 750.0) * cScreen_Width, (30.0 / 1334.0) * cScreen_Height)];
    
    
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
    
    
    // 他人直播模型
    CYOtherLiveCellModel *liveCellModel = self.liveListDataArr[indexPath.row];
    
    // 判断是否正在直播
    // 如果是正在直播，则可以进入下级界面(CYOtherLiveCellModel。Status == 4，为正在直播状态)
    if (liveCellModel.Status == 4) {
        
        
        // 网络请求：进入直播间
        [self requestAudienceEnterLiveRoomWithLiveId:liveCellModel.LiveId andOppUserId:self.oppUserId andDiscussionId:liveCellModel.LiveId];
        
    }
    // 如果不是正在直播，则不能进入
    else {
        
    }
    
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
    
    // 关闭所有的前台消息提示音
    [RCIM sharedRCIM].disableMessageAlertSound = YES;
    
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
    
    //    aliPlayAndRCIMVC.targetId = @"ChatRoom01";
    NSLog(@"play:targetId:%@",aliPlayAndRCIMVC.targetId);
    
    // 自定义需要的
    aliPlayAndRCIMVC.playUrl = playUrl;
    aliPlayAndRCIMVC.oppUserId = oppUserId;
    aliPlayAndRCIMVC.liveID = liveId;
    // 观众在直播间的拥有的id，用于观众离开直播间时调用；
    aliPlayAndRCIMVC.liveRoomId = LiveRoomId;
    //    aliPlayAndRCIMVC.liveRoomId = @"ChatRoom01";
    
    UINavigationController *tempLiveNav = [CYUtilities createDefaultNavCWithRootVC:aliPlayAndRCIMVC BgColor:nil TintColor:[UIColor whiteColor] translucent:NO titleColor:[UIColor whiteColor] title:@"" bgImg:[UIImage imageNamed:@"Title1"]];
    
//    [aliPlayAndRCIMVC.navigationController setNavigationBarHidden:YES animated:YES];
    
//    [self showViewController:tempVideoNav sender:self];
    
    
    
    
    
    
    
    
    
    
    
    NSInteger tmpCount = [self navigationControllerWithView:self.view].viewControllers.count;
    NSInteger tmpFlag = 0;
    BOOL ifHaveVC = NO;
    
    for (UIViewController *controller in [self navigationControllerWithView:self.view].viewControllers) {
        
        tmpFlag ++;
        
        if ([controller isKindOfClass:[CYLiveALiPlayAndRCIMVC class]]) {
            
            [[self navigationControllerWithView:self.view] popToViewController:controller animated:YES];
            //                                [self showViewController:controller sender:self];
            
            ifHaveVC = YES;
            
        }
        else if (tmpCount == tmpFlag && ifHaveVC == NO){
            
            
            
            //                                [self.navigationController pushViewController:tempVideoNav animated:YES];
            //
            //                                [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
            
            
            
//            [self showViewController:tempLiveNav sender:self];
            
            
            
            [[self navigationControllerWithView:self.view] pushViewController:aliPlayAndRCIMVC animated:YES];
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}


// cell 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return (88.0 / 1334.0) * cScreen_Height;
}

// header 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}


@end
