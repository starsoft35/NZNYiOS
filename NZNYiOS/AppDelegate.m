//
//  AppDelegate.m
//  NZNYiOS
//
//  Created by 男左女右 on 16/8/16.
//  Copyright © 2016年 NZNY. All rights reserved.
//

#import "AppDelegate.h"


#import <AVFoundation/AVFoundation.h>

// 主视图控制器
#import "CYMainTabBarController.h"

// 登录视图控制器
#import "CYLoginViewController.h"
//
//// 注册
//#import "CYRegisterViewController.h"
//
//// 忘记密码
//#import "CYForgetPSViewController.h"
//
// 完善信息
#import "CYPerfectInfoViewController.h"

// 用户：单例
#import "CYUser.h"



@interface AppDelegate ()

// 保存用户信息路径
@property (nonatomic,strong)NSString *userInfoPath;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 0、短信验证码SDK：初始化
    [SMSSDK registerApp:cSMSAppKey withSecret:cSMSAppSecret];
    
    // 微信登录SDK：初始化：注册
    [self weChatRegister];
    
//    // 融云：SDK-初始化
//    [self setRongSDK];
    
    
    // 1、创建一个UIWindow 窗口
    [self setUpWindow];
    
    // 2、设置根视图控制器
    // 2.1、获取保存的路径
    _userInfoPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:@"/user.src"];
    NSLog(@"_userInfoPath:%@",_userInfoPath);
    
    // 2.2、判断这个路径下有没有文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:self.userInfoPath]) {
        
        // 2.2.1、有保存的本地用户，获取本地保存的用户，设置mainTabbarController 为根视图控制器
        [self setRootVCWithMainTabBarController];
    }
    else{
        
        // 2.2.2、没有保存登录用户，让用户登录，设置登录VC 为根视图控制器。
        [self setUpRootVCWithLoginVC];
        
    }
    
    
    return YES;
}

//- (void)applicationDidFinishLaunching:(UIApplication *)application{
//    
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//}


// 设置mainTabbarController 为根视图控制器
- (void)setRootVCWithMainTabBarController{
    // 有保存的本地用户，获取本地保存的用户，设置mainTabbarController 为根视图控制器
    

    
    // 1、解出来本地用户（解归档）
    CYUser *user = [NSKeyedUnarchiver unarchiveObjectWithFile:self.userInfoPath];
    
    // 取单例
    CYUser *currentUser = [CYUser currentUser];
    
    
    // 2、读取本地保存的用户数据
    currentUser.userID = user.userID;
    currentUser.userToken = user.userToken;
    currentUser.userAccount = user.userAccount;
    currentUser.userPSW = user.userPSW;
    
    // 暂时定为每次登陆都做重新登陆，重新获取token，如果是微信登录，则不让其用账号密码重新登录。
    if (currentUser.userAccount != nil && currentUser.userPSW != nil) {
        
        // 有文件：如果有账号、密码，说明之前是账号密码登录，则用账号、密码重新登录
        [self tempLoginRequestWithUserAccount:currentUser.userAccount andUserPSW:currentUser.userPSW];
    }
    else {
        
        // 有文件：如果没有账号密码，说明之前是微信登录，则用微信重新登录
        // 微信：重新登录
        [self weChatLoginRequestAgain];
        
    }
    
    NSLog(@"userAccount:%@",user.userAccount);
    NSLog(@"userToken:%@",user.userToken);
    // 3、设置根视图控制器
    self.window.rootViewController = [[CYMainTabBarController alloc] init];
    
}

// 微信：重新登录，重新获取token
- (void)weChatLoginRequestAgain{
    
    // 授权登录：构造SendAuthReq结构体
    SendAuthReq *req = [[SendAuthReq alloc] init];
    
    req.scope = cWXScope;
    req.state = cWXState;
    
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}


