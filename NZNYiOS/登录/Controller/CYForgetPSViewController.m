//
//  CYForgetPSViewController.m
//  NZNYiOS
//
//  Created by 男左女右 on 16/9/17.
//  Copyright © 2016年 NZNY. All rights reserved.
//

#import "CYForgetPSViewController.h"

// 忘记密码视图
#import "CYForgetPSMainView.h"


@interface CYForgetPSViewController ()

// 忘记密码视图
@property (nonatomic,strong)CYForgetPSMainView *forgetPSMainView;





@end

@implementation CYForgetPSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"忘记密码";
    
    
    
    // 设置忘记密码视图
    [self setForgePSVMainV];
    
    
}

// 设置忘记密码视图
- (void)setForgePSVMainV{
    
    _forgetPSMainView = [[[NSBundle mainBundle] loadNibNamed:@"CYForgetPSMainView" owner:nil options:nil] lastObject];
    
    _forgetPSMainView.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height - 64);
    
    // 发送验证码button：点击事件
    [_forgetPSMainView.sendVerificationBtn addTarget:self action:@selector(sendVerificationBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 密码显示隐藏：点击事件
    //  1、最开始，密码为隐藏，设置flag = 1，让第一次点击的时候，变成显示。
    self.passwordFlag = 1;
    //  2、手势
    _forgetPSMainView.passwordDisplayOrHideImgView.userInteractionEnabled = YES;
    [_forgetPSMainView.passwordDisplayOrHideImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(passwordDisplayOrHideImgViewClick)]];
    
    // 直接登录button：点击事件
    [_forgetPSMainView.directLoginBtn addTarget:self action:@selector(directLoginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.view = _forgetPSMainView;
}


// 直接登录button：点击事件
- (void)directLoginBtnClick{
    NSLog(@"点击直接登录button：点击事件");
    
    BOOL isTelAndVerifiAndPsw = [self checkTel:self.forgetPSMainView.cellNumTF.text andVerificationCode:self.forgetPSMainView.verificationTF.text andPassword:self.forgetPSMainView.passwordTF.text];
    
    if (isTelAndVerifiAndPsw) {
        
#warning 请求数据：提交用户名、密码、验证码，到后台，验证登录。
        // 2、用户名、密码、验证码，填写并且格式正确，提交信息到后台
        
        // 2.1、直接登录：请求数据
        [self directLoginRequest];
        
    }
    
}

// 直接登录：请求数据
- (void)directLoginRequest{
    
    
    // 拼接参数
    // 拼接参数
    NSDictionary *paramsResetPSW = @{
                             @"Account":self.forgetPSMainView.cellNumTF.text,
                             @"MobileCode":self.forgetPSMainView.verificationTF.text,
                             @"NewPassword":self.forgetPSMainView.passwordTF.text,
                             @"ConfirmPassword":self.forgetPSMainView.passwordTF.text
                             };
    
    NSDictionary *paramsLogin = @{
                             @"Account":self.forgetPSMainView.cellNumTF.text,
                             @"Password":self.forgetPSMainView.passwordTF.text
                             };
    
    
    
    // 忘记密码，先修改密码：网络请求
    [CYNetWorkManager postRequestWithUrl:cResetPSWUrl params:paramsResetPSW progress:^(NSProgress *uploadProgress) {
        NSLog(@"上传进度：%@",uploadProgress);
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"忘记密码：提交信息成功！");
        
        // 1、忘记密码：提交信息成功
        // 1.1、获取返回的信息：code值
        NSString *code = responseObject[@"code"];
        
        
        // 1.2、判断是否修改密码成功：根据返回的信息
        if ([code isEqualToString:@"0"]) {
            NSLog(@"忘记密码：修改成功！");
            
            // 1.2.1、忘记密码：修改密码成功，直接登录：请求数据
            // 直接登录：请求
            [CYNetWorkManager postRequestWithUrl:cLoginUrl params:paramsLogin progress:^(NSProgress *uploadProgress) {
                NSLog(@"上传进度：%@",uploadProgress);
            } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
                NSLog(@"直接登录：提交信息成功！");
                
                // 1.2.1.1、直接登录：提交信息成功
                // 1.2.1.1.1、获取code 值
                NSString *code = responseObject[@"code"];
                
                // 1.2.1.1.2、和成功的code 匹配
                if ([code isEqualToString:@"0"]) {
                    NSLog(@"直接登录：成功！");
                    
                    // 1.2.1.1.2.1、登录成功，
                    // 保存用户名、密码
                    [self setCurrentUserWithUserAccount:self.forgetPSMainView.cellNumTF.text andUserPSW:self.forgetPSMainView.passwordTF.text];
                    
                    // 1.2.1.1.2.1.1、设置当前登录的用户：ID、token。
                    [self setCurrentUser:responseObject];
                    
                    // 1.2.1.1.2.1.2、创建mainTabbar，设置为根视图控制器
                    [self loginSuccess];
                    
                    
                    
                    
                }
                else{
                    NSLog(@"直接登录：失败！");
                    
                    // 1.2.1.1.2.2、登录失败：弹窗提示：登录失败的返回信息
                    [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
                    
                }
            } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"直接登录：提交信息失败！");
                NSLog(@"error：%@",error);
                
                // 1.2.1.2、直接登录：提交信息失败：弹窗
                [self showHubWithLabelText:@"登录失败，可能是网络有问题，请检查网络再试一遍!" andHidAfterDelay:3.0];
            } withToken:nil];
            
        }
        else {
            NSLog(@"忘记密码：修改失败！");
            
            // 1.2.2、忘记密码：修改密码失败：失败原因
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"忘记密码：提交信息失败！");
        NSLog(@"失败日志，error：%@",error);
        
        // 2、忘记密码：提交信息失败：弹窗
        [self showHubWithLabelText:@"登录失败，可能是网络有问题，请检查网络再试一遍!" andHidAfterDelay:3.0];
        
        
    } withToken:nil];
    
    
}

