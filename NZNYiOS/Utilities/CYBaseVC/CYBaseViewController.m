 //
//  CYBaseViewController.m
//  NZNYiOS
//
//  Created by 男左女右 on 16/8/16.
//  Copyright © 2016年 NZNY. All rights reserved.
//

#import "CYBaseViewController.h"



#import "CYMainTabBarController.h"


// 根视图控制器代理
#import "AppDelegate.h"

// 完善信息VC
#import "CYPerfectInfoViewController.h"


// 设置：VC
#import "CYSetUpVC.h"


// 搜索:VC
#import "CYSearchVC.h"

// 附近的人：VC
#import "CYNearbyPeopleVC.h"


// 会话列表:VC
#import "CYChatListVC.h"



// 余额不足弹窗：VC
#import "CYBalanceNotEnoughVC.h"


#import <ifaddrs.h>
#import <arpa/inet.h>




@interface CYBaseViewController ()

//// 密码flag
//@property (nonatomic,assign)NSInteger passwordFlag;





@end

@implementation CYBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 加载数据
//    [self loadData];
    
    
}


// 融云：Kit：初始化
- (void)setRongCloudKitWithCurrentUser:(CYUser *)currentUser andRongToken:(NSString *)rongToken{
    
    NSLog(@"rongToken:%@",rongToken);
    
    [[RCIM sharedRCIM] initWithAppKey:cRongAppKey];
    // Kit：代理
    //    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
    
    // Kit：连接服务器：将获取的token传给融云服务器，只需调用一次
    [[RCIM sharedRCIM] connectWithToken:rongToken success:^(NSString *userId) {
        NSLog(@"融云：Kit：连接融云服务器，登录成功，当前登录的用户，在融云的ID：%@",userId);
        
        // 代理：获取聊天界面用户信息，用于更改用户头像等....
        [[RCIM sharedRCIM] setUserInfoDataSource:self];
        //        [[RCIM sharedRCIM] setGroupInfoDataSource:self];
        
        
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = currentUser.userID;
        user.portraitUri = currentUser.Portrait;
        user.name = currentUser.RealName;
        
        
        // 当前的用户：
//        [RCIMClient sharedRCIMClient].currentUserInfo = user;
        [[RCIM sharedRCIM] setCurrentUserInfo:user];
        [RCIM sharedRCIM].currentUserInfo = user;
        
    } error:^(RCConnectErrorCode status) {
        NSLog(@"融云：Kit：连接融云服务器，登录失败，错误码为：%ld",(long)status);
        
        
    } tokenIncorrect:^{
        NSLog(@"融云：Kit：token错误");
        
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        
        // 在 tokenIncorrectBlock 的情况下，您需要请求您的服务器重新获取 token 并建立连接，但是注意避免无限循环，以免影响 App 用户体验。
    }];
    
}


//// 融云：初始化：使用RCDLive进行初始化
//- (void)setRongCloudWithRCDLiveWithCurrentUser:(CYUser *)currentUser andRongToken:(NSString *)rongToken{
//    
//    int ifIsYes;
//    
//    [[RCDLive sharedRCDLive] initRongCloud:cRongAppKey];
//    
//    //注册自定义消息：送礼
//    [[RCDLive sharedRCDLive] registerRongCloudMessageType:[RCDLiveGiftMessage class]];
//    
//    
//    NSLog(@"rongToken:%@",rongToken);
//    
//    // 连接融云：RCDLive来连接：用token
//    [[RCDLive sharedRCDLive] connectRongCloudWithToken:rongToken success:^(NSString *loginUserId) {
//        NSLog(@"融云：RCDLive：连接融云服务器，登录成功，当前登录的用户，在融云的ID：%@",loginUserId);
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            
//            
//            RCUserInfo *user = [[RCUserInfo alloc]init];
//            user.userId = currentUser.userID;
//            user.portraitUri = currentUser.Portrait;
//            user.name = currentUser.RealName;
//            
//            
//            // 当前的用户：
//            [RCIMClient sharedRCIMClient].currentUserInfo = user;
//            
////            ifIsYes = 1;
//            
//            
//        });
//    } error:^(RCConnectErrorCode status) {
//        NSLog(@"融云：RCDLive：连接融云服务器，登录失败，错误码为：%ld",(long)status);
//        
//    } tokenIncorrect:^{
//        NSLog(@"融云：RCDLive：token错误");
//        
//        
//    }];
//}


- (void)onConnectionStatusChanged:(RCConnectionStatus)status {
    //    if (/*ConnectionStatus_NETWORK_UNAVAILABLE != status && */ConnectionStatus_UNKNOWN != status &&
    //        ConnectionStatus_Unconnected != status) {
    //        [[NSNotificationCenter defaultCenter] postNotificationName:RCDLiveKitDispatchConnectionStatusChangedNotification
    //                                                            object:[NSNumber numberWithInt:status]];
    //    } else {
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            [self performSelector:@selector(delayNotifyUnConnectedStatus) withObject:nil afterDelay:3];
    //        });
    //    }
}
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
    
}