// // 账号、密码：重新登录，重新获取token
- (void)tempLoginRequestWithUserAccount:(NSString *)userAccount andUserPSW:(NSString *)userPSW{
    
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
        NSLog(@"登录：提交信息成功！:responseObject:%@",responseObject);
        
        // 2.1、登录：提交信息成功
        // 2.1.1、获取code 值
        NSString *code = responseObject[@"code"];
        
        // 2.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"登录：成功！");
            
            // 2.1.2.1、登录成功，
            
            // 设置当前登录的用户。
            [self setCurrentUser:responseObject];
            
//            
//            // 3、设置根视图控制器
//            self.window.rootViewController = [[CYMainTabBarController alloc] init];
            
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


// 设置登录VC 为根视图控制器
- (void)setUpRootVCWithLoginVC{
    
    // 设置登录VC 为根视图控制器
    // 创建登录界面
    CYLoginViewController *loginVC = [[CYLoginViewController alloc] init];
    
    // 导航VC
    UINavigationController *loginNav = [CYUtilities createDefaultNavCWithRootVC:loginVC BgColor:nil TintColor:[UIColor whiteColor] translucent:NO titleColor:[UIColor whiteColor] title:@"登录" bgImg:[UIImage imageNamed:@"Title1"]];
    
    // 设置根视图控制器
    self.window.rootViewController = loginNav;
    
    
}


// 创建一个UIWindow 窗口
- (void)setUpWindow{
    
    // 创建一个UIWindow 窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // 设置窗口的背景颜色
    self.window.backgroundColor = [UIColor whiteColor];
    
    // 设置状态栏样式
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // 让窗口显示
    [self.window makeKeyAndVisible];
}

#pragma --微信初始化
// 微信登录button 点击事件
- (void)weChatRegister{
    NSLog(@"微信登录SDK：初始化：注册");
    
    // 向微信注册
    [WXApi registerApp:cWXAppID];
    
}


// 重写微信SDK 的代理方法
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    NSLog(@"重写微信SDK 的代理方法：handleOpenURL");
    
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    NSLog(@"重写微信SDK 的代理方法：openURL");
    
    
    return [WXApi handleOpenURL:url delegate:self];
    
}

// WXApiDelegate协议的两个方法：实现和微信终端交互的具体请求与回应
- (void)onReq:(BaseReq *)req{
    NSLog(@"onReq:");
    NSLog(@"微信登录button：点击事件：req：%@",req);
    
    
    // onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
}
- (void)onResp:(BaseResp *)resp{
    NSLog(@"微信登录授权响应，回调值：resp：%@",resp);
    
    // 第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面
    
    // 授权第三方登录：
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        
        // 授权，则发送sendAuthResp
        SendAuthResp *tempresp = [[SendAuthResp alloc] init];
        
        tempresp = (SendAuthResp *)resp;
        NSLog(@"resp：code：%@",tempresp.code);
        
        // 网络请求：微信登录接口（把code发送给自己服务器，服务器返回token）
        [self weChatLoginRequestWithCode:tempresp.code];
        
    }
    
    
    // 微信支付:    
    if ([resp isKindOfClass:[PayResp class]]) {
        
        PayResp *response = (PayResp *)resp;
        switch (response.errCode) {
            case WXSuccess:
                
                // 服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功！");
                break;
                
            default:
                
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                break;
        }
    }
    
    
}


// 网络请求：微信登录
- (void)weChatLoginRequestWithCode:(NSString *)weChatCode{
    
    // URL parameters
    NSString *newUrlStr = [NSString stringWithFormat:@"%@?code=%@",cWXLoginUrl,weChatCode];
    
    [self showLoadingView];
    
    // 网络请求：微信登录
    [CYNetWorkManager postRequestWithUrl:newUrlStr params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"微信登录：progress:%@",uploadProgress);
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"微信登录：请求成功！");
        
        
        // 2.3.1.1、获取code 值
        NSString *code = responseObject[@"code"];
        
        // 2.3.1.2、判断返回值
        if ([code isEqualToString:@"0"]) {
            NSLog(@"微信登录：登录成功！");
            
            // 设置当前登录的用户。
            [self setCurrentUser:responseObject];
            
            
            // 是否第一次登录
            _isFirstLogin = responseObject[@"res"][@"isFirstLogin"];
            
            if (_isFirstLogin) {
                NSLog(@"微信登录：是第一次登录");
                
                // 完善信息
                CYPerfectInfoViewController *perfectInfoVC =[[CYPerfectInfoViewController alloc] init];
                
                [self.window.rootViewController presentViewController:perfectInfoVC animated:YES completion:nil];
                
            }
            else {
                NSLog(@"微信登录：不是第一次登录");
                
                // 创建mainTabbar，设置为根视图控制器
                [self loginSuccess];
            }
            
        }
        else{
            NSLog(@"微信登录：登录失败！");
            NSLog(@"msg:%@",responseObject[@"res"][@"msg"]);
            
            
            // 2.3.1.2.2、微信登录失败，弹窗
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
        }
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"微信登录：请求失败！");
        NSLog(@"error:%@",error);
        
        // 微信登录：请求：失败，加载菊花消失
        [self hidenLoadingView];
        
        // 2.3.1.2.2、微信登录失败，弹窗
        [self showHubWithLabelText:@"网络错误，请重新上传！" andHidAfterDelay:3.0];
        
    } withToken:nil];
    
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

// 登录成功，创建mainTabbar，设置为根视图控制器
- (void)loginSuccess{
    
    // 1、创建mainTabbar
    CYMainTabBarController *mainTabBarVC = [[CYMainTabBarController alloc] init];
    
    // 2、切换界面：切换window 的根视图控制器
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    
    appdelegate.window.rootViewController = mainTabBarVC;
    
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
    [self.window.rootViewController.view bringSubviewToFront:self.hud];
    
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
        
        [self.window.rootViewController.view addSubview:_hud];
    }
    
    return _hud;
}

@end
