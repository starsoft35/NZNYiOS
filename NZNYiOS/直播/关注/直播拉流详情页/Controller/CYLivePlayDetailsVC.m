//
//  CYLivePlayDetailsVC.m
//  nzny
//
//  Created by 男左女右 on 2016/12/10.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYLivePlayDetailsVC.h"

// 模型
#import "CYLivePlayDetailsViewModel.h"

// 观众列表：VC
#import "CYAudienceListVC.h"

// 联系他
// 是否为好友:模型
#import "CYVideoIsFriendModel.h"
// 聊天界面：VC
#import "CYChatVC.h"
// 加好友弹窗：VC
#import "CYAddFriendVC.h"

// 送礼弹窗：VC
#import "CYGiveGiftTipVC.h"

// 点赞弹窗：VC
#import "CYLikeTipVC.h"


// 他人详情页：VC
#import "CYOthersInfoVC.h"


@interface CYLivePlayDetailsVC ()

@end

@implementation CYLivePlayDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 加载数据
    [self loadData];
    
    // 添加视图
    [self addView];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // 显示导航栏
    self.navigationController.navigationBarHidden = NO;
    
}

// 加载数据
- (void)loadData{
    
    // 网络请求：直播详情页
    
    // 新地址
    NSDictionary *params = @{
                             @"userId":self.onlyUser.userID,
                             @"id":self.liveID
                             };
    
    [self showLoadingView];
    
    // 网络请求：直播详情页
    [CYNetWorkManager getRequestWithUrl:cLiveDetaillUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取直播详情页进度：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"直播详情页：请求成功！");
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"直播详情页：获取成功！");
            NSLog(@"直播详情页：%@",responseObject);
            
            // 清空：每次刷新都需要
            [self.dataArray removeAllObjects];
            
            // 解析数据，模型存到数组
