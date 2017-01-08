//
//  CYMainTabBarController.m
//  NZNYiOS
//
//  Created by 男左女右 on 16/8/16.
//  Copyright © 2016年 NZNY. All rights reserved.
//

#import "CYMainTabBarController.h"




//// 地图需要
//#import <MapKit/MapKit.h>


// 滑动视图
#import "CYBaseSwipeViewController.h"



// 视频
#import "CYVideoFollowVC.h"
#import "CYVideoHotVC.h"


// 直播
#import "CYLiveViewController.h"
#import "CYLiveTrailerVC.h"
#import "CYLiveLiveVC.h"
#import "CYLiveFollowVC.h"


// 社区
#import "CYCommunityViewController.h"
// 我的
#import "CYMineViewController.h"

// 登录
#import "CYLoginViewController.h"

// 注册
#import "CYRegisterViewController.h"

// 登录
#import "CYLoginViewController.h"


// 聊天界面
#import "CYChatVC.h"


#import "UIImage+CYImage.h"


// 融云
//#import "RCDLive.h"
//#import <RongIMKit/RongIMKit.h>
//#import <RongIMLib/RongIMLib.h>

@interface CYMainTabBarController ()

@property (nonatomic,assign)int flag;

//
//// 定位
//@property (nonatomic,strong) CLLocationManager *locationManager;



@end

@implementation CYMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
//    
//    self.view.backgroundColor = [UIColor redColor];
//    NSLog(@"viewDidLoad哟~");
    
//    CYChatVC *chatVC = [[CYChatVC alloc] init];
    
    CYUser *currentUser = [CYUser currentUser];
    NSLog(@"当前用户ID：%@",currentUser.userID);
    NSLog(@"当前用户token：%@",currentUser.userToken);
    
    // 测试：当前登录的用户
    if (currentUser.userToken != nil) {
        
        // 定位：获取位置信息，地理位置编码、反编码
//        [self getLocationManager];
    }
    
    
    
    
    
    
    
    
    
    
#warning 登录融云服务器
//    [self setRongCloudKit];
    
    
    
    
    
    
    
    
    
    
    
    
    
    // 判断是否已经登录
//    [self determineWhetherLogin];

    // 判断创建哪个界面
    [self determineWhiceViewControllerCreate];
    
    
