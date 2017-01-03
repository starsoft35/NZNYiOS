//
//  AlivcLiveViewController.m
//  DevAlivcLiveVideo
//
//  Created by yly on 16/3/21.
//  Copyright © 2016年 Alivc. All rights reserved.
//


/**
 *  杭州短趣传媒网络技术有限公司
 *  POWERED BY QUPAI
 */

#import "AlivcLiveViewController.h"
#import <AlivcLiveVideo/AlivcLiveVideo.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

// 直播详情图
//#import "CYLiveDetailsView.h"

// 直播推流详情页：模型
#import "CYLivePushDetailsViewModel.h"
// 他人详情页：VC
#import "CYOthersInfoVC.h"


@interface AlivcLiveViewController ()<AlivcLiveSessionDelegate>

@property (nonatomic, strong) CTCallCenter *callCenter;
@property (nonatomic, strong) AlivcLiveSession *liveSession;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) AVCaptureDevicePosition currentPosition;

@property (nonatomic, strong) NSTimer *aLiYuntimer;
@property (nonatomic, strong) NSFileHandle *handle;
@property (nonatomic, strong) NSMutableArray *logArray;
@property (weak, nonatomic) IBOutlet UIButton *muteButton;

@end

@implementation AlivcLiveViewController {
    
    NSUInteger _last;
    CGFloat _lastPinchDistance;
    BOOL _isCTCallStateDisconnected;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil url:(NSString *)url{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    self = [super initWithNibName:@"CYLiveDetailsView" bundle:nibBundleOrNil];
    
    
    
//    CYLiveDetailsView *liveDetailsView = [[[NSBundle mainBundle] loadNibNamed:@"CYLiveDetailsView" owner:nil options:nil] lastObject];
////
////    self.view = liveDetailsView;
//    [self.view addSubview:liveDetailsView];
    
    _url = url;
    return self;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _logArray = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self.view addGestureRecognizer:gesture];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
    [self.view addGestureRecognizer:pinch];
    
    _aLiYuntimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeUpdate) userInfo:nil repeats:YES];
    
    [self testPushCapture];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"log.txt"];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
    _handle = [NSFileHandle fileHandleForWritingAtPath:path];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test) name:@"kaishichonglian" object:nil];
    
    
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



// 上部头部：手势
- (void)topHeadNameIDFollowViewClick{
    NSLog(@"上部头部：手势");
    
    // 他人详情页
    CYOthersInfoVC *othersInfoVC = [[CYOthersInfoVC alloc] init];
    
    othersInfoVC.oppUserId = self.oppUserId;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [othersInfoVC.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.parentViewController.navigationController pushViewController:othersInfoVC animated:YES];
    
//    [othersInfoVC.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    
}

// 关闭btn：点击事件
- (void)closeBtnClick{
    NSLog(@"关闭btn：点击事件");
    
    [self destroySession];
    [_aLiYuntimer invalidate];
    _aLiYuntimer = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 前后摄像头：点击事件
- (void)changeCameraBtnClickWithBtn:(UIButton *)changeCameraBtn{
    NSLog(@"前后摄像头：点击事件");
    
    changeCameraBtn.selected = !changeCameraBtn.isSelected;
    self.liveSession.devicePosition = changeCameraBtn.isSelected ? AVCaptureDevicePositionBack : AVCaptureDevicePositionFront;
    _currentPosition = self.liveSession.devicePosition;
    
}

// 分享btn：点击事件
- (void)shareBtnClick{
    NSLog(@"分享btn：点击事件");
    
}




- (void)test {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hi" message:@"开始重连" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    });
}

- (void)timeUpdate{
    AlivcLDebugInfo *i = [self.liveSession dumpDebugInfo];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:i.connectStatusChangeTime];
    
    NSMutableString *msg = [[NSMutableString alloc] init];
    [msg appendFormat:@"CycleDelay(%0.2fms)\n",i.cycleDelay];
    [msg appendFormat:@"bitrate(%zd) buffercount(%zd)\n",[self.liveSession alivcLiveVideoBitRate] ,self.liveSession.dumpDebugInfo.localBufferVideoCount];
    [msg appendFormat:@" efc(%zd) pfc(%zd)\n",i.encodeFrameCount, i.pushFrameCount];
    [msg appendFormat:@"%0.2ffps %0.2fKB/s %0.2fKB/s\n", i.fps,i.encodeSpeed, i.speed/1024];
    [msg appendFormat:@"%lluB pushSize(%lluB) status(%zd) %@",i.localBufferSize, i.pushSize, i.connectStatus, date];
    [msg appendFormat:@" %0.2fms\n",i.localDelay];
    [msg appendFormat:@"video_pts:%zd\naudio_pts:%zd\n", i.currentVideoPTS,i.currentAudioPTS];
    [msg appendFormat:@"fps:%f\n", i.fps];
    
    _textView.text = msg;
    
}

- (void)tapGesture:(UITapGestureRecognizer *)gesture{
    CGPoint point = [gesture locationInView:self.view];
    CGPoint percentPoint = CGPointZero;
    percentPoint.x = point.x / CGRectGetWidth(self.view.bounds);
    percentPoint.y = point.y / CGRectGetHeight(self.view.bounds);
    
    // 对焦
    [self.liveSession alivcLiveVideoFocusAtAdjustedPoint:percentPoint autoFocus:YES];
    
}