// 融云代理实现方法：设置聊天界面，用户信息：Id、头像、用户名。
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion
{
    
    CYUser *currentUser = [CYUser currentUser];
    // 请求数据
    // 参数
    NSDictionary *params = @{
                             @"userId":userId
                             };
    NSLog(@"params:%@",params);
    
    // 显示加载
    //    [self showLoadingView];
    
    // 请求数据：获取用户个人信息
    [CYNetWorkManager getRequestWithUrl:cPrivateInfoUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取用户个人信息进度：%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"获取用户个人信息：请求成功！");
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"获取用户个人信息：获取成功！");
            NSLog(@"获取用户个人信息：%@",responseObject);
            
            
            // 2、赋值
            RCUserInfo *user = [[RCUserInfo alloc]init];
            user.userId = userId;
            user.name = responseObject[@"res"][@"data"][@"model"][@"RealName"];
            user.portraitUri = [NSString stringWithFormat:@"%@%@",cHostUrl,responseObject[@"res"][@"data"][@"model"][@"Portrait"]];
            
            //            user.name = @"为什么";
            
            return completion(user);
            //            [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:currentUser.userID];
            
        }
        else{
            NSLog(@"获取用户个人信息：获取失败:responseObject:%@",responseObject);
            NSLog(@"获取用户个人信息：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"获取用户个人信息：请求失败！:error:%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
        
    } withToken:currentUser.userToken];
    
    
}



//
//
//@param userInfo     需要更新的用户信息
//@param userId       需要更新的用户ID
//
//@discussion 使用此方法，可以更新SDK缓存的用户信息。
//但是处于性能和使用场景权衡，SDK不会在当前View立即自动刷新（会在切换到其他View的时候再刷新该用户的显示信息）。
//如果您想立即刷新，您可以在会话列表或者聊天界面reload强制刷新。
//*/
//- (void)refreshUserInfoCache:(RCUserInfo *)userInfo
//                  withUserId:(NSString *)userId{
//    NSLog(@"更新聊天界面用户的信息");
//
//
//    CYUser *currentUser = [CYUser currentUser];
//
//
//    userInfo.userId = currentUser.userID;
//    userInfo.name = currentUser.RealName;
//    userInfo.portraitUri = currentUser.Portrait;
//
//    [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:currentUser.userID];
//
//
//}

- (void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *))completion{
    NSLog(@"getGroupInfoWithGroupId。。。。。。。。。。。。。");
    
}

#pragma mark --------------------navigationBar：点击事件--------------------------------------
// 搜索：左边BarButtonItem：点击事件
- (void)searchLeftBarBtnItemClick{
    NSLog(@"搜索：BaseViewController:searchLeftBarBtnItemClick：点击事件");
    
    // 搜索：VC
    CYSearchVC *searchVC = [[CYSearchVC alloc] init];
    
    if (cScreen_Height == 568.0) {
        
        searchVC.view.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height - (150.0 / 1334.0) * cScreen_Height);
        searchVC.baseTableView.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height - (150.0 / 1334.0) * cScreen_Height);
    }
    else {
        
        searchVC.view.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height - (128.0 / 1334.0) * cScreen_Height);
        searchVC.baseTableView.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height - (128.0 / 1334.0) * cScreen_Height);
        
    }
    
    NSLog(@"cScreen_Height:%f",cScreen_Height);
    // 设置返回的文字
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title =@"";
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    
    // 隐藏tabbar
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:searchVC animated:YES];
    
    // 显示tabbar
    self.hidesBottomBarWhenPushed = NO;
    
}


// 设置：左边BarButtonItem：点击事件
- (void)setLeftBarBtnItemClick{
    NSLog(@"设置：BaseViewController:setLeftBarBtnItemClick：点击事件");
    
    CYSetUpVC *setUpVC = [[CYSetUpVC alloc] init];
    
    // 隐藏tabbar
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:setUpVC animated:YES];
    
    self.hidesBottomBarWhenPushed = NO;
    
}


// 附近的人：右边，nearBarButtonItem：点击事件
- (void)nearRightBarBtnItemClick{
    NSLog(@"附近的人：BaseViewController:nearRightBarBtnItemClick：点击事件");
    
    
    self.ifOpenNearbyPeopleVC = YES;
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse
         || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
            
            
            // 定位：获取位置信息，地理位置编码、反编码
            [self getLocationManager];
        }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        NSLog(@"定位功能不可用，提示用户或忽略");
        
        [self showHubWithLabelText:@"需要开启定位" andHidAfterDelay:3.0];
    }
    
    // 定位：获取位置信息，地理位置编码、反编码
//    [self getLocationManager];
    
    
}


// 定位：获取位置信息，地理位置编码、反编码
- (void)getLocationManager{
    
    // 实例化：定位管理者
//    self.locationManager = [[CLLocationManager alloc] init];
    
    // 问用户要授权：定位
    //  先判断定位服务是否可用
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"已经开启了定位！");
        // 定位可用
        // 问用户要授权：定位（iOS 8 之后，需要在info 里面设置：给用户弹出提示的内容）
        [self.locationManager requestWhenInUseAuthorization];;
        
    }
    else {
        
        // 定位不可用
        // 给用户提示
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"定位服务不可用~" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"定位不可用，则打开设置，设置定位");
            // 打开设置
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
                
                // 打开其他应用
                // @"tel://12345678"
                // @"smb://789765"
                
                [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }
            
        }];
        
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    // 设置定位的精度（精度越高越费电）
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    
    // 设置代理：位置变更后的回调
    self.locationManager.delegate = self;
    
    // 设置位置变更后的精度
    self.locationManager.distanceFilter = 1;
    
    // 开始定位，开始更新位置信息
    [self.locationManager startUpdatingLocation];
    
    
}