//    [self addChildViewController:self.mainTabBarC];
    
    
    
    // 获取并保存用户个人信息
    [self requestAndSaveUserInfo];
    
    // 阿里云播放器：初始化：代理
    [AliVcMediaPlayer setAccessKeyDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    self.view.backgroundColor = [UIColor cyanColor];
    NSLog(@"viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"viewDidAppear");
}


// 定位：获取位置信息，地理位置编码、反编码
//- (void)getLocationManager{
//    
//    // 实例化：定位管理者
//    self.locationManager = [[CLLocationManager alloc] init];
//    
//    // 问用户要授权：定位
//    //  先判断定位服务是否可用
//    if ([CLLocationManager locationServicesEnabled]) {
//        NSLog(@"已经开启了定位！");
//        // 定位可用
//        // 问用户要授权：定位（iOS 8 之后，需要在info 里面设置：给用户弹出提示的内容）
//        [self.locationManager requestWhenInUseAuthorization];;
//        
//    }
//    else {
//        
//        // 定位不可用
//        // 给用户提示
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"定位服务不可用~" preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            NSLog(@"定位不可用，则打开设置，设置定位");
//            // 打开设置
//            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
//                
//                // 打开其他应用
//                // @"tel://12345678"
//                // @"smb://789765"
//                
//                [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//            }
//            
//        }];
//        
//        [alert addAction:action];
//        
//        [self presentViewController:alert animated:YES completion:nil];
//    }
//    
//    // 设置定位的精度（精度越高越费电）
//    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    
//    
//    // 设置代理：位置变更后的回调
//    self.locationManager.delegate = self;
//    
//    // 设置位置变更后的精度
//    self.locationManager.distanceFilter = 1;
//    
//    // 开始定位，开始更新位置信息
//    [self.locationManager startUpdatingLocation];
//    
//    
//}
//
//
//// 定位：位置变更后的回调
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
//    
//    // 获取其中的一个位置
//    CLLocation *location = locations.firstObject;
//    
//    NSLog(@"定位：当前的位置：%@",location);
//    
//#warning 数据请求：把经纬度 发送给后台
//    // 当前用户
//    CYUser *currentUser = [CYUser currentUser];
//    
//    NSString *latitude = [NSString stringWithFormat:@"%lf",location.coordinate.latitude];
//    NSString *longitude = [NSString stringWithFormat:@"%lf",location.coordinate.longitude];
//    // 参数拼接
//    NSDictionary *params = @{
//                             @"UserId":currentUser.userID,
//                             @"Longitude":latitude,
//                             @"Latitude":longitude
//                             };
//    // 位置信息请求，把经纬度 发送给后台
//    [CYNetWorkManager postRequestWithUrl:cCoordinatesUrl params:params progress:^(NSProgress *uploadProgress) {
//        NSLog(@"当前进度：%@",uploadProgress);
//    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"位置信息请求：请求成功！");
//        
//        // 2.3.1.1、获取code 值
//        NSString *code = responseObject[@"code"];
//        
//        
//        // 2.3.1.2、判断返回值
//        if ([code isEqualToString:@"0"]) {
//            NSLog(@"位置信息请求：位置更新成功！");
//            
//            // 2.3.1.2.1、位置信息请求成功，
//            // 关闭定位
//            [self.locationManager stopUpdatingLocation];
//            
//            
//        }
//        else{
//            NSLog(@"位置信息请求：位置更新失败！");
//            NSLog(@"位置信息请求：位置更新失败：msg：%@",responseObject[@"res"][@"msg"]);
//            
//            // 2.3.1.2.2、位置信息请求失败，弹窗
//            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
//        }
//        
//    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"位置信息请求：请求失败！");
//        NSLog(@"失败error：%@",error);
//        
//        // 2.3.2、位置信息请求：请求失败
//        [self showHubWithLabelText:@"完善信息失败，可能是网络有问题，请检查网络再试一遍!" andHidAfterDelay:3.0];
//    } withToken:currentUser.userToken];
//    
//    // 关闭定位
//    [self.locationManager stopUpdatingLocation];
//    
//    // 地理位置反编码
//    [self locationWithLatitude:location.coordinate.latitude andLongitude:location.coordinate.longitude];
//}
//
//// 经纬度 -> 地理位置（地理位置反编码）
//- (void)locationWithLatitude:(CLLocationDegrees)latitude andLongitude:(CLLocationDegrees)longitude{
//    
//    // 根据经纬度，实例化一个位置信息
//    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
//    
//    // 生成地理位置编码类（编码、反编码 都需要这个类）
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    
//    // 反编码
//    //     把一个位置信息：location， 转成地理位置
//    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//        NSLog(@"反编码：把一个位置信息：location， 转成地理位置");
//        
//        
//        // 取出地标信息 （是一个数组，取出其中一个）
//        CLPlacemark *placeMark = placemarks.firstObject;
//        
//        // 取出详细的位置信息
//        NSDictionary *infoDic = placeMark.addressDictionary;
//        
//        
//        for (NSString *tmpKey in infoDic) {
//            
//            NSLog(@"key:%@，obj：%@",tmpKey,infoDic[tmpKey]);
//        }
//        
//        
//    }];
//}
//


// 判断是否已登录
- (void)determineWhetherLogin{
    
    _flag = 0;
    
}

// 判断创建哪个界面
- (void)determineWhiceViewControllerCreate{
    
//    _flag = 1;
//    
//    // _flag = 0，没有登录，则登录
//    if (_flag == 0) {
//        
//        // 创建登录界面
//        [self setupLoginViewController];
//    }
//    // 否则，已经登录，则显示界面
//    else{
//        
//        // 添加所有的tabBar子控制器
        [self setUpAllTabBarViewController];
//    }
    
}
//
//// 创建登录界面
//- (void)setupLoginViewController{
//    
//    
//    // 创建登录界面
//    CYLoginViewController *loginVC = [[CYLoginViewController alloc] init];
//    
//    UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
//    
//    
//    // navigationBar不透明，这样视图的原点在navigationBar的左下角
//    loginNav.navigationBar.translucent = NO;
//    
//    // 登录界面添加到视图
//    [self addChildViewController:loginNav];
//    
//    // 隐藏tabBar（因为视图继承与TabBarVC）
//    self.tabBar.hidden = YES;
//    
//    _flag = 1;
//
//}



// 添加所有的tabBar子控制器
- (void)setUpAllTabBarViewController{
    
    
    
    
    // 视频
    CYVideoFollowVC *videoFollowVC = [[CYVideoFollowVC alloc] init];
    CYVideoHotVC *videoHotVC = [[CYVideoHotVC alloc] init];
    
    // 第一个tabBar：视频页面
    CYBaseSwipeViewController *videoVC = [[CYBaseSwipeViewController alloc] initWithSubVC:@[videoHotVC,videoFollowVC] andTitles:@[@"热门",@"关注"]];
    
    
    [self setUpOneTabBarViewController:videoVC image:[UIImage imageNamed:@"视频"] selectedImage:[UIImage imageWithOriginalName:@"视频当前"] title:@"视频"];    
    
    
    // 直播
//    CYLiveViewController *liveVC = [[CYLiveViewController alloc] init];
//    
//    [self setUpOneTabBarViewController:liveVC image:[UIImage imageNamed:@"直播"] selectedImage:[UIImage imageWithOriginalName:@"直播当前"] title:@"直播"];
    
    // 直播
    // 直播节目高度
    CGFloat liveViewHeight = cScreen_Height - 20 - 49 - 76 - 5;
    CYLiveTrailerVC *liveTrailerVC = [[CYLiveTrailerVC alloc] init];
    liveTrailerVC.view.frame = CGRectMake(0, 0, cScreen_Width, liveViewHeight);
    liveTrailerVC.baseCollectionView.frame = CGRectMake(0, 0, cScreen_Width, liveViewHeight);
    CYLiveLiveVC *liveLiveVC = [[CYLiveLiveVC alloc] init];
//    CYLiveFollowVC *liveFollowVC = [[CYLiveFollowVC alloc] init];
    
    liveLiveVC.view.frame = CGRectMake(0, 0, cScreen_Width, liveViewHeight);
    liveLiveVC.baseCollectionView.frame = CGRectMake(0, 0, cScreen_Width, liveViewHeight);
    
    // 第二个tabBar：直播页面
    CYBaseSwipeViewController *liveVC = [[CYBaseSwipeViewController alloc] initWithSubVC:@[liveTrailerVC,liveLiveVC] andTitles:@[@"预告",@"直播"]];
    liveVC.view.frame = CGRectMake(0, 0, cScreen_Width, liveViewHeight);
    liveVC.bgScrollView.frame = CGRectMake(0, (76.0 / 1334.0) * self.view.frame.size.height, cScreen_Width,liveViewHeight);
    
    [self setUpOneTabBarViewController:liveVC image:[UIImage imageNamed:@"直播"] selectedImage:[UIImage imageWithOriginalName:@"直播当前"] title:@"直播"];
    
    // 社区
    CYCommunityViewController *communityVC = [[CYCommunityViewController alloc] init];
    
    [self setUpOneTabBarViewController:communityVC image:[UIImage imageNamed:@"社区"] selectedImage:[UIImage imageWithOriginalName:@"社区当前"] title:@"社区"];
    
    
    // 我的
    CYMineViewController *mineVC = [[CYMineViewController alloc] init];
    
    [self setUpOneTabBarViewController:mineVC image:[UIImage imageNamed:@"我的"] selectedImage:[UIImage imageWithOriginalName:@"我的当前"] title:@"我的"];
    
    
//    self.viewControllers = self.viewsArr;
    
}

// 添加每一个子控制器
- (void)setUpOneTabBarViewController:(UIViewController *)vc image:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title{
    
    // 1、导航控制器
    //  导航条设置为不透明的（这样创建的视图（0，0）点，是在导航条左下角开始的。）
    UINavigationController *homeNav = [CYUtilities createDefaultNavCWithRootVC:vc BgColor:nil TintColor:[UIColor whiteColor] translucent:NO titleColor:[UIColor whiteColor] title:title bgImg:[UIImage imageNamed:@"Title1"]];
    
    homeNav.delegate = self;
    
    // 2、当前视图的标题
    vc.title = title;
    
    // 3、tabBar控制器
    vc.tabBarItem.title = title;
    
    vc.tabBarItem.image = image;
    
    vc.tabBarItem.selectedImage = selectedImage;
    
//    homeNav.navigationBarHidden = YES;
    
    [self addChildViewController:homeNav];
    
//    [self.viewsArr addObject:homeNav];
    
    
}


// 提示框
- (void)showHubWithLabelText:(NSString *)text andHidAfterDelay:(double)afterDelay{
    
    self.hud.labelText = text;
    
    
    [self.hud show:YES];
    [self.hud hide:YES afterDelay:afterDelay];
}

// 获取并保存用户个人信息
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
            
            
            
#warning 本应该在这里进入融云的初始化的
            // 融云：SDK-初始化
            [self setRongSDKWithCurrentUser:currentUser];
            
            // 请求数据结束，取消加载
//            [self hidenLoadingView];
            
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

// 融云：SDK-初始化
- (void)setRongSDKWithCurrentUser:(CYUser *)currentUser{
    
    
#warning 请求后台：获取用户在融云的token
    // 使用获用户在融云的token，连接融云的服务器；
    [self requestRongTokenWithCurrentUser:currentUser];
    
    
}

// 网络请求：后台：获取用户在融云的token
- (void)requestRongTokenWithCurrentUser:(CYUser *)currentUser{
    NSLog(@"网络请求：后台：获取用户在融云的token");
    
    // 请求数据：获取用户在融云的token
    NSDictionary *params = @{
                             @"userId":currentUser.userID
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
            
            // 张
//            rongToken = @"zgCNXiP/62lr5pXORE67srHIHFwdwGnJW2MDqrF5Ircl4YscTNyXhI3Vzxrp3/NyTXwSNrzIgzYzv4bk07wAT1/Zo5L7SGb1Ze4k30upkAJWWqqCQKRhihV/1StAMQGClpa8fh+ptCw=";
            
            // 陈
//            rongToken = @"6pmtKgVJTdRa3Dspk8HK65G9QNwaviwLSzaRfvRwsqHFxClCT3mDQXMeZ0r/1J+V4joLMAwDhHKnj4sOrB3PtcQLqxcLBIeBn9TFPeFy3bq8Z9Vnd8sqL6asCG/Y4rULWDSNIP5Z+Jk=";
            
            NSLog(@"rongToken:%@",rongToken);
            
            // 融云：SDK-初始化：整个生命周期，只初始化一次
            // Kit：初始化
            [self setRongCloudKitWithCurrentUser:currentUser andRongToken:rongToken];
            
            
            
            // 融云：Lib：初始化
//            [self setRongCloudLibWithCurrentUser:currentUser andRongToken:rongToken];
            
            
            // 融云：初始化：使用RCDLive进行初始化
//            [self setRongCloudWithRCDLiveWithCurrentUser:currentUser andRongToken:rongToken];
            
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
        
    } withToken:currentUser.userToken];
    
}

