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
            
            // 解析数据，模型存到数组
            [self.dataArray addObjectsFromArray:[CYLiveCollectionViewCellModel arrayOfModelsFromDictionaries:responseObject[@"res"][@"data"][@"list"]]];
            
            
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


// collectionCell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
//    CYLiveCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CYLiveCollectionViewCell" forIndexPath:indexPath];
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
    NSLog(@"选中了第 %ld 个collectionCell",indexPath.row);
    
    CYLiveCollectionViewCellModel *model = self.dataArray[indexPath.row];
    
    // 结束时间
//    NSString *tempTopTime = [model.PlanStartTime substringToIndex:10];
//    NSString *tempBottomTime = [model.PlanStartTime substringFromIndex:12];
//    NSString *tempHourTime = [model.PlanStartTime substringWithRange:NSMakeRange(11, 1)];
//    NSInteger hour = tempHourTime.integerValue + 1;
//    NSString *tempLivePlanEndTime = [NSString stringWithFormat:@"%@%ld%@",tempTopTime,(long)hour,tempBottomTime];
    NSString *tempLivePlanEndTime = @"2016-12-12 21:00:00";
    
    // 开始时间
    NSString *tempPlanStartTime = @"2016-12-12 20:00:00";
    
    // 网络请求：获取直播推流、拉流授权
    [self requestGetPushAndPlayPermissionWithLiveid:model.LiveId andPlanStartTime:tempPlanStartTime andPlanEndTime:tempLivePlanEndTime andLiveUserId:model.LiveUserId];
    
    
    
    
    
    
    
    
    
    
    
    // 模型
//    CYLiveCollectionViewCellModel *liveCellModel = self.dataArray[indexPath.row];
//
//    // 直播详情页：观众端
//    CYLivePlayDetailsVC *livePlayDetailsVC = [[CYLivePlayDetailsVC alloc] init];
//
//    livePlayDetailsVC.liveID = liveCellModel.LiveId;
//    livePlayDetailsVC.isTrailer = NO;
//
//    //  导航条设置为不透明的（这样创建的视图（0，0）点，是在导航条左下角开始的。）
//    UINavigationController *tempVideoNav = [CYUtilities createDefaultNavCWithRootVC:livePlayDetailsVC BgColor:nil TintColor:[UIColor whiteColor] translucent:NO titleColor:[UIColor whiteColor] title:@"" bgImg:[UIImage imageNamed:@"Title1"]];
//    
//    
//    [self showViewController:tempVideoNav sender:self];
    
    
}



// 网络请求：获取直播推流、拉流授权
- (void)requestGetPushAndPlayPermissionWithLiveid:(NSString *)liveid andPlanStartTime:(NSString *)PlanStartTime andPlanEndTime:(NSString *)PlanEndTime andLiveUserId:(NSString *)LiveUserId{
    NSLog(@"网络请求：获取直播推流、拉流授权");
    
    
    // 网络请求：获取直播推流、拉流授权
    NSDictionary *params = @{
                             @"userid":self.onlyUser.userID,
                             @"token":self.onlyUser.userToken
                             };
    
    //    [self showLoadingView];
    
    // 获取 请求管理类 对象
    //        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 可以设置主机地址，然后让别的接口拼接进来。（AFNetWorking 会自动进行拼接，前提是你给了baseURL）
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:cHostUrl]];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:cPushAndPlayHostUrl]];
    
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 头字段
    //    if (token != nil) {
    //
    //        NSString *newToken = [NSString stringWithFormat:@"bearer %@",self.onlyUser.userToken];
    //        [manager.requestSerializer setValue:newToken forHTTPHeaderField:@"Authorization"];
    //        NSLog(@"~~~~~~~Authorization：%@",newToken);
    //    }
    //    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    // 数据类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"application/xml", @"text/xml", nil];
    
    // 请求数据：POST
    [manager POST:cPushAndPlayPermissionUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"获取直播推流、拉流授权：进度：%@",uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取直播推流、拉流授权：请求成功！");
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"1"]) {
            NSLog(@"获取直播推流、拉流授权：获取成功！");
            NSLog(@"获取直播推流、拉流授权：%@",responseObject);
            
            
            // 网络请求：获取直播地址
            NSString *uid = responseObject[@"data"][@"uid"];
            NSString *utoken = responseObject[@"data"][@"utoken"];
            [self requestGetLiveUrlWithUid:uid andUtoken:utoken andLiveid:liveid andPlanStartTime:PlanStartTime andPlanEndTime:PlanEndTime andLiveUserId:LiveUserId];
            
        }
        else{
            NSLog(@"获取直播推流、拉流授权：获取失败:responseObject:%@",responseObject);
            NSLog(@"获取直播推流、拉流授权：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"msg"] andHidAfterDelay:3.0];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取直播推流、拉流授权：推流：请求失败！");
        NSLog(@"失败原因：error：%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
        
    }];
    
    
}