// 定位：位置变更后的回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    // 获取其中的一个位置
    CLLocation *location = locations.firstObject;
    
    
    // 关闭定位
    [self.locationManager stopUpdatingLocation];
    
    
    NSLog(@"定位：当前的位置：%@",location);
    
    // 当前用户
    CYUser *currentUser = [CYUser currentUser];
    
    NSString *latitude = [NSString stringWithFormat:@"%lf",location.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%lf",location.coordinate.longitude];
    // 参数拼接
    NSDictionary *params = @{
                             @"UserId":currentUser.userID,
                             @"Longitude":longitude,
                             @"Latitude":latitude
                             };
    // 位置信息请求，把经纬度 发送给后台
    [CYNetWorkManager postRequestWithUrl:cCoordinatesUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"当前进度：%@",uploadProgress);
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"位置信息请求：请求成功！");
        
        // 2.3.1.1、获取code 值
        NSString *code = responseObject[@"code"];
        
        
        // 2.3.1.2、判断返回值
        if ([code isEqualToString:@"0"]) {
            NSLog(@"位置信息请求：位置更新成功！");
            
            // 2.3.1.2.1、位置信息请求成功，
            // 关闭定位
            [self.locationManager stopUpdatingLocation];
            
            // 位置请求并上传成功之后，再打开附近的人界面
            if (self.ifOpenNearbyPeopleVC) {
                
                // 如果是打开附近的人界面，则打开附近的人界面
                [self pushNearbyPeopleVC];
            }
            
        }
        else{
            NSLog(@"位置信息请求：位置更新失败！");
            NSLog(@"位置信息请求：位置更新失败：msg：%@",responseObject[@"res"][@"msg"]);
            
            // 2.3.1.2.2、位置信息请求失败，弹窗
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
        }
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"位置信息请求：请求失败！");
        NSLog(@"失败error：%@",error);
        
        // 2.3.2、位置信息请求：请求失败
        [self showHubWithLabelText:@"完善信息失败，可能是网络有问题，请检查网络再试一遍!" andHidAfterDelay:3.0];
    } withToken:currentUser.userToken];
    
    
    // 地理位置反编码
    [self locationWithLatitude:location.coordinate.latitude andLongitude:location.coordinate.longitude];
}


// 如果是打开附近的人界面，则打开附近的人界面
- (void)pushNearbyPeopleVC{
    
    
    self.ifOpenNearbyPeopleVC = NO;
    
    // 附近的人：VC
    CYNearbyPeopleVC *nearbyPeopleVC = [[CYNearbyPeopleVC alloc] init];
    
    if (cScreen_Height == 568.0) {
        
        nearbyPeopleVC.view.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height - (150.0 / 1334.0) * cScreen_Height);
        nearbyPeopleVC.baseTableView.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height - (150.0 / 1334.0) * cScreen_Height);
    }
    else {
        
        nearbyPeopleVC.view.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height - (128.0 / 1334.0) * cScreen_Height);
        nearbyPeopleVC.baseTableView.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height - (128.0 / 1334.0) * cScreen_Height);
        
    }
    
    // 隐藏tabbar
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:nearbyPeopleVC animated:YES];
    
    self.hidesBottomBarWhenPushed = NO;
}



// 经纬度 -> 地理位置（地理位置反编码）
- (void)locationWithLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude{
    
    // 根据经纬度，实例化一个位置信息
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    // 生成地理位置编码类（编码、反编码 都需要这个类）
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    // 反编码
    //     把一个位置信息：location， 转成地理位置
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        NSLog(@"反编码：把一个位置信息：location， 转成地理位置");
        
        
        // 取出地标信息 （是一个数组，取出其中一个）
        CLPlacemark *placeMark = placemarks.firstObject;
        
        // 取出详细的位置信息
        NSDictionary *infoDic = placeMark.addressDictionary;
        
        
        for (NSString *tmpKey in infoDic) {
            
            NSLog(@"key:%@，obj：%@",tmpKey,infoDic[tmpKey]);
        }
        
        
    }];
}





// 新消息：右边，newsBarButtonItem：点击事件
- (void)newsRightBarBtnItemClick{
    NSLog(@"新消息：BaseViewController:newsRightBarBtnItemClick：点击事件");

    
    // 初始化会话列表
    CYChatListVC *chatListVC = [[CYChatListVC alloc] init];
    
    chatListVC.currentUserId = self.onlyUser.userID;
    chatListVC.currentUserToken = self.onlyUser.userToken;
    
    // 隐藏tabbar
    self.hidesBottomBarWhenPushed = YES;
    
    // push
    [self.navigationController pushViewController:chatListVC animated:YES];
    
    // 显示tabbar
    self.hidesBottomBarWhenPushed = NO;
    
    
}

// 加载数据
- (void)loadData{
    NSLog(@"viewController 子类需要重写loadData 这个方法，如果没有重写，就会打印这句话");
    
    
}


// 点击空白：弹窗消失、隐藏键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 弹窗消失
    [self.hud hide:YES];
    
    // 隐藏键盘
    [self.view endEditing:YES];
    
}



// 密码显示隐藏：点击事件
- (void)passwordDisplayOrHideImgViewClickWithImgView:(UIImageView *)imgView andTexeField:(UITextField *)textField{
    NSLog(@"密码显示隐藏：点击事件");
    
    
    if (_passwordFlag == 0) {
        
        imgView.image = [UIImage imageNamed:@"隐藏"];
        [textField setSecureTextEntry:YES];
        
        _passwordFlag = 1;
    }
    else {
        imgView.image = [UIImage imageNamed:@"显示"];
        [textField setSecureTextEntry:NO];
        _passwordFlag = 0;
    }
    
    
}

//- (int)passwordFlag{
//    
//    if (!_passwordFlag) {
//        _passwordFlag = 1;
//    }
//    
//    return _passwordFlag;
//}



//// 设置验证码button定时器
//- (void)setRepeatBtnTimer{
//    
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(repeatBtnTimerCountdown) userInfo:nil repeats:YES];
//}

