//
//  CYPhoneCertifiVC.m
//  nzny
//
//  Created by 男左女右 on 2016/10/24.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYPhoneCertifiVC.h"

// 手机认证View
#import "CYPhoneCertifiView.h"



@interface CYPhoneCertifiVC ()


// 手机认证View
@property (nonatomic,strong) CYPhoneCertifiView *phoneCertifiView;


@end

@implementation CYPhoneCertifiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"手机认证";
    
    // 创建手机认证视图
    [self setPhoneCertifiView];
    
    
}



// 创建手机认证视图
- (void)setPhoneCertifiView{
    
    _phoneCertifiView = [[[NSBundle mainBundle] loadNibNamed:@"CYPhoneCertifiView" owner:nil options:nil] lastObject];
    
    
    // 发送验证码button：点击事件
    [_phoneCertifiView.verificationBtn addTarget:self action:@selector(verificationBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    // 立即认证button：点击事件
    [_phoneCertifiView.immediateVerifiBtn addTarget:self action:@selector(immediateVerifiBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    self.view = _phoneCertifiView;
    
}

// 发送验证码button：点击事件
- (void)verificationBtnClick{
    NSLog(@"发送验证码button：点击事件(在VC里面的)");
    
    
    // 1、先判断手机号是否填写、格式是否正确
    BOOL isPhone = [self checkTel:_phoneCertifiView.phoneTF.text];
    
    // 是的话发送验证码
    if (isPhone) {
        
        // 2.1、发送验证码：SMSSDK第三方
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneCertifiView.phoneTF.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
            
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
        _phoneCertifiView.verificationBtn.enabled = NO;
        _phoneCertifiView.verificationBtn.backgroundColor = [UIColor lightGrayColor];
        [_phoneCertifiView.verificationBtn setTitle:str forState:UIControlStateDisabled];
        
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
    
    [self timerCountdownWithRepeatBtn:_phoneCertifiView.verificationBtn andCountdownTime:1 andBtnDisabledTitle:repeatBtnTitle andNormalTitle:@"发送验证码"];
    
    
}




// 立即认证button：点击事件
- (void)immediateVerifiBtnClick{
    NSLog(@"立即认证button：点击事件(在VC里面的)");
    
    // 1、手机号是否填写、格式是否正确
    BOOL isPhone = [self checkTel:_phoneCertifiView.phoneTF.text];
    
    // 1.1、手机号已填写、并且格式正确
    if (isPhone) {
        
        
        
        // 2.2、验证码没有填写
        if ([_phoneCertifiView.verificationTF.text isEqualToString:@""]) {
            
            [self showHubWithLabelText:@"请输入验证码" andHidAfterDelay:3.0];
            
            
        }
        else {
            // 2、1、验证码格式是否正确
            BOOL isVerifi = [CYUtilities checkVerificationCode:_phoneCertifiView.verificationTF.text];
            
            if (!isVerifi) {
                
                [self showHubWithLabelText:@"请输入4位数字的验证码" andHidAfterDelay:3.0];
            }
            else {
                // 手机号、验证码都已填写，并且格式正确
                
                // 网络请求：验证手机号
                [self requestCertifiPhone];
                
            }
            
        }
        
    }
    
}


// 网络请求：验证手机号
- (void)requestCertifiPhone{
    
    // 网络请求：手机号认证
    // 参数
    NSDictionary *params = @{
                             @"UserId":self.onlyUser.userID,
                             @"Mobile":_phoneCertifiView.phoneTF.text,
                             @"MobileCode":_phoneCertifiView.verificationTF.text
                             };
    
    // 加载
    [self showLoadingView];
    
    // 网络请求：
    [CYNetWorkManager postRequestWithUrl:cVerifyPhoneUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"验证手机号：进度：%@",uploadProgress);
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"验证手机号：请求：成功！");
        // 2.3.1.1、获取code 值
        NSString *code = responseObject[@"code"];
        
        // 2.3.1.2、判断返回值
        if ([code isEqualToString:@"0"]) {
            NSLog(@"验证手机号：验证成功！");
            
            
            // 保存用户手机号
            [self setCurrentUserWithUserAccount:_phoneCertifiView.phoneTF.text andUserPSW:nil];
            
            
            // 验证手机号成功，加载菊花消失
            [self hidenLoadingView];
            
//            // 设置当前验证的手机号
            [self setCurrentUserWithUserAccount:_phoneCertifiView.phoneTF.text andUserPSW:nil];
            
            // 跳转回后面的视图
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else{
            NSLog(@"验证手机号：验证失败！");
            NSLog(@"msg:%@",responseObject[@"res"][@"msg"]);
            
            // 验证手机号失败，加载菊花消失
//            [self hidenLoadingView];
            
            // 2.3.1.2.2、验证手机号失败，弹窗
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"验证手机号：请求：失败！");
        NSLog(@"error:%@",error);
        
        // 验证手机号：请求：失败，加载菊花消失
        [self hidenLoadingView];
        
        // 2.3.1.2.2、验证手机号失败，弹窗
        [self showHubWithLabelText:@"网络错误，请重新认证！" andHidAfterDelay:3.0];
        
        
        
    } withToken:nil];
    
    
}


@end