// 网络请求：获取直播地址：拉流
- (void)requestGetLiveUrlWithUid:(NSString *)uid andUtoken:(NSString *)utoken andLiveid:(NSString *)liveid andPlanStartTime:(NSString *)PlanStartTime andPlanEndTime:(NSString *)PlanEndTime andLiveUserId:(NSString *)LiveUserId{
    NSLog(@"网络请求：获取直播地址：拉流");
    
    // 网络请求：获取直播地址
    NSDictionary *params = @{
                             @"uid":uid,
                             @"utoken":utoken,
                             @"userid":self.onlyUser.userID,
                             @"owner":LiveUserId,
                             @"liveid":liveid,
                             @"PlanStartTime":PlanStartTime,
                             @"PlanEndTime":PlanEndTime,
                             };
    
    //    [self showLoadingView];
    
    
    
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:cPushAndPlayHostUrl]];
    
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 头字段
    //    if (token != nil) {
    //
    //        NSString *newToken = [NSString stringWithFormat:@"bearer %@",self.onlyUser.userToken];
    //        [manager.requestSerializer setValue:newToken forHTTPHeaderField:@"Authorization"];
    //        NSLog(@"~~~~~~~Authorization：%@",newToken);
    //    }
    //    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    // 数据类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"application/xml", @"text/xml", nil];
    
    // 请求数据：POST
    [manager POST:cMyLiveGetPushUrl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"获取直播地址：拉流进度：%@",uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取直播地址：拉流：请求成功！");
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"1"]) {
            NSLog(@"获取直播地址：拉流：获取成功！");
            NSLog(@"获取直播地址：拉流：%@",responseObject);
            
            
            
            
            //            NSString *tempUrl = @"rtmp://106.14.61.197:1935/rtmplive/l01de63e610d1c28c647abb285334c55a";
            NSString *tempUrl = responseObject[@"url"];
            NSLog(@"playUrl:responseObject[url]:%@",tempUrl);
            
            
            // 网络请求：观众进入直播间
            [self requestAudienceEnterLiveRoomWithLiveId:liveid andnewLiveUrl:tempUrl andLiveUserId:LiveUserId];
            
            
            
        }
        else{
            NSLog(@"获取直播地址：拉流：获取失败:responseObject:%@",responseObject);
            NSLog(@"获取直播地址：拉流：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取直播地址：拉流：请求失败！");
        NSLog(@"失败原因：error：%@",error);
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
        
    }];
}

// 网络请求：观众进入直播间
- (void)requestAudienceEnterLiveRoomWithLiveId:(NSString *)liveId andnewLiveUrl:(NSString *)newLiveUrl andLiveUserId:(NSString *)liveUserId{
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
            NSString *liveRoomId = responseObject[@"res"][@"liveRoomId"];
            
            // 融云播放界面：
            //            [self pushRongCloudPlayView];
            
            // 阿里播放界面：
            //            [self pushALiPlayerViewControllerWithPlayUrl:responseObject[@"url"]];
            //            [self pushALiPlayerViewControllerWithPlayUrl:tempUrl];
            
            
            // 阿里播放和融云IM界面：VC
            //            [self pushAliPlayAndRCIMVCWithUrl:responseObject[@"url"] andOppUserId:LiveUserId andLiveId:liveid];
            [self pushAliPlayAndRCIMVCWithUrl:newLiveUrl andOppUserId:liveUserId andLiveId:liveId andLiveRoomId:liveRoomId];
            
            
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


// 阿里播放和融云IM界面：VC
- (void)pushAliPlayAndRCIMVCWithUrl:(NSString *)playUrl andOppUserId:(NSString *)oppUserId andLiveId:(NSString *)liveId andLiveRoomId:(NSString *)LiveRoomId{
    NSLog(@"阿里播放和融云IM界面：VC");
    
    CYLiveALiPlayAndRCIMVC *aliPlayAndRCIMVC = [[CYLiveALiPlayAndRCIMVC alloc] init];
    
    aliPlayAndRCIMVC.conversationType = ConversationType_CHATROOM;
    aliPlayAndRCIMVC.targetId = oppUserId;
    
    
    // 自定义需要的
    aliPlayAndRCIMVC.playUrl = playUrl;
    aliPlayAndRCIMVC.oppUserId = oppUserId;
    aliPlayAndRCIMVC.liveID = liveId;
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
