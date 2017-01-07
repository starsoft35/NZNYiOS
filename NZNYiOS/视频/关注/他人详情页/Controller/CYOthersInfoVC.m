//
//  CYOthersInfoVC.m
//  nzny
//
//  Created by 男左女右 on 2016/11/22.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYOthersInfoVC.h"


// 他人详情页：view
#import "CYOthersInfoView.h"
// 他人详情页模型：model
#import "CYOthersInfoViewModel.h"


//中部scrollView：VC
#import "CYOthersInfoVideoLiveVC.h"
// 资料：VC
#import "CYOtherDetailsVC.h"
// 视频：VC
#import "CYOtherVideoVC.h"
// 直播：VC
#import "CYOtherLiveVC.h"

// 聊天界面
#import "CYChatVC.h"


// 不是好友：VC
#import "CYNotFriendTipVC.h"
// 加好友弹窗
#import "CYAddFriendVC.h"

// 点赞：VC
#import "CYLikeTipVC.h"

// 送礼：VC
#import "CYGiveGiftTipVC.h"



@interface CYOthersInfoVC ()

@end

@implementation CYOthersInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 添加视图
    [self addView];
    
    
//    // 加载数据
//    [self loadData];
    
}

//
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    // 将要显示的时候，加载数据，用于刷新
    [self loadData];
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
            
            // 解析数据，模型存到数组
            [self.dataArray addObject:[[CYOthersInfoViewModel alloc] initWithDictionary:responseObject[@"res"][@"data"][@"model"] error:nil]];
            
            
            
            // 模型赋值
            if (self.dataArray.count != 0) {
                
                _othersInfoView.othersInfoViewModel = self.dataArray[0];
                
                
            }
            
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