//            [self.dataArray addObject:[[CYLivePlayDetailsViewModel alloc] initWithDictionary:responseObject[@"res"][@"data"][@"model"] error:nil]];
            
            // 模型
            CYLivePlayDetailsViewModel *tempLivePlayDetailsViewModel = [[CYLivePlayDetailsViewModel alloc] initWithDictionary:responseObject[@"res"][@"data"][@"model"] error:nil];
            
            tempLivePlayDetailsViewModel.isPlayView = YES;
            tempLivePlayDetailsViewModel.isTrailer = self.isTrailer;
            
            // 模型赋值
            _livePlayDetailsView.livePlayDetailsModel = tempLivePlayDetailsViewModel;
            
            self.oppUserId = tempLivePlayDetailsViewModel.LiveUserId;
            
            // 请求数据结束，取消加载
            [self hidenLoadingView];
            
            
        }
        else{
            NSLog(@"直播详情页：获取失败:responseObject:%@",responseObject);
            NSLog(@"直播详情页：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"直播详情页：请求失败！");
        NSLog(@"失败原因：error：%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
}

// 添加视图
- (void)addView{
    
    _livePlayDetailsView = [[[NSBundle mainBundle] loadNibNamed:@"CYLivePlayDetailsView" owner:nil options:nil] lastObject];
    
    _livePlayDetailsView.frame = self.view.frame;
    
#warning 添加聊天室界面
    if (self.isTrailer) {
        
        // 如果是预告，则显示标签、爱情宣言
        _livePlayDetailsView.connectBtn.hidden = NO;
        _livePlayDetailsView.sendGiftBtn.hidden = NO;
        _livePlayDetailsView.likeBtn.hidden = NO;
        _livePlayDetailsView.shareBtn.hidden = NO;
    }
    else {
        
        // 不是预告，则显示聊天界面，并·
        
    }
    
    // 观众列表
//    CYAudienceListVC *audienceListVC = [[CYAudienceListVC alloc] init];
//    audienceListVC.view.frame = _livePlayDetailsView.liveRoomPeopleListView.frame;
//    audienceListVC.baseCollectionView.frame = _livePlayDetailsView.liveRoomPeopleListView.frame;
//    NSLog(@"audienceListVC.view.frame.size.height：%lf",audienceListVC.view.frame.size.height);
//    
//    [_livePlayDetailsView.liveRoomPeopleListView addSubview:audienceListVC.view];
//    [_livePlayDetailsView.liveRoomPeopleListView addSubview:audienceListVC.baseCollectionView];
    
    
    
    
//    _livePlayDetailsView.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height);
    
    
    // 上部头部：手势
    _livePlayDetailsView.topHeadNameFIDFollorView.userInteractionEnabled = YES;
    [_livePlayDetailsView.topHeadNameFIDFollorView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topHeadNameIDFollowViewClick)]];
    
    // 关闭btn：点击事件
    [_livePlayDetailsView.closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 发消息btn：点击事件
    [_livePlayDetailsView.sendMessageBtn addTarget:self action:@selector(sendMessageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 联系他btn：点击事件
    [_livePlayDetailsView.connectBtn addTarget:self action:@selector(connectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 送礼btn：点击事件
    [_livePlayDetailsView.sendGiftBtn addTarget:self action:@selector(sendGiftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 点赞btn：点击事件
    [_livePlayDetailsView.likeBtn addTarget:self action:@selector(likeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 分享btn：点击事件
    [_livePlayDetailsView.shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.view addSubview:_livePlayDetailsView];
    //    self.view = videoDetailsView;
    
}

// 上部头部：手势
- (void)topHeadNameIDFollowViewClick{
    NSLog(@"上部头部：手势");
    
    // 他人详情页
    CYOthersInfoVC *othersInfoVC = [[CYOthersInfoVC alloc] init];
    
    othersInfoVC.oppUserId = self.oppUserId;


    [self.navigationController pushViewController:othersInfoVC animated:YES];

    [othersInfoVC.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    
}

// 关闭btn：点击事件
- (void)closeBtnClick{
    NSLog(@"关闭btn：点击事件");
    
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
    
}

// 发消息btn：点击事件
- (void)sendMessageBtnClick{
    NSLog(@"发消息btn：点击事件");
    
    
}

// 联系他btn：点击事件
- (void)connectBtnClick{
    NSLog(@"联系他btn：点击事件");
    
    
    // 网络请求：联系他
    // 参数
    NSString *newUrlStr = [NSString stringWithFormat:@"api/Relationship/contact?userId=%@&oppUserId=%@",self.onlyUser.userID,self.oppUserId];
    
    // 网络请求：联系他
    [CYNetWorkManager postRequestWithUrl:newUrlStr params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"联系他：progress:%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"联系他：请求成功！");
        NSLog(@"responseObject：%@",responseObject);
        NSLog(@"responseObject:res:IsFriend:%@",responseObject[@"res"][@"IsFriend"]);
        
        //        NSString *isFriend = responseObject[@"res"][@"IsFriend"];
        //        NSLog(@"isFriend：%@",isFriend);
        
        // 2.3.1.1、获取code 值
        NSString *code = responseObject[@"code"];
        
        
#warning 为什么 IsFriend 打印中有值，但是赋值时是没有值的？？？？？？？
        CYVideoIsFriendModel *isFriendModel = [[CYVideoIsFriendModel alloc]initWithDictionary:responseObject[@"res"] error:nil];
        // 判断是否是朋友
        BOOL isFriend = isFriendModel.IsFriend;
        
        // 2.3.1.2、判断返回值
        if ([code isEqualToString:@"0"]) {
            NSLog(@"联系他：关注成功！");
            
            
            if (isFriend) {
                
                // 聊天界面
                [self chatViewWithOppUserId:self.onlyUser.userID andOppUserName:self.oppUserId];
            }
            else {
                
                // 加好友界面
                [self addFriendViewWithOppUserId:self.oppUserId];
                
            }
            
        }
        else{
            NSLog(@"加关注：关注失败！");
            NSLog(@"msg:%@",responseObject[@"res"][@"msg"]);
            
            
            // 2.3.1.2.2、加关注失败，弹窗
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
        }
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"加关注：请求失败！");
        NSLog(@"error:%@",error);
        
        // 加关注：请求：失败，加载菊花消失
        [self hidenLoadingView];
        
        // 2.3.1.2.2、加关注请求失败，弹窗
        [self showHubWithLabelText:@"网络错误，请重新上传！" andHidAfterDelay:3.0];
        
        
    } withToken:self.onlyUser.userToken];
    
}



// 聊天界面
- (void)chatViewWithOppUserId:(NSString *)oppUserId andOppUserName:(NSString *)oppUserName{
    NSLog(@"聊天界面");
    
    // 融云SDK
    // 新建一个聊天会话viewController 对象
    CYChatVC *chatVC = [[CYChatVC alloc] init];
    
    
    
    // 设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    chatVC.conversationType = ConversationType_PRIVATE;
    
    
    // 设置会话的目标会话ID。（单聊、客服、公众服务号会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    chatVC.targetId = oppUserId;
    
    // 设置聊天会话界面要显示的标题
    chatVC.title = oppUserName;
    
    self.parentViewController.hidesBottomBarWhenPushed = YES;
    //    self.hidesBottomBarWhenPushed = YES;
    
    // 显示聊天会话界面
    [self.navigationController pushViewController:chatVC animated:nil];
    
    // tabbar：显示
    self.parentViewController.hidesBottomBarWhenPushed = NO;
}
// 加好友界面
- (void)addFriendViewWithOppUserId:(NSString *)oppUserId{
    NSLog(@"加好友界面");
    
    //        CYNotFriendTipVC *notFriendVC = [[CYNotFriendTipVC alloc] init];
    //
    //        notFriendVC.OppUserId = othersInfoViewModel.Id;
    //
    //        [self presentViewController:notFriendVC animated:YES completion:nil];
    CYAddFriendVC *addFriendVC = [[CYAddFriendVC alloc] init];
    
    addFriendVC.OppUserId = oppUserId;
    
    
    [self presentViewController:addFriendVC animated:nil completion:nil];
}

// 送礼btn：点击事件
- (void)sendGiftBtnClick{
    NSLog(@"送礼btn：点击事件");
    
    
    // 送礼弹窗
    CYGiveGiftTipVC *giveGiftTipVC = [[CYGiveGiftTipVC alloc] init];
    
    giveGiftTipVC.oppUserId = self.oppUserId;
    
    [self presentViewController:giveGiftTipVC animated:nil completion:nil];
}

// 点赞btn：点击事件
- (void)likeBtnClick{
    NSLog(@"点赞btn：点击事件");
    
    
    // 点赞弹窗
    CYLikeTipVC *likeTipVC = [[CYLikeTipVC alloc] init];
    
    likeTipVC.oppUserId = self.oppUserId;
    
    [self presentViewController:likeTipVC animated:nil completion:nil];
}

// 分享btn：点击事件
- (void)shareBtnClick{
    NSLog(@"分享btn：点击事件");
    
    
    // 分享：网页分享
    [self sharedToWeChatWithWebpageWithShareTitle:@"APP 下载地址" andDescription:@"男左女右 遇见你的TA" andImage:[UIImage imageNamed:@"logo.png"] andWebpageUrl:cDownLoadUrl andbText:NO andScene:0];
}


@end
