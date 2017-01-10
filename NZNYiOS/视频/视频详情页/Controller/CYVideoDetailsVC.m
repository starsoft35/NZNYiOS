//
//  CYVideoDetailsVC.m
//  nzny
//
//  Created by 男左女右 on 2016/11/27.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYVideoDetailsVC.h"

// 视频详情页：view
#import "CYVideoDetailsView.h"

// 他人详情页：VC
#import "CYOthersInfoVC.h"


// 联系他
// 聊天界面：VC
#import "CYChatVC.h"
// 加好友弹窗：VC
#import "CYAddFriendVC.h"

// 送礼弹窗：VC
#import "CYGiveGiftTipVC.h"

// 点赞弹窗：VC
#import "CYLikeTipVC.h"





@interface CYVideoDetailsVC ()

@end

@implementation CYVideoDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // 添加视图
    [self addView];
    
    // 加载数据
    [self loadData];
    
    
    // 阿里云播放器：代理
//    [AliVcMediaPlayer setAccessKeyDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
    
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    // 显示导航栏
    self.navigationController.navigationBarHidden = NO;
}

// 加载数据
- (void)loadData{
    
    // 网络请求：他人详情页
    
    // 新地址
    NSDictionary *params = @{
                             @"userId":self.onlyUser.userID,
                             @"oppUserId":self.oppUserId,
                             };
    
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
                
                _videoDetailsView.othersInfoVM = self.dataArray[0];
                
                
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
    
    _videoDetailsView = [[[NSBundle mainBundle] loadNibNamed:@"CYVideoDetailsView" owner:nil options:nil] lastObject];
    
    
    
    _videoDetailsView.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height);
    
    // 关闭：button：点击事件
    [_videoDetailsView.closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 上部头部：手势
    _videoDetailsView.topHeadNameIDFollowView.userInteractionEnabled = YES;
    [_videoDetailsView.topHeadNameIDFollowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topHeadNameIDFollowViewClick)]];
    
    // 关注：button：点击事件
    [_videoDetailsView.followBtn addTarget:self action:@selector(followBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 联系他：button：点击事件
    [_videoDetailsView.connectBtn addTarget:self action:@selector(connectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 送礼：button：点击事件
    [_videoDetailsView.giveGiftBtn addTarget:self action:@selector(giveGiftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 点赞：button：点击事件
    [_videoDetailsView.likeBtn addTarget:self action:@selector(likeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 分享：button：点击事件
    [_videoDetailsView.shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 播放：button：点击事件
    [_videoDetailsView.playBtn addTarget:self action:@selector(playBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_videoDetailsView];
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

// 关闭：button：点击事件
- (void)closeBtnClick{
    NSLog(@"关闭：button：点击事件");
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


// 关注：button：点击事件
- (void)followBtnClick{
    NSLog(@"关注：button：点击事件");
    
    
    // 如果已关注，则取消关注
//    if (_othersInfoView.othersInfoViewModel.IsFollow == YES) {
//        // 网络请求：取消关注
//        [self delFollow];
//    }
//    // 如果没关注，则加关注
//    else {
//        
//        // 网络请求：加关注
        [self addFollow];
//    }
    
    
}

// 网络请求：加关注
- (void)addFollow{
    
    // 网络请求：加关注
    // 参数
    NSString *newUrl = [NSString stringWithFormat:@"%@?userId=%@&oppUserId=%@",cAddFollowUrl,self.onlyUser.userID,self.oppUserId];
    
    [self showLoadingView];
    
    // 网络请求：加关注
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


// 联系他：button：点击事件
- (void)connectBtnClick{
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
// 送礼：button：点击事件
- (void)giveGiftBtnClick{
    NSLog(@"送礼：button：点击事件");
    
    // 送礼弹窗
    CYGiveGiftTipVC *giveGiftTipVC = [[CYGiveGiftTipVC alloc] init];
    
    giveGiftTipVC.oppUserId = self.oppUserId;
    
    [self presentViewController:giveGiftTipVC animated:YES completion:nil];
    
}
// 点赞：button：点击事件
- (void)likeBtnClick{
    NSLog(@"点赞：button：点击事件");
    
    // 点赞弹窗
    CYLikeTipVC *likeTipVC = [[CYLikeTipVC alloc] init];
    
    likeTipVC.oppUserId = self.oppUserId;
    
    [self presentViewController:likeTipVC animated:YES completion:nil];
    
}
// 分享：button：点击事件
- (void)shareBtnClick{
    NSLog(@"分享：button：点击事件");
    
    
    NSString *downloadUrl = [[NSString alloc] init];
    downloadUrl = cDownLoadUrl;
    downloadUrl = @"https://www.baidu.com/";
    
    
    
    UIImage *thumbImage = [CYUtilities setUrlImgWithHostUrl:cHostUrl andUrl:self.onlyUser.Portrait];
    NSData *thumbImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",cHostUrl,self.onlyUser.Portrait]]];
    
    // 分享：文本分享
//    [self sharedToWeChatWithText:@"分享随便些" bText:YES andScene:0];
    
    // 分享：图片分享
//    [self shareToWechatWithThumbImage:thumbImage andImageData:thumbImageData andbText:NO andScene:0];
    
    // 分享：网页分享
    [self sharedToWeChatWithWebpageWithShareTitle:@"APP 下载地址" andDescription:@"男左女右 遇见你的TA" andImage:[UIImage imageNamed:@"logo.png"] andWebpageUrl:downloadUrl andbText:NO andScene:0];
    
//    WXMediaMessage *message = [WXMediaMessage message];
//    message.title = @"分享标题";
//    message.description = @"分享描述";
//    [message setThumbImage:[UIImage imageNamed:@"117.jpg"]];
//    
//    
//    WXWebpageObject *webpageObject = [WXWebpageObject object];
//    webpageObject.webpageUrl = @"https://www.baidu.com/";
//    
//    
//    message.mediaObject = webpageObject;
//    
//    
//    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
//    req.bText = NO;
//    req.message = message;
//    
//    // 分享到好友会话
//    req.scene = WXSceneSession;
//    
//    
//    [WXApi sendReq:req];
    
}

// 播放：button：点击事件（系统播放器）
- (void)playBtnClick{
    NSLog(@"播放：button：点击事件");
    
#warning 播放地址请求
    // 网络请求：请求视频播放地址
    [self requestVideoPlayUrl];
    
    
    // 获取成功，播放视频
    [self playVideoWithUrl:@""];
    
}


// 网络请求：请求视频播放地址
- (void)requestVideoPlayUrl{
    NSLog(@"网络请求：请求视频播放地址");
    
    // 网络请求：请求视频播放后台
    // 新地址：
    NSString *newVideoUrl = [NSString stringWithFormat:@""];
    
    // 参数
    NSDictionary *params = @{
                             @"":@"",
                             };
    
    // 网络请求：请求视频播放后台,视频的地址
    [CYNetWorkManager postRequestWithUrl:newVideoUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"请求视频播放地址：%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"请求视频播放地址：请求成功！");
        
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"主视频热门界面：获取成功！：%@",responseObject);
            
            // 获取成功，播放视频
            [self playVideoWithUrl:responseObject[@""]];
            
            
        }
        else{
            NSLog(@"请求视频播放地址：获取失败:responseObject:%@",responseObject);
            NSLog(@"请求视频播放地址：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            
            
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求视频播放地址：请求失败！失败原因：error：%@",error);
        
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
}


// 获取成功，播放视频
- (void)playVideoWithUrl:(NSString *)newVideoUrl{
    NSLog(@"获取成功，播放视频");
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    self.audioPlayer.delegate = self;
    
#warning 视频地址的赋值
    // 模型：当前用户的信息模型
    CYOthersInfoViewModel *tempOthersInfoViewModel = self.dataArray[0];
    
    // 当前用户的视频数组
    NSArray *videosArr = tempOthersInfoViewModel.UserVideoList;
    
    // 视频模型
    CYOtherVideoCellModel *videoCellModel = [[CYOtherVideoCellModel alloc] init];
    
    // 当前视频的地址
    NSString *tempVideoUrl = [[NSString alloc] init];
    
    
    // 如果没有indexPath，即主界面的视频
    if (self.indexPath == nil) {
        
        // 判断视频数量
        if (videosArr.count == 1) {
            
            // 如果是一个，默认为播放
            videoCellModel = videosArr[0];
            // 第一个为默认，则视频的地址为第一个的视频地址
            tempVideoUrl = videoCellModel.Video;
            
        }
        else if (videosArr.count == 2) {
            
            videoCellModel = videosArr[0];
            NSLog(@"videoCellModel.Default:%d",videoCellModel.Default);
            // 如果是两个，看是否默认
            if (videoCellModel.Default == YES) {
                
                // 第一个为默认，则视频的地址为第一个的视频地址
                tempVideoUrl = videoCellModel.Video;
            }
            else {
                
                // 第一个视频不是默认，则把打第二个视频模型赋值，第二个的视频地址为视频的地址。
                videoCellModel = videosArr[1];
                tempVideoUrl = videoCellModel.Video;
            }
        }
        
    }
    else {
        
        // 如果有indexPath，即是从他人详情页的视频界面跳过来，用indexPath去判断播放哪个视频
        CYOtherVideoCellModel *tempVideoCellModel = self.videoDetailsView.othersInfoVM.UserVideoList[self.indexPath.row];
        
        tempVideoUrl = tempVideoCellModel.Video;
        
    }
    
    // 构建播放地址
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",cHostUrl,tempVideoUrl];
//    NSString *urlStr = @"http://live.nznychina.com/zcy/s1.m3u8";
//    NSString *urlStr = @"rtmp://video-center.alivecdn.com/zcy/s1?vhost=live.nznychina.com";
    
    
    // 可以是本地视频、也可以是网络视频
    self.moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:urlStr]];
    
    
    
    
    
//    self.moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:@"http://video.nznychina.com/play/video/abc/yang/"]];
//    self.moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:@"http://192.168.1.112/hls/s2.m3u8"]];
//    self.moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:@"rtmp://192.168.1.112:1935/hls/s2"]];
//    self.moviePlayerVC = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"http://192.168.1.112/hls/s2" ofType:@"m3u8"]]];
    
    // MPMoviePlayerController 只是一个容器，里面有一个能够播放视频的视图
    // 设置播放器的frame
    self.moviePlayerVC.view.frame = CGRectMake(0, 70, cScreen_Width, self.videoDetailsView.frame.size.height - 70 - self.videoDetailsView.bottomTipDecConView.frame.size.height);
    
    
    [self.view addSubview:self.moviePlayerVC.view];
    
    
    
    self.videoDetailsView.bgImgView.hidden = YES;
    self.videoDetailsView.playBtn.hidden = YES;
    self.videoDetailsView.backgroundColor = [UIColor clearColor];
    
}

// 播放：button：点击事件：（阿里云播放器）
//- (void)playBtnClick{
//    NSLog(@"播放：button：点击事件~~：2");
//    
//    //新建播放器
//    _aliMediaPlayer = [[AliVcMediaPlayer alloc] init];
//    //创建播放器，传入显示窗口
//    [_aliMediaPlayer create:mShowView];
//    //注册准备完成通知
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(OnVideoPrepared:) name:AliVcMediaPlayerLoadDidPreparedNotification object:_aliMediaPlayer];
//    //注册错误通知
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(OnVideoError:) name:AliVcMediaPlayerPlaybackErrorNotification object:_aliMediaPlayer];
//    //传入播放地址，初始化视频，准备播放
//    [_aliMediaPlayer prepareToPlay:mUrl];
//    //开始播放
//    [_aliMediaPlayer play];
//    
//    
//}




@end