// 密码显示隐藏：点击事件
- (void)passwordDisplayOrHideImgViewClick{
    NSLog(@"密码显示隐藏：点击事件");
    
    [self passwordDisplayOrHideImgViewClickWithImgView:_forgetPSMainView.passwordDisplayOrHideImgView andTexeField:_forgetPSMainView.passwordTF];
    
    
}

// 发送验证码button：点击事件
- (void)sendVerificationBtnClick{
    NSLog(@"发送验证码button：点击事件");
    
    // 1、先判断手机号是否填写、格式是否正确
    BOOL isTel = [self checkTel:self.forgetPSMainView.cellNumTF.text];
    
    if (isTel) {
        
        // 2、手机号已填写，并且格式正确，则发送验证码。
        
        // 2.1、发送验证码：SMSSDK第三方
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.forgetPSMainView.cellNumTF.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
            
            if (!error) {
                
                // 2.1.1、发送成功，等待用户收到，并填写
                NSLog(@"获取验证码成功！");
            }
            else{
                
                // 2.1.2、发送失败，
                NSLog(@"获取验证码失败，错误信息：error：%@",error);
            }
            
        }];
        
        
        // 2.2、发送验证码button：改变状态，开始倒计时。
        //  倒计时初始为60
        self.repeatSendVerifiTime = 60;
        NSString *str = [NSString stringWithFormat:@"%ldS 后重发",self.repeatSendVerifiTime];
        _forgetPSMainView.sendVerificationBtn.enabled = NO;
        //            _forgetPSMainView.sendVerificationBtn.backgroundColor = [UIColor lightGrayColor];
        [_forgetPSMainView.sendVerificationBtn setBackgroundImage:[UIImage imageNamed:@"验证码"] forState:UIControlStateDisabled];
        [_forgetPSMainView.sendVerificationBtn setTitle:str forState:UIControlStateDisabled];
        
        // 设置验证码button定时器
        [self setRepeatBtnTimer];
        
    }
    
    
}

// 设置验证码button定时器
- (void)setRepeatBtnTimer{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(repeatBtnTimerCountdown) userInfo:nil repeats:YES];
}

// 验证码button定时器：执行的方法
- (void)repeatBtnTimerCountdown{
    
    NSString *repeatBtnTitle = [NSString stringWithFormat:@"%ldS 后重发",self.repeatSendVerifiTime - 1];
    
    [self timerCountdownWithRepeatBtn:_forgetPSMainView.sendVerificationBtn andCountdownTime:1 andBtnDisabledTitle:repeatBtnTitle andNormalTitle:@"发送验证码"];
    
    
}



@end