// 验证码button定时器：执行的方法
- (void)timerCountdownWithRepeatBtn:(UIButton *)repeatBtn andCountdownTime:(NSInteger)countdownTime andBtnDisabledTitle:(NSString *)btnDisabledTitle andNormalTitle:(NSString *)btnNormalTitle{
    
    NSLog(@"倒计时：%ld",(long)self.repeatSendVerifiTime);
    
    if (self.repeatSendVerifiTime - 1) {
        
        self.repeatSendVerifiTime -= countdownTime;
        
        [repeatBtn setTitle:btnDisabledTitle forState:UIControlStateDisabled];
    }
    else{
        [repeatBtn setBackgroundImage:[UIImage imageNamed:@"发送验证码"] forState:UIControlStateNormal];
//        repeatBtn.backgroundColor = [UIColor orangeColor];
        repeatBtn.enabled = YES;
        [repeatBtn setTitle:btnNormalTitle forState:UIControlStateNormal];
        [_timer setFireDate:[NSDate distantFuture]];
    }
    
}

// 界面消失的之后，销毁定时器
- (void)viewDidDisappear:(BOOL)animated{
    
    // 页面销毁，即定时器销毁
    [self.timer invalidate];
}

// 检查金额：是否输入、格式是否正确：纯数字
- (BOOL)checkIfIsNum:(NSString *)number{
    
    if ([number isEqualToString:@""]) {
        
        // 没有填写
        [self showHubWithLabelText:@"请输入数值" andHidAfterDelay:3.0];
        return NO;
    }
    else {
        
        NSScanner* scan = [NSScanner scannerWithString:number];
        int valInt;
        BOOL isInt = [scan scanInt:&valInt] && [scan isAtEnd];
        
        
        float valFloat;
        BOOL isFloat = [scan scanFloat:&valFloat] && [scan isAtEnd];
        
        if (isInt || isFloat) {
            
            return YES;
        }
        else {
            
            // 填写有误
            [self showHubWithLabelText:@"请输入正确的数值" andHidAfterDelay:3.0];
            return NO;
        }
        
    }
    
}

// 检查手机号：是否输入、格式是否正确
- (BOOL)checkTel:(NSString *)tel{
    
    // 1、先判断手机号是否填写、格式是否正确
    if ([tel isEqualToString:@""]) {
        // 1.1、没有填写手机号
        
        [self showHubWithLabelText:@"请输入手机号" andHidAfterDelay:3.0];
        return NO;
    }
    else{
        
        // 1.2、已经填写手机号，判断格式是否正确
        BOOL isTel = [CYUtilities checkTel:tel];
        
        if (!isTel) {
            // 1.3、手机号格式不正确
            [self showHubWithLabelText:@"请输入正确的手机号" andHidAfterDelay:3.0];
            return NO;
        }
        else{
            // 2、手机号已填写，并且格式正确，则发送验证码。
            return YES;
            
            
        }
    }
}

// 检查密码：是否输入、格式是否正确
- (BOOL)checkPassword:(NSString *)password{
    
    // 1、先判断手机号是否填写、格式是否正确
    if ([password isEqualToString:@""]) {
        // 1.1、没有填写手机号
        
        [self showHubWithLabelText:@"请输入手机号" andHidAfterDelay:3.0];
        return NO;
    }
    else{
        
        // 1.2、已经填写手机号，判断格式是否正确
        BOOL isPassword = [CYUtilities checkTel:password];
        
        if (!isPassword) {
            // 1.3、手机号格式不正确
            [self showHubWithLabelText:@"请输入正确的手机号" andHidAfterDelay:3.0];
            return NO;
        }
        else{
            // 2、手机号已填写，并且格式正确，则发送验证码。
            return YES;
            
            
        }
    }
}

// 检查手机号、密码：是否输入、格式是否正确
- (BOOL)checkTel:(NSString *)tel andPassword:(NSString *)password{
    
    
    // test1、
//    if ([self checkTel:tel] && [self checkPassword:password]) {
//        
//        
//        return YES;
//    }
//    else{
//        return NO;
//    }
    
    
    // test2、
//    BOOL isTel = [self checkTel:tel];
//    
//    
//    BOOL isPassword = [self checkPassword:password];
//    
//    if (!isTel) {
//        
//        return NO;
//    }
//    else if (!isPassword){
//        
//        return NO;
//    }
//    else {
//        
//        return YES;
//    }
    
    
    
    
    // 0、判断手机号、密码：格式是否正确
    BOOL isTel = [CYUtilities checkTel:tel];
    BOOL isPassword = [CYUtilities checkPassword:password];
    
    
    // 1、判断手机号、密码：是否填写、格式是否正确
    if ([tel isEqualToString:@""]) {
        // 1.1.1、没有填写手机号
        
        [self showHubWithLabelText:@"请输入手机号" andHidAfterDelay:3.0];
        return NO;
    }
    else if (!isTel) {
        // 1.1.2、已经填写手机号，手机号格式不正确
        [self showHubWithLabelText:@"请输入正确的手机号" andHidAfterDelay:3.0];
        return NO;
    }
    else if ([password isEqualToString:@""]){
        
        // 1.2.1、没有填写密码
        [self showHubWithLabelText:@"请输入密码" andHidAfterDelay:3.0];
        return NO;
    }
    else if (!isPassword){
        
        // 1.2.2、已经填写密码，密码格式不正确
        [self showHubWithLabelText:@"请输入8~16位字母或数字的密码" andHidAfterDelay:3.0];
        return NO;
    }
    else {
        // 1.3、手机号、验证码、密码：都已输入，并且正确
        
        return YES;
    }
    
    
}

