//
//  CYLivePushDetailsVC.m
//  nzny
//
//  Created by 男左女右 on 2016/12/18.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYLivePushDetailsVC.h"

// 直播推流详情页：模型
#import "CYLivePushDetailsViewModel.h"


// 他人详情页：VC
#import "CYOthersInfoVC.h"



// 阿里直播推流接入
#import <AlivcLiveVideo/AlivcLiveVideo.h>

// 阿里直播推流详情页：VC
#import "AlivcLiveViewController.h"

@interface CYLivePushDetailsVC ()<AlivcLiveSessionDelegate>

// 直播会
@property (nonatomic, strong) AlivcLiveSession *liveSession;

// 捕捉设备位置
@property (nonatomic, assign) AVCaptureDevicePosition currentPosition;



@end

@implementation CYLivePushDetailsVC

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
    
    //    [self showLoadingView];
    
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
            CYLivePushDetailsViewModel *tempLivePlayDetailsViewModel = [[CYLivePushDetailsViewModel alloc] initWithDictionary:responseObject[@"res"][@"data"][@"model"] error:nil];
            
            
            // 模型赋值
            _livePushDetailsView.livePushDetailsViewModel = tempLivePlayDetailsViewModel;
            
            self.oppUserId = tempLivePlayDetailsViewModel.LiveUserId;
            
            // 请求数据结束，取消加载
            //            [self hidenLoadingView];
            
            
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
    
    _livePushDetailsView = [[[NSBundle mainBundle] loadNibNamed:@"CYLivePushDetailsView" owner:nil options:nil] lastObject];
    
#warning 添加聊天室界面
    
    //    _livePlayDetailsView.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height);
    
    // 上部头部：手势
    _livePushDetailsView.topHeadNameFIDFollowView.userInteractionEnabled = YES;
    [_livePushDetailsView.topHeadNameFIDFollowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topHeadNameIDFollowViewClick)]];
    
    // 关闭btn：点击事件
    [_livePushDetailsView.closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 前后摄像头：点击事件
    [_livePushDetailsView.changeCameraBtn addTarget:self action:@selector(changeCameraBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 分享btn：点击事件
    [_livePushDetailsView.shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.view addSubview:_livePushDetailsView];
//        self.view = _livePushDetailsView;
    
    // 阿里直播推流详情页
//    NSString *newUrl = @"rtmp://video.nznychina.com:1935/hls/123?uid=10-vtoken=123456";
//    AlivcLiveViewController *live = [[AlivcLiveViewController alloc] initWithNibName:@"AlivcLiveViewController" bundle:nil url:newUrl];
//    //    live.isScreenHorizontal = !self.screenSwitch.on;
//    live.isScreenHorizontal = NO;
//    [self presentViewController:live animated:YES completion:nil];
//    [self.view addSubview:live.view];
//    [self addChildViewController:live];
    
    // 阿里云直播接入
//    [self addAliYunLive];
    
}


#warning 阿里云直播接入
// 阿里云直播接入
- (void)addAliYunLive{
    
    AlivcLConfiguration *configuration = [[AlivcLConfiguration alloc] init];
    configuration.url = _url;
    
    //    configuration.url = @"rtmp://192.168.1.112:1935/hls/123?uid=10-vtoken=123456";
    
    configuration.videoMaxBitRate = 1500 * 1000;
    configuration.videoBitRate = 600 * 1000;
    configuration.videoMinBitRate = 400 * 1000;
    configuration.audioBitRate = 64 * 1000;
    configuration.videoSize = CGSizeMake(360, 640);// 横屏状态宽高不需要互换
    configuration.fps = 20;
    configuration.preset = AVCaptureSessionPresetiFrame1280x720;
    
    // 手机方向：横竖屏：默认竖屏：AlivcLiveScreenVertical
    configuration.screenOrientation = AlivcLiveScreenVertical;
    
    configuration.reconnectTimeout = 5;
    
    // 水印
    configuration.waterMaskImage = [UIImage imageNamed:@"watermask"];
    configuration.waterMaskLocation = 1;
    configuration.waterMaskMarginX = 10;
    configuration.waterMaskMarginY = 10;
    
    
    if (_currentPosition) {
        configuration.position = _currentPosition;
    } else {
        configuration.position = AVCaptureDevicePositionFront;
        _currentPosition = AVCaptureDevicePositionFront;
    }
    NSLog(@"版本号:%@", [AlivcLiveSession alivcLiveVideoVersion]);
    
    self.liveSession = [[AlivcLiveSession alloc] initWithConfiguration:configuration];
    self.liveSession.delegate = self;
    
    // 是否静音：默认为NO：不静音
    self.liveSession.enableMute = NO;
    
    [self.liveSession alivcLiveVideoStartPreview];
    
    [self.liveSession alivcLiveVideoUpdateConfiguration:^(AlivcLConfiguration *configuration) {
        configuration.videoMaxBitRate = 1500 * 1000;
        configuration.videoBitRate = 600 * 1000;
        configuration.videoMinBitRate = 400 * 1000;
        configuration.audioBitRate = 64 * 1000;
        configuration.fps = 20;
    }];
    [self.liveSession alivcLiveVideoConnectServer];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.livePushDetailsView insertSubview:[self.liveSession previewView] atIndex:0];
//        [self.view insertSubview:[self.liveSession previewView] atIndex:0];
//        [self.livePushDetailsView addSubview:[self.liveSession previewView]];
    });
    
    
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
}