// 添加视图
- (void)addView{
    
    _othersInfoView = [[[NSBundle mainBundle] loadNibNamed:@"CYOthersInfoView" owner:nil options:nil] lastObject];
    
    NSLog(@"self.dataArray.count:%ld",(unsigned long)self.dataArray.count);
    
    CGRect tempRect = CGRectMake(0, 0, cScreen_Width, _othersInfoView.infoOrVideoOrLiveView.frame.size.height - 76);
//        CGRect tempRec = CGRectMake(0, 0, cScreen_Width, 388 - 30);
    
//    NSLog(@"tempRec.size.height:%lf",tempRec.size.height);
    NSLog(@"_othersInfoView.infoOrVideoOrLiveView:%@",_othersInfoView.infoOrVideoOrLiveView);
    
    // 资料
    _otherInfoVC = [[CYOtherDetailsVC alloc] init];
//    CYOtherDetailsVC *o = [[CYOtherDetailsVC alloc] init];
    _otherInfoVC.oppUserId = self.oppUserId;
    
    _otherInfoVC.view.frame = tempRect;
    _otherInfoVC.baseTableView.frame = tempRect;
    
    // 视频
    _otherVideoVC = [[CYOtherVideoVC alloc] init];
    _otherVideoVC.oppUserId = self.oppUserId;
    _otherVideoVC.view.frame = tempRect;
    _otherVideoVC.baseCollectionView.frame = tempRect;
    
//    CYOtherVideoVC *v = [[CYOtherVideoVC alloc] init];
//    UINavigationController *videoNav = [[UINavigationController alloc] initWithRootViewController:_otherVideoVC];
    
    // 直播
    _otherLiveVC = [[CYOtherLiveVC alloc] init];
    _otherLiveVC.oppUserId = self.oppUserId;
//    CYOtherLiveVC *l = [[CYOtherLiveVC alloc] init];
    _otherLiveVC.view.frame = tempRect;
    _otherLiveVC.baseTableView.frame = tempRect;
    
    // 中部视图页面
    CYOthersInfoVideoLiveVC *middleVC = [[CYOthersInfoVideoLiveVC alloc] initWithSubVC:@[_otherInfoVC,_otherVideoVC,_otherLiveVC] andTitles:@[@"资料",@"视频",@"直播"]];
//    CYOthersInfoVideoLiveVC *videoVC = [[CYOthersInfoVideoLiveVC alloc] initWithSubVC:@[_otherInfoVC,videoNav,l] andTitles:@[@"资料",@"视频",@"直播"]];
    
    float middleVCHeight = _othersInfoView.infoOrVideoOrLiveView.frame.size.height;
    CGRect middleVCRect = CGRectMake(0, 0, cScreen_Width, middleVCHeight);
    
    middleVC.view.frame = middleVCRect;
//    middleVC.bgScrollView.frame = CGRectMake(0, 35, cScreen_Width, middleVCHeight - 35 - 64);
    
//    [videoVC setScrollViewFrame];
    // 中部视图：赋值
    [_othersInfoView.infoOrVideoOrLiveView addSubview:middleVC.view];
    
    // 联系他：button：点击事件
    [_othersInfoView.contactBtn addTarget:self action:@selector(contactBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 加关注：button：点击事件
    [_othersInfoView.followBtn addTarget:self action:@selector(followBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 点赞：button：点击事件
    [_othersInfoView.likeBtn addTarget:self action:@selector(likeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 送礼：button：点击事件
    [_othersInfoView.giveGiftBtn addTarget:self action:@selector(giveGiftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
//    _othersInfoView.frame = self.view.frame;
    
//    [self.view addSubview:_othersInfoView];
    self.view = _othersInfoView;
    
}


// 联系他：button：点击事件
- (void)contactBtnClick{
    NSLog(@"联系他：button：点击事件");
    
    // 模型
    CYOthersInfoViewModel *othersInfoViewModel = [[CYOthersInfoViewModel alloc] init];
    
    if (self.dataArray.count) {
        
        othersInfoViewModel = self.dataArray[0];
        
    }
    
    // 如果是好友，聊天界面
    if (othersInfoViewModel.IsFriend) {
        
        // 融云SDK
        // 新建一个聊天会话viewController 对象
        CYChatVC *chatVC = [[CYChatVC alloc] init];
        
        
        
        // 设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
        chatVC.conversationType = ConversationType_PRIVATE;
        
        
        // 设置会话的目标会话ID。（单聊、客服、公众服务号会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
        chatVC.targetId = othersInfoViewModel.Id;
        
        // 设置聊天会话界面要显示的标题
        chatVC.title = othersInfoViewModel.RealName;
        
        // 显示聊天会话界面
        [self.navigationController pushViewController:chatVC animated:YES];
    }
    else{
        
        // 如果 不是好友，弹窗提示
//        CYNotFriendTipVC *notFriendVC = [[CYNotFriendTipVC alloc] init];
//        
//        notFriendVC.OppUserId = othersInfoViewModel.Id;
//        
//        [self presentViewController:notFriendVC animated:YES completion:nil];
        CYAddFriendVC *addFriendVC = [[CYAddFriendVC alloc] init];
        
        addFriendVC.OppUserId = othersInfoViewModel.Id;;
        
        
        [self presentViewController:addFriendVC animated:YES completion:nil];
        
    }
    
    
}

// 加关注：button：点击事件
- (void)followBtnClick{
    NSLog(@"加关注：button：点击事件");
    
    // 如果已关注，则取消关注
    if (_othersInfoView.othersInfoViewModel.IsFollow == YES) {
        // 网络请求：取消关注
        [self delFollow];
    }
    // 如果没关注，则加关注
    else {
        
        // 网络请求：加关注
        [self addFollow];
    }
    
}

// 网络请求：取消关注
- (void)delFollow{
    
    // 网络请求：取消关注
    // 参数
    NSString *newUrl = [NSString stringWithFormat:@"%@?userId=%@&oppUserId=%@",cDelFollowUrl,self.onlyUser.userID,_othersInfoView.othersInfoViewModel.Id];
    
    [self showLoadingView];
    
    // 取消关注
    [CYNetWorkManager postRequestWithUrl:newUrl params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"取消关注：progress:%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"取消关注：请求成功！");
        
        
        // 2.3.1.1、获取code 值
        NSString *code = responseObject[@"code"];
        
        // 2.3.1.2、判断返回值
        if ([code isEqualToString:@"0"]) {
            NSLog(@"取消关注：取消成功！");
            
            // 隐藏菊花
            //            [self hidenLoadingView];
            
            // 刷新数据
            [self loadData];
            
        }
        else{
            NSLog(@"取消关注：取消失败！");
            NSLog(@"msg:%@",responseObject[@"res"][@"msg"]);
            
            
            // 2.3.1.2.2、取消关注失败，弹窗
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
        }
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"取消关注：请求失败！");
        NSLog(@"error:%@",error);
        
        // 取消关注：请求：失败，加载菊花消失
        [self hidenLoadingView];
        
        // 2.3.1.2.2、取消取消失败，弹窗
        [self showHubWithLabelText:@"网络错误，请重新上传！" andHidAfterDelay:3.0];
        
        
    } withToken:self.onlyUser.userToken];
}

// 网络请求：加关注
- (void)addFollow{
    
    // 网络请求：加关注
    // 参数
    NSString *newUrl = [NSString stringWithFormat:@"%@?userId=%@&oppUserId=%@",cAddFollowUrl,self.onlyUser.userID,_othersInfoView.othersInfoViewModel.Id];
    
    [self showLoadingView];
    
    // 加关注
    [CYNetWorkManager postRequestWithUrl:newUrl params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"加关注：progress:%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"加关注：请求成功！");
        
        
        // 2.3.1.1、获取code 值
        NSString *code = responseObject[@"code"];
        
        // 2.3.1.2、判断返回值
        if ([code isEqualToString:@"0"]) {
            NSLog(@"加关注：关注成功！");
            
            // 隐藏菊花
            //            [self hidenLoadingView];
            
            // 刷新数据
            [self loadData];
            
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


// 点赞：button：点击事件
- (void)likeBtnClick{
    NSLog(@"点赞：button：点击事件");
    
    // 点赞弹窗
    CYLikeTipVC *likeTipVC = [[CYLikeTipVC alloc] init];
    
    likeTipVC.oppUserId = self.oppUserId;
    
    [self presentViewController:likeTipVC animated:YES completion:nil];
    
}

// 送礼：button：点击事件
- (void)giveGiftBtnClick{
    NSLog(@"送礼：button：点击事件");
    
    // 送礼弹窗
    CYGiveGiftTipVC *giveGiftTipVC = [[CYGiveGiftTipVC alloc] init];
    
    giveGiftTipVC.oppUserId = self.oppUserId;
    
    [self presentViewController:giveGiftTipVC animated:YES completion:nil];
    
}

@end