// 检查手机号、验证码、密码：是否输入、格式是否正确
- (BOOL)checkTel:(NSString *)tel andVerificationCode:(NSString *)verificationCode andPassword:(NSString *)password{
    
    
    // 0、判断手机号、验证码、密码：格式是否正确
    BOOL isTel = [CYUtilities checkTel:tel];
    BOOL isVerification = [CYUtilities checkVerificationCode:verificationCode];
    BOOL isPassword = [CYUtilities checkPassword:password];
    
    // 1、判断手机号、验证码、密码：是否填写、格式是否正确
    if ([tel isEqualToString:@""]) {
        // 1.1.1、没有填写手机号
        
        [self showHubWithLabelText:@"请输入手机号" andHidAfterDelay:3.0];
        return NO;
    }
    else if (!isTel) {
        // 1.1.2、已经填写手机号，手机号格式不正确
        [self showHubWithLabelText:@"请输入正确的手机号" andHidAfterDelay:3.0];
        return NO;
    }
    else if ([verificationCode isEqualToString:@""]){
        
        // 1.2.1、没有填写验证码
        [self showHubWithLabelText:@"请输入验证码" andHidAfterDelay:3.0];
        return NO;
    }
    else if (!isVerification){
        // 1.2.2、已经填写验证码，验证码格式不正确
        [self showHubWithLabelText:@"请输入4位数字的验证码" andHidAfterDelay:3.0];
        return NO;
    }
    else if ([password isEqualToString:@""]){
        
        // 1.3.1、没有填写密码
        [self showHubWithLabelText:@"请输入密码" andHidAfterDelay:3.0];
        return NO;
    }
    else if (!isPassword){
        
        // 1.3.2、已经填写密码，密码格式不正确
        [self showHubWithLabelText:@"请输入8~16位字母或数字的密码" andHidAfterDelay:3.0];
        return NO;
    }
    else {
        // 1.4、手机号、验证码、密码：都已输入，并且正确
        
        return YES;
    }
    
    
}


// 登录：网络请求
- (void)loginRequestWithAccount:(NSString *)userAccount andUserPSW:(NSString *)userPSW{
    
    // 拼接参数
    NSDictionary *params = @{
                             @"Account":userAccount,
                             @"Password":userPSW
                             };
    
    [self showLoadingView];
    
    // 登录请求
    [CYNetWorkManager postRequestWithUrl:cLoginUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"上传进度：%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"登录：提交信息成功！");
        NSLog(@"登录:responseObject:%@",responseObject);
        // 2.1、登录：提交信息成功
        // 2.1.1、获取code 值
        NSString *code = responseObject[@"code"];
        
        // 2.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"登录：成功！");
            
            
            
            
            // 2.1.2.1、登录成功，
            // 保存用户名、密码
            [self setCurrentUserWithUserAccount:userAccount andUserPSW:userPSW];
            
            // 设置当前登录的用户：保存token
            [self setCurrentUser:responseObject];
            
            
            
            
            
            _ifIsFirstLogin = [responseObject[@"res"][@"data"][@"isFirstLogin"] boolValue];
            NSLog(@"_ifIsFirstLogin:%d",_ifIsFirstLogin);
            
            
            // 判断是否第一次登陆
            if ([responseObject[@"res"][@"data"][@"isFirstLogin"] boolValue]) {
                
                // 是第一次登录，则弹出完善信息
                // 2.1、后台返回成功，跳到下个界面：完善信息界面
                CYPerfectInfoViewController *perfectInfoVC = [[CYPerfectInfoViewController alloc] init];
                
                
                perfectInfoVC.forUserCount = userAccount;
                perfectInfoVC.forUserPSW = userPSW;
                
                // navigationBar不隐藏
                self.navigationController.navigationBarHidden = NO;
                
                [self.navigationController pushViewController:perfectInfoVC animated:nil];
            }
            else {
                
//                
//                // 2.1.2.1、登录成功，
//                // 保存用户名、密码
//                [self setCurrentUserWithUserAccount:userAccount andUserPSW:userPSW];
//                
//                // 设置当前登录的用户：保存token
//                [self setCurrentUser:responseObject];
                
                // 创建mainTabbar，设置为根视图控制器
                [self loginSuccess];
            }
            
            
            
            
            // 隐藏加载菊花
            [self hidenLoadingView];
            
        }
        else{
            NSLog(@"登录：失败！");
            
            // 2.1.2.2、登录失败：弹窗提示：登录失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"登录：提交信息失败！");
        NSLog(@"error：%@",error);
        
        // 2.2、登录：提交信息失败：弹窗
        [self showHubWithLabelText:@"登录失败，可能是网络有问题，请检查网络再试一遍!" andHidAfterDelay:3.0];
        
        
    } withToken:nil];
    
    
}



// 登录成功，创建mainTabbar，设置为根视图控制器
- (void)loginSuccess{
    
    // 1、创建mainTabbar
    CYMainTabBarController *mainTabBarVC = [[CYMainTabBarController alloc] init];
    
    
    
    // 2、切换界面：切换window 的根视图控制器
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    appdelegate.window.rootViewController = mainTabBarVC;
    
    
}

// 登录成功，设置当前登录的用户。
- (void)setCurrentUser:(id)responseObject{
    NSLog(@"当前用户ID：%@",responseObject[@"res"][@"data"][@"userid"]);
    NSLog(@"当前用户token：%@",responseObject[@"res"][@"data"][@"token"]);
    
    
    // 1、获取用户单例
    CYUser *currentUser = [CYUser currentUser];
    
    // 2、赋值
    currentUser.userID = responseObject[@"res"][@"data"][@"userid"];
    currentUser.userToken = responseObject[@"res"][@"data"][@"token"];
    
    
    
    // 3、保存到本地：归档：沙盒路径
    // 3.1、获取保存的路径（这里为 Documents 的路径）（第一个参数要注意，是：NSDocumentDirectory）
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:@"/user.src"];
    
    // 3.2、保存
    [NSKeyedArchiver archiveRootObject:currentUser toFile:path];
    
}