- (void)pinchGesture:(UIPinchGestureRecognizer *)gesture {
    
    if (_currentPosition == AVCaptureDevicePositionFront) {
        return;
    }
    
    if (gesture.numberOfTouches != 2) {
        return;
    }
    CGPoint p1 = [gesture locationOfTouch:0 inView:self.view];
    CGPoint p2 = [gesture locationOfTouch:1 inView:self.view];
    CGFloat dx = (p2.x - p1.x);
    CGFloat dy = (p2.y - p1.y);
    CGFloat dist = sqrt(dx*dx + dy*dy);
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _lastPinchDistance = dist;
    }
    
    CGFloat change = dist - _lastPinchDistance;
    //    change = change / (CGRectGetWidth(self.view.bounds) * 0.5) * 2.0;
    
    
    // 缩放
    [self.liveSession alivcLiveVideoZoomCamera:(change / 1000 )];
    
}


- (void)appResignActive{
    [self destroySession];
    
    // 监听电话
    _callCenter = [[CTCallCenter alloc] init];
    _isCTCallStateDisconnected = NO;
    _callCenter.callEventHandler = ^(CTCall* call) {
        if ([call.callState isEqualToString:CTCallStateDisconnected])
        {
            _isCTCallStateDisconnected = YES;
        }
        else if([call.callState isEqualToString:CTCallStateConnected])
            
        {
            _callCenter = nil;
        }
    };
    
}

- (void)appBecomeActive{
    
    if (_isCTCallStateDisconnected) {
        sleep(2);
    }
    
    [self testPushCapture];
}

- (void)testPushCapture{
        
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
    configuration.screenOrientation = _isScreenHorizontal;
    
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
    
    self.liveSession.enableMute = self.muteButton.selected;
    
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
        [self.view insertSubview:[self.liveSession previewView] atIndex:1];
    });
    
}

- (void)destroySession{
    
    [self.liveSession alivcLiveVideoDisconnectServer];
    
    [self.liveSession alivcLiveVideoStopPreview];
    [self.liveSession.previewView removeFromSuperview];
    self.liveSession = nil;
}


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
        self.textView.text = @"网速太慢";
    });
}


- (void)alivcLiveVideoOpenAudioSuccess:(AlivcLiveSession *)session {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"YES" message:@"麦克风打开成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alertView show];
    });
}

- (void)alivcLiveVideoOpenVideoSuccess:(AlivcLiveSession *)session {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"YES" message:@"摄像头打开成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alertView show];
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
        NSLog(@"升降码率:%ld", bitrateStatus);
    });
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != alertView.cancelButtonIndex) {
        [self.liveSession alivcLiveVideoConnectServer];
    } else {
        [self.liveSession alivcLiveVideoDisconnectServer];
    }
}


// 关闭：button：点击事件
- (IBAction)closeBtn:(id)sender {
    NSLog(@"关闭：button：点击事件");
    
    [self destroySession];
    [_aLiYuntimer invalidate];
    _aLiYuntimer = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

// 关闭：button：点击事件：为了让聊天界面去调用。
- (void)closeBtnForPushView{
    NSLog(@"关闭：button：点击事件！！");
    
    [self destroySession];
    [_aLiYuntimer invalidate];
    _aLiYuntimer = nil;
//    [self dismissViewControllerAnimated:YES completion:nil];
}

// 发现消息：button：点击事件
- (IBAction)sendMessageBtn:(UIButton *)sender {
    NSLog(@"发现消息：button：点击事件");
    
}

// 联系他：button：点击事件
- (IBAction)connectBtn:(id)sender {
    NSLog(@"联系他：button：点击事件");
    
}



// 翻转摄像头：button：点击事件
- (IBAction)changeCameraBtn:(UIButton *)sender {
    NSLog(@"翻转摄像头：button：点击事件");
    
    sender.selected = !sender.isSelected;
    self.liveSession.devicePosition = sender.isSelected ? AVCaptureDevicePositionBack : AVCaptureDevicePositionFront;
    _currentPosition = self.liveSession.devicePosition;
}


// 分享：button：点击事件
- (IBAction)shareBtn:(UIButton *)sender {
    NSLog(@"分享：button：点击事件");
    
    
}





// 美颜：button
- (IBAction)skinButtonClick:(UIButton *)button {
    button.selected = !button.isSelected;
    [self.liveSession setEnableSkin:button.isSelected];
}

// 闪光灯：button
- (IBAction)flashButtonClick:(UIButton *)button {
    button.selected = !button.isSelected;
    self.liveSession.torchMode = button.isSelected ? AVCaptureTorchModeOn : AVCaptureTorchModeOff;
}

- (IBAction)muteButton:(UIButton *)sender {
    [sender setSelected:!sender.selected];
    self.liveSession.enableMute = sender.selected;
}

// 断开链接：button
- (IBAction)disconnectButtonClick:(id)sender {
    if (self.liveSession.dumpDebugInfo.connectStatus == AlivcLConnectStatusNone) {
        [self.liveSession alivcLiveVideoConnectServer];
    }else{
        [self.liveSession alivcLiveVideoDisconnectServer];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_handle closeFile];
}

@end
