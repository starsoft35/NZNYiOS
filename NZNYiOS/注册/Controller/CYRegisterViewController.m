//
//  CYRegisterViewController.m
//  NZNYiOS
//
//  Created by 男左女右 on 16/9/12.
//  Copyright © 2016年 NZNY. All rights reserved.
//

#import "CYRegisterViewController.h"

// 注册View
#import "CYRegisterMainView.h"

// 完善信息VC
#import "CYPerfectInfoViewController.h"


// 用户注册协议：VC
#import "CYUserRegisterProtocolVC.h"


@interface CYRegisterViewController ()

@property (nonatomic,strong)CYRegisterMainView *registerMainV;

@end

@implementation CYRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"注册";
    
    // 设置注册视图
    [self setRegisterVC];
    
}

// 设置注册视图
- (void)setRegisterVC{
    
    _registerMainV = [[[NSBundle mainBundle] loadNibNamed:@"CYRegisterMainView" owner:self options:nil] lastObject];
    
    _registerMainV.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height - 64);
    
    
    // 发送验证码button：点击事件
    [_registerMainV.sendVerificationBtn addTarget:self action:@selector(sendVerificationBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 密码显示隐藏：点击事件
    //  1、最开始，密码为隐藏，设置flag = 1，让第一次点击的时候，变成显示。
    self.passwordFlag = 1;
    //  2、手势
    _registerMainV.passwordDisplayOrHideImgView.userInteractionEnabled = YES;
    [_registerMainV.passwordDisplayOrHideImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(passwordDisplayOrHideImgViewClick)]];
    
    // 注册button：点击事件
    [_registerMainV.registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 已有账号，去登录button：点击事件
    [_registerMainV.goLoginBtn addTarget:self action:@selector(goLoginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 用户注册协议：label
    NSString *userRegisterProtocol = @"注册即表示您同意《男左女右用户注册协议》";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:userRegisterProtocol];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.50 green:0.50 blue:0.50 alpha:1.00] range:[userRegisterProtocol rangeOfString:@"注册即表示您同意"]];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.37 green:0.65 blue:0.99 alpha:1.00] range:[userRegisterProtocol rangeOfString:@"《男左女右用户注册协议》"]];
    _registerMainV.userRegisterProtocolLab.attributedText = attributedString;
    
    // 用户注册协议：label：点击事件
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userRegisterProtocolLabClick)];
    // 2. 将点击事件添加到label上
    [_registerMainV.userRegisterProtocolLab addGestureRecognizer:labelTapGestureRecognizer];
    _registerMainV.userRegisterProtocolLab.userInteractionEnabled = YES;
    
    [self.view addSubview:_registerMainV];
}

// 用户注册协议：label：点击事件
- (void)userRegisterProtocolLabClick{
    NSLog(@"用户注册协议：label：点击事件");
    
    CYUserRegisterProtocolVC *userRegisterProtocolVC = [[CYUserRegisterProtocolVC alloc] init];
    
    
    [self.navigationController pushViewController:userRegisterProtocolVC animated:YES];
    
}

// 密码显示隐藏：点击事件
- (void)passwordDisplayOrHideImgViewClick{
    NSLog(@"密码显示隐藏：点击事件");
    
    [self passwordDisplayOrHideImgViewClickWithImgView:_registerMainV.passwordDisplayOrHideImgView andTexeField:_registerMainV.passwordTF];
    
    
}

// 发送验证码button：点击事件
- (void)sendVerificationBtnClick{
    NSLog(@"发送验证码button：点击事件");
    
    // 1、先判断手机号是否填写、格式是否正确
    if ([_registerMainV.cellNumTF.text isEqualToString:@""]) {
        // 1.1、没有填写手机号
        
        [self showHubWithLabelText:@"请输入手机号" andHidAfterDelay:3.0];
    }
    else{
        
        // 1.2、已经填写手机号，判断格式是否正确
        BOOL isTel = [CYUtilities checkTel:_registerMainV.cellNumTF.text];
        
        if (!isTel) {
            // 1.3、手机号格式不正确
            [self showHubWithLabelText:@"请输入正确的手机号" andHidAfterDelay:3.0];
        }
        else{
            
            
            // 2、手机号已填写，并且格式正确，则发送验证码。
            
            // 2.1、发送验证码：SMSSDK第三方
            [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.registerMainV.cellNumTF.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
                
                if (!error) {
                    NSLog(@"获取验证码成功！");
                    
                    // 2.1.1、发送成功，等待用户收到，并填写
                }
                else{
                    NSLog(@"获取验证码失败，错误信息：error：%@",error);
                    
                    // 2.1.2、发送失败，
                    [self showHubWithLabelText:[NSString stringWithFormat:@"%@",error.userInfo[@"getVerificationCode"]] andHidAfterDelay:3.0];
                }
                
            }];
            
            
            // 2.2、发送验证码button：改变状态，开始倒计时。
            //  倒计时初始为60
            self.repeatSendVerifiTime = 60;
            NSString *str = [NSString stringWithFormat:@"%ldS 后重发",self.repeatSendVerifiTime];
            _registerMainV.sendVerificationBtn.enabled = NO;
            _registerMainV.sendVerificationBtn.backgroundColor = [UIColor lightGrayColor];
            [_registerMainV.sendVerificationBtn setTitle:str forState:UIControlStateDisabled];
            
            // 设置验证码button定时器
            [self setRepeatBtnTimer];
            
            
        }
    }
    
}