// 前后摄像头：点击事件
- (void)changeCameraBtnClick{
    NSLog(@"前后摄像头：点击事件");
    
}

// 分享btn：点击事件
- (void)shareBtnClick{
    NSLog(@"分享btn：点击事件");
    
}



#pragma 阿里云视频代理
- (void)alivcLiveVideoLiveSession:(AlivcLiveSession *)session error:(NSError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *msg = [NSString stringWithFormat:@"%zd %@",error.code, error.localizedDescription];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Live Error" message:msg delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"重新连接", nil];
        alertView.delegate = self;
        [alertView show];
    });
    
    NSLog(@"!!!error : %@", error);
}

- (void)alivcLiveVideoReconnectTimeout:(AlivcLiveSession*)session {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"重连超时（此处根据实际情况决定，默认重连时长5s，可更改，建议开发者在此处重连）" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alertView show];
    });
    
}

- (void)alivcLiveVideoLiveSessionConnectSuccess:(AlivcLiveSession *)session {
    
    NSLog(@"connect success!");
}


- (void)alivcLiveVideoLiveSessionNetworkSlow:(AlivcLiveSession *)session{
    // 注意：一定要套 主线程 完成UI操作
    dispatch_async(dispatch_get_main_queue(), ^{
//        self.textView.text = @"网速太慢";
    });
}


- (void)alivcLiveVideoOpenAudioSuccess:(AlivcLiveSession *)session {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"YES" message:@"麦克风打开成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    });
}

- (void)alivcLiveVideoOpenVideoSuccess:(AlivcLiveSession *)session {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"YES" message:@"摄像头打开成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    });
}


- (void)alivcLiveVideoLiveSession:(AlivcLiveSession *)session openAudioError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"麦克风获取失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    });
}

- (void)alivcLiveVideoLiveSession:(AlivcLiveSession *)session openVideoError:(NSError *)error {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"摄像头获取失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    });
}

- (void)alivcLiveVideoLiveSession:(AlivcLiveSession *)session encodeAudioError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"音频编码初始化失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    });
    
}

- (void)alivcLiveVideoLiveSession:(AlivcLiveSession *)session encodeVideoError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"视频编码初始化失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    });
}

- (void)alivcLiveVideoLiveSession:(AlivcLiveSession *)session bitrateStatusChange:(ALIVC_LIVE_BITRATE_STATUS)bitrateStatus {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"升降码率:%ld", (long)bitrateStatus);
    });
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != alertView.cancelButtonIndex) {
        [self.liveSession alivcLiveVideoConnectServer];
    } else {
        [self.liveSession alivcLiveVideoDisconnectServer];
    }
}

@end
