//
//  CYMyLiveTrailerVC.m
//  nzny
//
//  Created by 男左女右 on 2016/12/11.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYMyLiveTrailerVC.h"


// 我的直播预告cell
#import "CYMyLiveTrailerCell.h"


// cell：模型
#import "CYMyLiveTrailerCellModel.h"


// 直播推流界面：VC
#import "CYLivePushDetailsVC.h"


// 阿里直播推流详情页：VC
#import "AlivcLiveViewController.h"
// 阿里直播推流和融云IM详情页
#import "CYMyLiveAliLiveAndRCIMVC.h"




#define cCollectionCellWidth ((340.0 / 750.0) * self.view.frame.size.width)
#define cCollectionCellHeight (195)
//#define cCollectionCellHeight ((390.0 / 1334.0) * self.view.frame.size.height)
#define cCellMinLine ((20.0 / 750.0) * self.view.frame.size.width)
#define cCellMinInteritem ((20.0 / 1334.0) * self.view.frame.size.height)
#define cCellEdgeTop ((10.0 / 1334.0) * self.view.frame.size.height)
#define cCellEdgeLeft ((25.0 / 750.0) * self.view.frame.size.width)
#define cCellEdgeDown ((50.0 / 1334.0) * self.view.frame.size.height)
#define cCellEdgeRight ((25.0 / 750.0) * self.view.frame.size.width)

@interface CYMyLiveTrailerVC ()

@end

@implementation CYMyLiveTrailerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 背景颜色
    self.view.backgroundColor = [UIColor redColor];
    
    
    // 直播：首次进入加载，其他时候手动加载。
    // cell Header重新加载：自带加载数据
    [self.baseCollectionView.header beginRefreshing];
    
    // 提前注册
    [self.baseCollectionView registerNib:[UINib nibWithNibName:@"CYMyLiveTrailerCell" bundle:nil] forCellWithReuseIdentifier:@"CYMyLiveTrailerCell"];
    
    // 加载数据
//    [self loadData];
}

// 加载数据
- (void)loadData{
    
    // 网络请求：我的直播预告
    NSDictionary *params = @{
                             @"userId":self.onlyUser.userID
                             };
    
    //    [self showLoadingView];
    
    // 网络请求：直播详情页
    [CYNetWorkManager getRequestWithUrl:cMyLiveTrailerListUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取我的直播预告进度：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"我的直播预告：请求成功！");
        
        
        
        // 停止刷新
        [self.baseCollectionView.header endRefreshing];
        [self.baseCollectionView.footer endRefreshing];
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"我的直播预告：获取成功！");
            NSLog(@"我的直播预告：%@",responseObject);
            
            // 清空：每次刷新都需要
            [self.dataArray removeAllObjects];
            
            // 解析数据，模型存到数组
            [self.dataArray addObjectsFromArray:[CYMyLiveTrailerCellModel arrayOfModelsFromDictionaries:responseObject[@"res"][@"data"][@"list"]]];
            
            [self.baseCollectionView reloadData];
            
            // 请求数据结束，取消加载