// 设置验证码button定时器
- (void)setRepeatBtnTimer{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(repeatBtnTimerCountdown) userInfo:nil repeats:YES];
}

// 验证码button定时器：执行的方法
- (void)repeatBtnTimerCountdown{
    
    NSString *repeatBtnTitle = [NSString stringWithFormat:@"%ldS 后重发",self.repeatSendVerifiTime - 1];
    
    [self timerCountdownWithRepeatBtn:_registerMainV.sendVerificationBtn andCountdownTime:1 andBtnDisabledTitle:repeatBtnTitle andNormalTitle:@"发送验证码"];
    
    
}

// 注册button：点击事件
- (void)registerBtnClick{
    NSLog(@"注册button：点击事件");
    
    // 1、先判断手机号、验证码、密码：是否填写、格式是否正确
    BOOL allInfoIsRight = [self checkTel:_registerMainV.cellNumTF.text andVerificationCode:_registerMainV.verificationTF.text andPassword:_registerMainV.passwordTF.text];
    
    
    if (allInfoIsRight) {
        // 2、用户名、密码、验证码，填写并且格式正确，提交信息到后台
        
        // 2.1、请求数据：注册
        [self registerRequest];
        
        
    }
    
}

// 请求数据：注册
- (void)registerRequest{
    
    
    // 拼接参数：注册
    NSDictionary *registParams = @{
                             @"Account":self.registerMainV.cellNumTF.text,
                             @"MobileCode":self.registerMainV.verificationTF.text,
                             @"Password":self.registerMainV.passwordTF.text,
                             @"ConfirmPassword":self.registerMainV.passwordTF.text
                             };
    
    
    // 拼接参数：登录
    NSDictionary *loginParams = @{
                             @"Account":self.registerMainV.cellNumTF.text,
                             @"Password":self.registerMainV.passwordTF.text
                             };
    
    
    // 注册请求
    [CYNetWorkManager postRequestWithUrl:cRegisterUrl params:registParams progress:^(NSProgress *uploadProgress) {
        NSLog(@"注册请求进度：%@",uploadProgress);
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        
        NSLog(@"注册：提交信息成功!");
        
        //NSLog(@"--------------------");
        
        
        // 1、获取code 值
        NSString *code = responseObject[@"code"];
        
        // 2、判断返回值
        if ([code isEqualToString:@"0"]) {
            NSLog(@"注册：成功！");
            
            
            
            
            // 2.1、后台返回成功，跳到下个界面：完善信息界面
            CYPerfectInfoViewController *perfectInfoVC = [[CYPerfectInfoViewController alloc] init];
            
            perfectInfoVC.forUserCount = self.registerMainV.cellNumTF.text;
            perfectInfoVC.forUserPSW = self.registerMainV.passwordTF.text;
            
            // navigationBar不隐藏
            self.navigationController.navigationBarHidden = NO;
            
            [self.navigationController pushViewController:perfectInfoVC animated:nil];
            
//            
//            // 2.0、保存用户信息：账号、密码
//            [self setCurrentUserWithUserAccount:self.registerMainV.cellNumTF.text andUserPSW:self.registerMainV.passwordTF.text];
//            
            // 2.0、保存登录状态：获取token、userID，并保存
            [CYNetWorkManager postRequestWithUrl:cLoginUrl params:loginParams progress:^(NSProgress *uploadProgress) {
                NSLog(@"保存登录用户信息进度：%@",uploadProgress);
            } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
                NSLog(@"登录：提交信息成功！");
                
                // 2.1、登录：提交信息成功
                // 2.1.1、获取code 值
                NSString *code = responseObject[@"code"];
                
                // 2.1.2、和成功的code 匹配
                if ([code isEqualToString:@"0"]) {
                    NSLog(@"登录：成功！");
                    
                    // 2.1.2.1、登录成功，
                    // 设置当前登录的用户。
                    [self setCurrentUser:responseObject];
                    
                    
//                    // 2.1、后台返回成功，跳到下个界面：完善信息界面
//                    CYPerfectInfoViewController *perfectInfoVC = [[CYPerfectInfoViewController alloc] init];
//                    
//                    // navigationBar不隐藏
//                    self.navigationController.navigationBarHidden = NO;
//                    
//                    [self.navigationController pushViewController:perfectInfoVC animated:nil];
                    
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
        else{
            NSLog(@"注册：失败！");
            NSLog(@"注册：失败：原因：%@",responseObject[@"res"][@"msg"]);
            
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
        }
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"注册：提交信息失败！");
        NSLog(@"注册：提交信息失败：error：%@",error);
        
        // 2.2、登录：提交信息失败：弹窗
        [self showHubWithLabelText:@"注册失败，可能是网络有问题，请检查网络再试一遍!" andHidAfterDelay:3.0];
        
    } withToken:nil];
    
    
}

// 已有账号，去登录button：点击事件
- (void)goLoginBtnClick{
    
    [self dismissViewControllerAnimated:nil completion:nil];
    
}

@end