// 保存用户的账号、密码。
- (void)setCurrentUserWithUserAccount:(NSString *)userAccount andUserPSW:(NSString *)userPSW{
    NSLog(@"当前用户userAccount：%@",userAccount);
    NSLog(@"当前用户userPSW：%@",userPSW);
    
    
    // 1、获取用户单例
    CYUser *currentUser = [CYUser currentUser];
    
    // 2、赋值
    currentUser.userAccount = userAccount;
    currentUser.userPSW = userPSW;
    
    
    
    // 3、保存到本地：归档：沙盒路径
    // 3.1、获取保存的路径（这里为 Documents 的路径）（第一个参数要注意，是：NSDocumentDirectory）
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:@"/user.src"];
    NSLog(@"user.src：path：%@",path);
    // 3.2、保存
    [NSKeyedArchiver archiveRootObject:currentUser toFile:path];
    
}

// 获取并保存用户个人信息到本地
- (void)requestAndSaveUserInfo{
    NSLog(@"获取并保存用户个人信息");
    
    CYUser *currentUser = [CYUser currentUser];
    
    // 请求数据
    
    // 参数
    NSDictionary *params = @{
                             @"userId":currentUser.userID
                             };
    
    // 显示加载
    //    [self showLoadingView];
    
    // 请求数据：获取用户个人信息
    [CYNetWorkManager getRequestWithUrl:cGetUserInfoUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取用户个人信息进度：%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"获取用户个人信息：请求成功！");
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"获取用户个人信息：获取成功！");
            NSLog(@"获取用户个人信息：%@",responseObject);
            
            
            //            CYUser *currentUser = [CYUser currentUser];
            
            // 2、赋值
            currentUser.Birthday = responseObject[@"res"][@"data"][@"userinfo"][@"Birthday"];
            currentUser.City = responseObject[@"res"][@"data"][@"userinfo"][@"City"];
            currentUser.Declaration = responseObject[@"res"][@"data"][@"userinfo"][@"Declaration"];
            currentUser.Education = responseObject[@"res"][@"data"][@"userinfo"][@"Education"];
            currentUser.FId = [responseObject[@"res"][@"data"][@"userinfo"][@"FId"] integerValue];
            currentUser.Gender = responseObject[@"res"][@"data"][@"userinfo"][@"Gender"];
            currentUser.Id = responseObject[@"res"][@"data"][@"userinfo"][@"Id"];
            currentUser.Marriage = responseObject[@"res"][@"data"][@"userinfo"][@"Marriage"];
            currentUser.Nickname = responseObject[@"res"][@"data"][@"userinfo"][@"Nickname"];
            
            currentUser.Province = responseObject[@"res"][@"data"][@"userinfo"][@"Province"];
            currentUser.RealName = responseObject[@"res"][@"data"][@"userinfo"][@"RealName"];
            currentUser.RongToken = responseObject[@"res"][@"data"][@"userinfo"][@"RongToken"];
            currentUser.Age = [responseObject[@"res"][@"data"][@"userinfo"][@"Age"] integerValue];
            
            // 头像
            NSString *portaitUrl = responseObject[@"res"][@"data"][@"userinfo"][@"Portrait"];
            if (portaitUrl.length > 18) {
                
                NSString *tempPortaitUrl = [portaitUrl substringToIndex:18];
                if ([tempPortaitUrl isEqualToString:@"/Uploads/AppImage/"]) {
                    
                    currentUser.Portrait = responseObject[@"res"][@"data"][@"userinfo"][@"Portrait"];
                }
                else {
                    currentUser.Portrait = @"默认头像";
                }
            }
            else {
                currentUser.Portrait = @"默认头像";
            }
            
            
        }
        else{
            NSLog(@"获取用户个人信息：获取失败:responseObject:%@",responseObject);
            NSLog(@"获取用户个人信息：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            //            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"获取用户个人信息：请求失败！:error:%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
        
    } withToken:currentUser.userToken];
    
    
    
}


// 头像点击事件：手势
- (void)headImgViewChangeClick{
    NSLog(@"头像点击事件：手势");
    
    // 选择框：相机、相册
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    
    //
    sheet.tag = 255;
    [sheet showInView:self.view];
    // 获取相册，选中的照片，设置为头像。
    //    self.picker = [[UIImagePickerController alloc] init];
    
    // 设置资源类型
    
    
}

// 选择框：相机、相册，选择的是哪一个：代理事件
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    // 取消
                    return;
                case 1:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    
                    break;
                case 2:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    
                    break;
                    
                default:
                    break;
            }
        }
        else {
            
            if (buttonIndex == 0) {
                
                return;
            }
            else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        
        // 跳转到相机或相册页面。
        UIImagePickerController *imgPickerController = [[UIImagePickerController alloc] init];
        
        imgPickerController.delegate = self;
        imgPickerController.allowsEditing = YES;
        imgPickerController.sourceType = sourceType;
        
        [self presentViewController:imgPickerController animated:YES completion:nil];
        
        //        [imgPickerController release];
    }
}