//            [self hidenLoadingView];
            
        }
        else{
            NSLog(@"我的直播预告：获取失败:responseObject:%@",responseObject);
            NSLog(@"我的直播预告：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"我的直播预告：请求失败！");
        NSLog(@"失败原因：error：%@",error);        
        
        // 停止刷新
        [self.baseCollectionView.header endRefreshing];
        [self.baseCollectionView.footer endRefreshing];
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
    
}


// collectionCell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CYMyLiveTrailerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CYMyLiveTrailerCell" forIndexPath:indexPath];
    
    
    // 分享按钮：点击事件
    [cell.shareBtn addTarget:self action:@selector(shareBtnClickWithConnectBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    // 联系他：button：添加到最上层
    [cell bringSubviewToFront:cell.shareBtn.superview];
    [cell bringSubviewToFront:cell.shareBtn];
    
    
    // 模型赋值
    CYMyLiveTrailerCellModel *model = self.dataArray[indexPath.row];

//    // 直播状态标题
//    model.liveStatusTitle = @"正在直播";
//    
//    // 直播状态背景图
//    //    model.liveStatusBgImgName = @"直播预告";
//    
//    // 观看人数
//    model.isWatchCount = YES;
//    
    cell.myLiveTrailerCellModel = model;
//    cell.liveStatusTitleLab.textColor = [UIColor colorWithRed:0.91 green:0.51 blue:0.23 alpha:1.00];
    
    return cell;
    
}


// shareBtn：分享
- (void)shareBtnClickWithConnectBtn:(UIButton *)shareBtn{
    NSLog(@"分享shareBtn:点击事件");
    
    
    // collectionViewCell上面button的父类 的父类 为collectionViewCell：因为connectBtn上多一个View，所以要多一个superView
    UICollectionViewCell *tempView = (UICollectionViewCell *)[[[shareBtn superview] superview] superview];
    
    // collectionView类 调用方法，获取cell的indexPath
    NSIndexPath *indexPath = [self.baseCollectionView indexPathForCell:tempView];
    
    NSLog(@"当前的cell：%ld",(long)indexPath.row);
    
    // 模型：当前选中的cell
//    CYLiveCollectionViewCellModel *liveCellModel = self.dataArray[indexPath.row];
    
    
#warning 分享：网络请求
    // 网络请求：分享
    // 参数
    
    
    
}

// 选中了collectionCell：点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了第 %ld 个collectionCell",(long)indexPath.row);
    
    
    // 模型
    CYMyLiveTrailerCellModel *model = self.dataArray[indexPath.row];
    
    // 结束时间
    NSString *tempTopTime = [model.PlanStartTime substringToIndex:10];
    NSString *tempBottomTime = [model.PlanStartTime substringFromIndex:12];
    NSString *tempHourTime = [model.PlanStartTime substringWithRange:NSMakeRange(11, 1)];
    NSInteger hour = tempHourTime.integerValue + 1;
    NSString *tempLivePlanEndTime = [NSString stringWithFormat:@"%@%ld%@",tempTopTime,(long)hour,tempBottomTime];
    
    
    // 网络请求：获取直播推流、拉流授权
//    [self requestGetPushAndPlayPermissionWithLiveid:model.LiveId andPlanStartTime:model.PlanStartTime andPlanEndTime:tempLivePlanEndTime];
    
    
    
    // 网络请求：开始直播：获取直播地址
    [self requestStartLiveWithLiveId:model.LiveId];
    
    
    // 直播状态
//    if (model.IsEnter) {
        
        // 如果是可以进入，则进入主播详情页，拉流、聊天开始
#warning 我的直播详情页
//        CYLivePushDetailsVC *livePushDetailsVC = [[CYLivePushDetailsVC alloc] init];
//        
//        [self.navigationController pushViewController:livePushDetailsVC animated:YES];
    
        
        // 直播推流详情页
//        CYLivePushDetailsVC *livePlayDetailsVC = [[CYLivePushDetailsVC alloc] init];
//        
//        livePlayDetailsVC.liveID = model.LiveId;
//        
//        //  导航条设置为不透明的（这样创建的视图（0，0）点，是在导航条左下角开始的。）
//        UINavigationController *tempVideoNav = [CYUtilities createDefaultNavCWithRootVC:livePlayDetailsVC BgColor:nil TintColor:[UIColor whiteColor] translucent:NO titleColor:[UIColor whiteColor] title:@"" bgImg:[UIImage imageNamed:@"Title1"]];
//        
//        
//        [self showViewController:tempVideoNav sender:self];
    
    
    
    
    
    
    
//    // 阿里直播推流详情页
////    NSString *newUrl = @"rtmp://video-center.alivecdn.com/AppName/StreamName?vhost=live.nznychina.com";
//    NSString *newUrl = @"rtmp://video-center.alivecdn.com/zcy/s1?vhost=live.nznychina.com";
//    
//    AlivcLiveViewController *liveVC = [[AlivcLiveViewController alloc] initWithNibName:@"AlivcLiveViewController" bundle:nil url:newUrl];
////    liveVC.view.frame = self.view.frame;
//    
//    liveVC.liveID = model.LiveId;
//    liveVC.isScreenHorizontal = NO;
////    [self presentViewController:live animated:YES completion:nil];
//    
//    UINavigationController *tempVideoNav = [CYUtilities createDefaultNavCWithRootVC:liveVC BgColor:nil TintColor:[UIColor whiteColor] translucent:NO titleColor:[UIColor whiteColor] title:@"" bgImg:[UIImage imageNamed:@"Title1"]];
//    [liveVC.navigationController setNavigationBarHidden:YES animated:YES];
//    [self showViewController:tempVideoNav sender:self];
    
    
    
    
    
    
//    [self.navigationController pushViewController:tempVideoNav animated:YES];
//    }
//    else {
//        
//        // 如果不可以进入，弹窗提示
//        [self showHubWithLabelText:@"可提前三分钟进入直播间" andHidAfterDelay:3.0];
//    }
    
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
//    CYLiveCollectionViewCellModel *liveCellModel = self.dataArray[indexPath.row];
//    
//    // 主播详情页
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

// 网络请求：开始直播：获取直播地址
- (void)requestStartLiveWithLiveId:(NSString *)liveId{
    NSLog(@"网络请求：开始直播");
    
    // 网络请求：开始直播
    NSString *newUrl = [NSString stringWithFormat:@"%@?id=%@",cStartLiveUrl,liveId];
    
    [self showLoadingView];
    
    // 网络请求：开始直播
    [CYNetWorkManager postRequestWithUrl:newUrl params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取开始直播进度：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"开始直播：请求成功！");
        
        
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"开始直播：获取成功！");
            NSLog(@"开始直播：%@",responseObject);
            
            
            // 请求数据结束，取消加载
            [self hidenLoadingView];
            
            NSString *livePushUrl = responseObject[@"res"][@"data"][@"url"];
            NSString *expectEndTimestamp = responseObject[@"res"][@"data"][@"timestamp"];
            
            // 打开直播
            // 阿里直播推流和融云IM详情页
            //            [self addLiveALiPushAndRCIMVCWithPushUrl:newUrl andLiveId:liveid andOppUserId:self.onlyUser.userID];
            [self addLiveALiPushAndRCIMVCWithPushUrl:livePushUrl andLiveId:liveId andOppUserId:self.onlyUser.userID andExpectEndTimestamp:expectEndTimestamp];
            
        }
        else{
            NSLog(@"开始直播：获取失败:responseObject:%@",responseObject);
            NSLog(@"开始直播：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"开始直播：请求失败！");
        NSLog(@"失败原因：error：%@",error);
        
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
}

// 网络请求：获取直播推流、拉流授权
- (void)requestGetPushAndPlayPermissionWithLiveid:(NSString *)liveid andPlanStartTime:(NSString *)PlanStartTime andPlanEndTime:(NSString *)PlanEndTime{
    NSLog(@"网络请求：获取直播推流、拉流授权");
    NSString *newToken = [NSString stringWithFormat:@"bearer %@",self.onlyUser.userToken];
    
    
    // 网络请求：获取直播推流、拉流授权
    NSDictionary *params = @{
                             @"userid":self.onlyUser.userID,
                             @"token":self.onlyUser.userToken
                             };
//    NSString *newUrl = [NSString stringWithFormat:@"%@?userid=%@",cPushAndPlayPermissionUrl,self.onlyUser.userID];
    
    [self showLoadingView];
    
    // 获取 请求管理类 对象
    //        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 可以设置主机地址，然后让别的接口拼接进来。（AFNetWorking 会自动进行拼接，前提是你给了baseURL）
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
            [self requestGetLiveUrlWithUid:uid andUtoken:utoken andLiveid:liveid andPlanStartTime:PlanStartTime andPlanEndTime:PlanEndTime];
            
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

// 网络请求：获取直播地址：推流
- (void)requestGetLiveUrlWithUid:(NSString *)uid andUtoken:(NSString *)utoken andLiveid:(NSString *)liveid andPlanStartTime:(NSString *)PlanStartTime andPlanEndTime:(NSString *)PlanEndTime{
    NSLog(@"网络请求：获取直播地址：推流");
    
    // 网络请求：获取直播地址
    NSDictionary *params = @{
                             @"uid":uid,
                             @"utoken":utoken,
                             @"userid":self.onlyUser.userID,
                             @"owner":self.onlyUser.userID,
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
        NSLog(@"获取直播地址：推流进度：%@",uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"获取直播地址：推流：请求成功！");
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"1"]) {
            NSLog(@"获取直播地址：推流：获取成功！");
            NSLog(@"获取直播地址：推流：%@",responseObject);
            
            [self hidenLoadingView];
            
                // 阿里直播推流详情页
            //    NSString *newUrl = @"rtmp://video-center.alivecdn.com/AppName/StreamName?vhost=live.nznychina.com";
//                NSString *newUrl = @"rtmp://video-center.alivecdn.com/zcy/s1?vhost=live.nznychina.com";
            NSString *newUrl = responseObject[@"url"];
            NSLog(@"newPushUrl：%@",newUrl);
            
            
            
            // 阿里直播推流详情页
//            [self addLiveALiPushVCWithPushUrl:newUrl andLiveId:liveid];
            
            
//            NSString *tempUrl = @"rtmp://106.14.61.197:1935/rtmplive/l7d763d4a093ac8cb65f7d1b0eb5bbb43";
            
            
            
            // 阿里直播推流和融云IM详情页
//            [self addLiveALiPushAndRCIMVCWithPushUrl:newUrl andLiveId:liveid andOppUserId:self.onlyUser.userID];
//            [self addLiveALiPushAndRCIMVCWithPushUrl:newUrl andLiveId:liveid andOppUserId:self.onlyUser.userID];
            
            
            
        }
        else{
            NSLog(@"获取直播地址：推流：获取失败:responseObject:%@",responseObject);
            NSLog(@"获取直播地址：推流：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取直播地址：推流：请求失败！");
        NSLog(@"失败原因：error：%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
        
    }];
    
}


// 阿里直播推流和融云IM详情页
- (void)addLiveALiPushAndRCIMVCWithPushUrl:(NSString *)pushUrl andLiveId:(NSString *)liveId andOppUserId:(NSString *)oppUserId andExpectEndTimestamp:(NSString *)expectEndTimestamp{
    NSLog(@"阿里直播推流和融云IM详情页");
    
    CYMyLiveAliLiveAndRCIMVC *livePushVC = [[CYMyLiveAliLiveAndRCIMVC alloc] init];
    //    liveVC.view.frame = self.view.frame;
    
    livePushVC.conversationType = ConversationType_CHATROOM;
    livePushVC.targetId = oppUserId;
    
    
    // 自定义所需的信息
    livePushVC.pushUrl = pushUrl;
    livePushVC.liveID = liveId;
    livePushVC.expectEndTimestamp = expectEndTimestamp;
//    liveVC.isScreenHorizontal = NO;
    //    [self presentViewController:live animated:YES completion:nil];
    
    UINavigationController *tempVideoNav = [CYUtilities createDefaultNavCWithRootVC:livePushVC BgColor:nil TintColor:[UIColor whiteColor] translucent:NO titleColor:[UIColor whiteColor] title:@"" bgImg:[UIImage imageNamed:@"Title1"]];
    [livePushVC.navigationController setNavigationBarHidden:YES animated:YES];
    [self showViewController:tempVideoNav sender:self];
    
}


// 阿里直播推流详情页
- (void)addLiveALiPushVCWithPushUrl:(NSString *)pushUrl andLiveId:(NSString *)liveId{
    NSLog(@"阿里直播推流详情页");
    
    AlivcLiveViewController *liveVC = [[AlivcLiveViewController alloc] initWithNibName:@"AlivcLiveViewController" bundle:nil url:pushUrl];
    //    liveVC.view.frame = self.view.frame;
    
    liveVC.liveID = liveId;
    liveVC.isScreenHorizontal = NO;
    //    [self presentViewController:live animated:YES completion:nil];
    
    UINavigationController *tempVideoNav = [CYUtilities createDefaultNavCWithRootVC:liveVC BgColor:nil TintColor:[UIColor whiteColor] translucent:NO titleColor:[UIColor whiteColor] title:@"" bgImg:[UIImage imageNamed:@"Title1"]];
    [liveVC.navigationController setNavigationBarHidden:YES animated:YES];
    [self showViewController:tempVideoNav sender:self];
    
}


// 设置cell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(cCollectionCellWidth, cCollectionCellHeight);
    
}

// 设置cell 的 边界距离
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    // 上、左、下、右
    return UIEdgeInsetsMake(cCellEdgeTop, cCellEdgeLeft, cCellEdgeDown, cCellEdgeRight);
}




@end