// 融云：初始化：使用RCDLive进行初始化
- (void)setRongCloudWithRCDLiveWithCurrentUser:(CYUser *)currentUser andRongToken:(NSString *)rongToken{
    
    
    [[RCDLive sharedRCDLive] initRongCloud:cRongAppKey];
    
    //注册自定义消息：送礼
    [[RCDLive sharedRCDLive] registerRongCloudMessageType:[RCDLiveGiftMessage class]];
    
    
    NSLog(@"rongToken:%@",rongToken);
    
    // 连接融云：RCDLive来连接：用token
    [[RCDLive sharedRCDLive] connectRongCloudWithToken:rongToken success:^(NSString *loginUserId) {
        NSLog(@"融云：RCDLive：连接融云服务器，登录成功，当前登录的用户，在融云的ID：%@",loginUserId);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            
            RCUserInfo *user = [[RCUserInfo alloc]init];
            user.userId = currentUser.userID;
            user.portraitUri = currentUser.Portrait;
            user.name = currentUser.RealName;
            
            
            // 当前的用户：
            [RCIMClient sharedRCIMClient].currentUserInfo = user;
            
            
        });
    } error:^(RCConnectErrorCode status) {
        NSLog(@"融云：RCDLive：连接融云服务器，登录失败，错误码为：%ld",(long)status);
        
    } tokenIncorrect:^{
        NSLog(@"融云：RCDLive：token错误");
        
        
    }];
}