//// 用户余额：网络请求
//- (void)requestUserBalanceIfIsEnoughWithUserId:(NSString *)userId andOppUserId:(NSString *)oppUserId andLikeCount:(NSInteger)likeCount andCost:(float)cost{
//    NSLog(@"用户余额：网络请求！");
//    
//    [self showLoadingView];
//    
//    // 新地址
//    NSString *newUrl = [NSString stringWithFormat:@"%@?userId=%@",cUserMoneyUrl,userId];
//    
//    // 网络请求：用户余额
//    [CYNetWorkManager getRequestWithUrl:newUrl params:nil progress:^(NSProgress *uploadProgress) {
//        NSLog(@"用户余额：%@",uploadProgress);
//        
//        
//    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"用户余额：请求成功！");
//        
//        // 1、
//        NSString *code = responseObject[@"code"];
//        
//        // 1.2.1.1.2、和成功的code 匹配
//        if ([code isEqualToString:@"0"]) {
//            NSLog(@"用户余额：获取成功！");
//            NSLog(@"用户余额：%@",responseObject);
//            
//            
//            
//            // 请求数据结束，取消加载
//            //            [self hidenLoadingView];
//            
//            
//            NSString * tempMoneyStr = responseObject[@"res"][@"data"][@"userinfo"][@"Money"];
//            float tempMoney = [tempMoneyStr floatValue];
//            
//            // 如果余额够支付，则赞、支付
//            if (tempMoney >= cost) {
//                
//                self.isEnoughForPay = YES;
//                
//                // 网路请求：点一个赞
//                [self requestLikeWithUserId:self.onlyUser.userID andReceiveUserId:oppUserId andGiftCount:likeCount];
//                
//            }
//            // 余额不足，则弹到充值界面
//            else {
//                
//                // 请求数据结束，取消加载
//                [self hidenLoadingView];
//                
//                
//                // 余额不足弹窗：VC
//                CYBalanceNotEnoughVC *balanceNotEnoughVC = [[CYBalanceNotEnoughVC alloc] init];
//                
//                [self.navigationController pushViewController:balanceNotEnoughVC animated:YES];
//                
//            }
//        }
//        else{
//            NSLog(@"用户余额：获取失败:responseObject:%@",responseObject);
//            NSLog(@"用户余额：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
//            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
//            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
//            
//        }
//        
//        
//    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"用户余额：请求失败！");
//        NSLog(@"点一个赞：error：%@",error);
//        
//        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
//    } withToken:self.onlyUser.userToken];
//    
//}


// 点赞：网络请求
- (void)requestLikeWithUserId:(NSString *)userId andReceiveUserId:(NSString *)receiveUserId andLikeCount:(NSInteger)likeCount andAddLikeUrl:(NSString *)addLikeUrl{
    NSLog(@"点赞：网络请求！");
    
    [self showLoadingView];
    
    // 参数
    NSDictionary *params = @{
                             @"UserId":userId,
                             @"ReceiveUserId":receiveUserId,
                             @"Count":@(likeCount)
                             };
    
    // 网络请求：点 n 个赞
    [CYNetWorkManager postRequestWithUrl:addLikeUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"点 %ld 个赞：%@",(long)likeCount,uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"点 %ld 个赞：请求成功！",(long)likeCount);
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"点 %ld 个赞：点赞成功！",(long)likeCount);
            NSLog(@"点 %ld 个赞：%@",(long)likeCount,responseObject);
            
            
            
            // 请求数据结束，取消加载
//            [self hidenLoadingView];
            
