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




#define cCollectionCellWidth ((340.0 / 750.0) * cScreen_Width)
#define cCollectionCellHeight (195)
//#define cCollectionCellHeight ((390.0 / 1334.0) * cScreen_Height)
#define cCellMinLine ((20.0 / 750.0) * cScreen_Width)
#define cCellMinInteritem ((20.0 / 1334.0) * cScreen_Height)
#define cCellEdgeTop ((10.0 / 1334.0) * cScreen_Height)
#define cCellEdgeLeft ((25.0 / 750.0) * cScreen_Width)
#define cCellEdgeDown ((50.0 / 1334.0) * cScreen_Height)
#define cCellEdgeRight ((25.0 / 750.0) * cScreen_Width)

@interface CYMyLiveTrailerVC ()

@end

@implementation CYMyLiveTrailerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 背景颜色
//    self.view.backgroundColor = [UIColor redColor];
    self.baseCollectionView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.00];
    
    
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
            
            
            if (self.dataArray.count == 0) {
                
                // 如果没有直播，添加提示
                [self addLabelToShowNoLive];
            }
            
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


// 如果没有直播，添加提示
- (void)addLabelToShowNoLive{
    NSLog(@"如果没有直播，添加提示");
    
    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake((12.0 / 750.0) * cScreen_Width, (80.0 / 1334.0) * cScreen_Height, (726.0 / 750.0) * cScreen_Width, (30.0 / 1334.0) * cScreen_Height)];
    
    
    tipLab.text = @"暂时没有直播预告";
    
    tipLab.textAlignment = NSTextAlignmentCenter;
    tipLab.font = [UIFont systemFontOfSize:15];
    
    tipLab.textColor = [UIColor colorWithRed:0.50 green:0.50 blue:0.50 alpha:1.00];
    
    [self.baseCollectionView addSubview:tipLab];
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
    
    // 分享：网页分享
    [self sharedToWeChatWithWebpageWithShareTitle:@"APP 下载地址" andDescription:@"男左女右 遇见你的TA" andImage:[UIImage imageNamed:@"logo.png"] andWebpageUrl:cDownLoadUrl andbText:NO andScene:0];
    
    
}

// 选中了collectionCell：点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了第 %ld 个collectionCell",(long)indexPath.row);
    
    
    // 模型
    CYMyLiveTrailerCellModel *model = self.dataArray[indexPath.row];
    
    
    // 网络请求：开始直播：获取直播地址
    [self requestStartLiveWithLiveId:model.LiveId];
    
    
    
}

// 网络请求：开始直播：获取直播地址：获取直播地址和timestamp
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
            
            
            
            
            // 连接RCDLive
            [self connectRCDLiveWithPushUrl:livePushUrl andLiveId:liveId andChatRoomId:liveId andExpectEndTimestamp:expectEndTimestamp];
            
            // 打开直播
            // 阿里直播推流和融云IM详情页
//            [self addLiveALiPushAndRCIMVCWithPushUrl:livePushUrl andLiveId:liveId andChatRoomId:liveId andExpectEndTimestamp:expectEndTimestamp];
            
            // 阿里直播推流详情页
//            [self addLiveALiPushVCWithPushUrl:livePushUrl andLiveId:liveId];
            
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


// 连接RCDLive
- (void)connectRCDLiveWithPushUrl:(NSString *)livePushUrl andLiveId:(NSString *)liveId andChatRoomId:(NSString *)chatRoomId andExpectEndTimestamp:(NSString *)expectEndTimestamp{
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
            [self setRongCloudWithRCDLiveWithPushUrl:livePushUrl andLiveId:liveId andChatRoomId:liveId andExpectEndTimestamp:expectEndTimestamp];
            
        }
        else{
            NSLog(@"获取用户在融云的token：获取失败:responseObject:%@",responseObject);
            NSLog(@"获取用户在融云的token：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"获取用户在融云的token：请求失败！:error:%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
        
    } withToken:self.onlyUser.userToken];
    
}

// 融云：初始化：使用RCDLive进行初始化
- (void)setRongCloudWithRCDLiveWithPushUrl:(NSString *)livePushUrl andLiveId:(NSString *)liveId andChatRoomId:(NSString *)chatRoomId andExpectEndTimestamp:(NSString *)expectEndTimestamp{
    
    
    [[RCDLive sharedRCDLive] initRongCloud:cRongAppKey];
    
    // 关闭所有的前台消息提示音
    [RCIM sharedRCIM].disableMessageAlertSound = YES;
    
    //注册自定义消息：送礼
    [[RCDLive sharedRCDLive] registerRongCloudMessageType:[RCDLiveGiftMessage class]];
    
    // 打开直播
    // 阿里直播推流和融云IM详情页
    [self addLiveALiPushAndRCIMVCWithPushUrl:livePushUrl andLiveId:liveId andChatRoomId:chatRoomId andExpectEndTimestamp:expectEndTimestamp];
    
    // 阿里直播推流详情页
//    [self addLiveALiPushVCWithPushUrl:livePushUrl andLiveId:liveId];
}

// 阿里直播推流和融云IM详情页
- (void)addLiveALiPushAndRCIMVCWithPushUrl:(NSString *)pushUrl andLiveId:(NSString *)liveId andChatRoomId:(NSString *)chatRoomId andExpectEndTimestamp:(NSString *)expectEndTimestamp{
    NSLog(@"阿里直播推流和融云IM详情页");
    
    CYMyLiveAliLiveAndRCIMVC *livePushVC = [[CYMyLiveAliLiveAndRCIMVC alloc] init];
    //    liveVC.view.frame = self.view.frame;
    
    livePushVC.conversationType = ConversationType_CHATROOM;
    // targetId：为聊天室Id，由直播详情页给出
    livePushVC.targetId = chatRoomId;
    livePushVC.targetId = self.onlyUser.userID;
    livePushVC.targetId = liveId;
//    livePushVC.targetId = @"1";
    NSLog(@"livePushVC.targetId:%@",livePushVC.targetId);
    
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