// 融云：Kitb：初始化
- (void)setRongCloudKitWithCurrentUser:(CYUser *)currentUser andRongToken:(NSString *)rongToken{
    
    NSLog(@"rongToken:%@",rongToken);
    
    [[RCIM sharedRCIM] initWithAppKey:cRongAppKey];
//    [[RCDLive sharedRCDLive] initRongCloud:cRongAppKey];
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
        [RCIMClient sharedRCIMClient].currentUserInfo = user;

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

// 融云：Lib：初始化
- (void)setRongCloudLibWithCurrentUser:(CYUser *)currentUser andRongToken:(NSString *)rongToken{
    
    
    [[RCIMClient sharedRCIMClient] initWithAppKey:cRongAppKey];
    //    // Lib：代理
    [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:self object:nil];
    [[RCIMClient sharedRCIMClient] setRCConnectionStatusChangeDelegate:self];
    
    //     Lib：连接服务器
    [[RCIMClient sharedRCIMClient] connectWithToken:rongToken success:^(NSString *userId) {
        NSLog(@"融云：Lib：登陆成功。当前登录的用户ID：%@", userId);
        
        
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = currentUser.userID;
        user.portraitUri = currentUser.Portrait;
        user.name = currentUser.RealName;
        
        // 当前的用户：
        [RCIMClient sharedRCIMClient].currentUserInfo = user;
        
        
    } error:^(RCConnectErrorCode status) {
        NSLog(@"融云：Lib：登陆的错误码为:%ld", (long)status);
    } tokenIncorrect:^{
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"融云：Lib：token错误");
    }];
    
    
    
}







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




// 阿里播放器：初始化
-(AliVcAccesskey*)getAccessKeyIDSecret
{
    AliVcAccesskey* accessKey = [[AliVcAccesskey alloc] init];
    accessKey.accessKeyId = cALiPlayAppKeyId;
    accessKey.accessKeySecret = cALiPlaySecret;
    return accessKey;
}



// 懒加载弹窗
- (MBProgressHUD *)hud{
    
    if (_hud == nil) {
        
        _hud = [[MBProgressHUD alloc] init];
        
        _hud.mode = MBProgressHUDModeText;
        _hud.labelText = @"错误";
        
        [self.view addSubview:_hud];
    }
    
    return _hud;
}

-(NSMutableArray *)viewsArr{
    if (_viewsArr == nil) {
        
        _viewsArr = [[NSMutableArray alloc] init];
    }
    
    return _viewsArr;
}


- (RCUserInfo *)rcUserInfo{
    
    if (_rcUserInfo == nil) {
        
        _rcUserInfo = [[RCUserInfo alloc] init];
    }
    
    return _rcUserInfo;
}


@end