#warning 点赞成功，发送消息到聊天列表
            
            
            [self showHubWithLabelText:[NSString stringWithFormat:@"点 %ld 个赞成功！",(long)likeCount] andHidAfterDelay:3.0];
            
        }
        else{
            NSLog(@"点 %ld 个赞：点赞:responseObject:%@",(long)likeCount,responseObject);
            NSLog(@"点 %ld 个赞：点赞:responseObject:res:msg:%@",(long)likeCount,responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"点 %ld 个赞：请求失败！",(long)likeCount);
        NSLog(@"点 %ld 个赞：error：%@",(long)likeCount,error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
}

// 送礼：网络请求
- (void)requestGiveGiftWithUserId:(NSString *)userId andReceiveUserId:(NSString *)receiveUserId andGiftCount:(NSInteger)giftCount{
    NSLog(@"送礼：网络请求！");
    
    [self showLoadingView];
    
    // 参数
    NSDictionary *params = @{
                             @"UserId":userId,
                             @"ReceiveUserId":receiveUserId,
                             @"Count":@(giftCount)
                             };
    
    // 网络请求：送 n 支玫瑰花
    [CYNetWorkManager postRequestWithUrl:cAddFlowersUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"送 %ld 支玫瑰花进度：%@",(long)giftCount,uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"送 %ld 支玫瑰花：请求成功！",(long)giftCount);
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"送 %ld 支玫瑰花：送礼成功！",(long)giftCount);
            NSLog(@"送 %ld 支玫瑰花：%@",(long)giftCount,responseObject);
            
            
            // 请求数据结束，取消加载
//            [self hidenLoadingView];
            
            [self showHubWithLabelText:[NSString stringWithFormat:@"送%ld朵玫瑰成功！",(long)giftCount] andHidAfterDelay:3.0];
            
        }
        else{
            NSLog(@"送 %ld 支玫瑰花：送礼:responseObject:%@",(long)giftCount,responseObject);
            NSLog(@"送 %ld 支玫瑰花：送礼:responseObject:res:msg:%@",(long)giftCount,responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"送 %ld 支玫瑰花：请求失败！",(long)giftCount);
        NSLog(@"失败原因：error：%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
}


// 分享：微信分享：文字类型分享
- (void)sharedToWeChatWithText:(NSString *)text bText:(BOOL)bText andScene:(int)scene{
    NSLog(@"分享：微信分享：文字类型分享");
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    
    req.text = text;
    req.bText = bText;
    req.scene = scene;
    
    [WXApi sendReq:req];
    
}

// 分享：微信分享：图片类型分享
- (void)shareToWechatWithThumbImage:(UIImage *)thumbImage andImageData:(NSData *)thumbImageData andbText:(BOOL)bText andScene:(int)scene{
    NSLog(@"分享：微信分享：图片类型分享");
    
    WXMediaMessage *message = [WXMediaMessage message];
    
    // 分享时，点击确认发送的界面展示的图片：缩略图
    [message setThumbImage:thumbImage];
    
    WXImageObject *imageObj = [WXImageObject object];
    
    // 图片的路径：转化为data，用于分享在聊天界面或朋友圈的数据
    imageObj.imageData = thumbImageData;;
    
    message.mediaObject = imageObj;
    
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = bText;
    req.message = message;
    req.scene = scene;
    
    
    [WXApi sendReq:req];
    
}

// 分享：微信分享：音乐类型分享
- (void)shareToWechatWithMusic{
    NSLog(@"分享：微信分享：音乐类型分享");
    
    WXMediaMessage *message = [WXMediaMessage message];
    
    message.title = @"音乐的标题";
    message.description = @"音乐的描述";
    
    // 音乐的显示缩略图
    [message setThumbImage:[UIImage imageNamed:@"默认头像.png"]];
    
    
    WXMusicObject *ext = [WXMusicObject object];
    
    ext.musicUrl = @"音乐的Url";
    ext.musicLowBandUrl = ext.musicUrl;
    
    ext.musicDataUrl = @"音乐的数据Url";
    ext.musicLowBandDataUrl = ext.musicDataUrl;
    
    message.mediaObject = ext;
    
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = 0;
    
    
    [WXApi sendReq:req];
    
}


// 分享：微信分享：视频类型分享
- (void)shareToWechatWithVideo{
    NSLog(@"分享：微信分享：视频类型分享");
    
    
    WXMediaMessage *message = [WXMediaMessage message];
    
    message.title = @"视频的标题";
    message.description = @"视频的描述";
    
    // 视频显示的缩略图
    [message setThumbImage:[UIImage imageNamed:@"默认头像.png"]];
    
    
    WXVideoObject *videoObj = [WXVideoObject object];
    
    videoObj.videoUrl = @"视频的播放地址Url";
    
    // 低分辨率的视频Url
    videoObj.videoLowBandUrl = videoObj.videoUrl;
    
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    
    req.bText = NO;
    req.message = message;
    req.scene = 0;
    
    
    [WXApi sendReq:req];
    
}


// 分享：微信分享：网页类型分享
- (void)sharedToWeChatWithWebpageWithShareTitle:(NSString *)shareTitle andDescription:(NSString *)shareDescription andImage:(UIImage *)image andWebpageUrl:(NSString *)webPageUrl andbText:(BOOL)bText andScene:(int)scene{
    NSLog(@"分享：微信分享：网页类型分享");
    
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = shareTitle;
    message.description = shareDescription;
    [message setThumbImage:image];
    
    
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = webPageUrl;
    
    
    message.mediaObject = webpageObject;
    
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = bText;
    req.message = message;
    
    
    // 分享到好友会话
    req.scene = scene;
    
    
    [WXApi sendReq:req];
    
    
    
}


// 自动计算label的高度、宽度
- (CGSize)labelAutoCalculateRectWith:(NSString *)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    //    [paragraphStyle release];
    labelSize.height = ceil(labelSize.height);
    labelSize.width = ceil(labelSize.width);
    return labelSize;
}

//获取当前视图的控制器
- (UIViewController*)viewControllerWithView:(UIView *)tempView{
    for (UIView* next = [tempView superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UINavigationController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

//获取当前视图的导航控制器
- (UINavigationController*)navigationControllerWithView:(UIView *)tempView{
    for (UIView* next = [tempView superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController*)nextResponder;
        }
    }
    return nil;
}

// 获取本机ip地址
- (NSString *)getIPAddress{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}


// 提示框
- (void)showHubWithLabelText:(NSString *)text andHidAfterDelay:(double)afterDelay{
    
    self.hud.labelText = text;
    
    
    [self.hud show:YES];
    [self.hud hide:YES afterDelay:afterDelay];
}

// 显示加载
- (void)showLoadingView{
    
    // 显示之前，先把HUD 提到最上层，保证不会被其他视图覆盖
    [self.view bringSubviewToFront:self.hud];
    
    self.hud.labelText = @"加载中~~";
    // 再显示
    [self.hud show:YES];
    
    
}

// 隐藏加载
- (void)hidenLoadingView{
    
    [self.hud hide:YES];
}


// 懒加载弹窗
- (MBProgressHUD *)hud{
    
    if (_hud == nil) {
        
        _hud = [[MBProgressHUD alloc] init];
        
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"加载中~~";
        
        [self.view addSubview:_hud];
    }
    
    return _hud;
}



- (NSMutableArray *)dataArray{
    
    if (_dataArray == nil) {
        
        _dataArray = [[NSMutableArray alloc] init];
    }
    
    return _dataArray;
}

//
- (CYUser *)onlyUser{
    
    if (_onlyUser == nil) {
        
        _onlyUser = [CYUser currentUser];
    }
    
    return _onlyUser;
}

//
- (CLLocationManager *)locationManager{
    
    if (_locationManager == nil) {
        
        _locationManager = [[CLLocationManager alloc] init];
        
    }
    
    return _locationManager;
}

@end
