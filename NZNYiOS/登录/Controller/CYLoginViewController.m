//
//  CYLoginViewController.m
//  NZNYiOS
//
//  Created by 男左女右 on 16/9/4.
//  Copyright © 2016年 NZNY. All rights reserved.
//

#import "CYLoginViewController.h"

// 登录视图View
#import "CYLoginMainView.h"


// 主视图VC
#import "CYMainTabBarController.h"

// 注册界面VC
#import "CYRegisterViewController.h"

// 完善信息VC
#import "CYPerfectInfoViewController.h"


// 忘记密码VC
#import "CYForgetPSViewController.h"


// 先逛一逛VC


// 微信登录VC



// 加载弹窗VC
#import "MBProgressHUD.h"

// 根视图控制器代理
#import "AppDelegate.h"



@interface CYLoginViewController ()// <UIApplicationDelegate,WXApiDelegate>



//
@property (nonatomic,strong)CYLoginMainView *loginView;

//// 密码flag
//@property (nonatomic,assign)int passwordFlag;

@end

@implementation CYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.view.backgroundColor = [UIColor cyanColor];
    
    self.title = @"登录";
    
    // 设置登录视图
    [self setLoginMainV];
    
//    [WXApi registerApp:cWXAppID];
    
}

// 界面要显示的时候，隐藏navigationBar
- (void)viewWillAppear:(BOOL)animated{
    
    // navigationBar隐藏（在这里设置是因为，下一级给显示了，从下一级返回来时，依然会显示）
    self.navigationController.navigationBarHidden = YES;
    
}

// 设置登录视图
- (void)setLoginMainV{
    
    _loginView.frame = CGRectMake(0, 0, cScreen_Width, cScreen_Height);
    
    // 加载XIB
    _loginView = [[[NSBundle mainBundle]loadNibNamed:@"CYLoginMainView" owner:nil options:nil]lastObject];
    
    
    // 先逛一逛:点击事件
    [_loginView.firstGoBtn addTarget:self action:@selector(firstGoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 登录:点击事件
    [_loginView.loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 密码显示隐藏：点击事件
    //  1、最开始，密码为隐藏，设置flag = 1，让第一次点击的时候，变成显示。
    self.passwordFlag = 1;
    //  2、手势
    _loginView.passwordDisplayOrHideImgView.userInteractionEnabled = YES;
    [_loginView.passwordDisplayOrHideImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(passwordDisplayOrHideImgViewClick)]];
    
    // 注册:点击事件
    [_loginView.registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 忘记密码:点击事件
    [_loginView.forgetPSBtn addTarget:self action:@selector(forgetPSBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 微信登录：点击事件
    
    BOOL isWeChatDown = [WXApi isWXAppInstalled];
    // 判断是否已经有微信，并已登录
    if (isWeChatDown == YES) {

        _loginView.weChatLoginBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    
        _loginView.weChatLoginMainView.userInteractionEnabled = YES;
        [_loginView.weChatLoginMainView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weChatLoginBtnClick)]];

    }
    else {
        
        _loginView.weChatLoginMainView.hidden = YES;
    }
    
    
    self.view = _loginView;
    NSLog(@"视图已经创建好了哟~~");
}


// 密码显示隐藏：点击事件
- (void)passwordDisplayOrHideImgViewClick{
    NSLog(@"密码显示隐藏：点击事件");
    
    
    [self passwordDisplayOrHideImgViewClickWithImgView:_loginView.passwordDisplayOrHideImgView andTexeField:_loginView.passwordTF];
    
    
}

// 先逛一逛button点击事件
- (void)firstGoBtnClick{
    NSLog(@"点击先逛一逛button~");
    
#warning 请求数据：接口，先逛一逛。
    [self loginSuccess];
    
    
    
    // 请求固定接口（这个容易请求），浏览部分信息（这个要做不同的界面）。
    
//    [self dismissViewControllerAnimated:nil completion:nil];
    
//    CYMainTabBarController *mainTBV = [[CYMainTabBarController alloc] init];
//    
//    [self presentViewController:self.parentViewController animated:nil completion:nil];
    
//    [self showViewController:self.parentViewController sender:nil];
    
//    [self showDetailViewController:self.parentViewController sender:nil];
//    [self presentViewController:self.parentViewController animated:nil completion:nil];
    
}

// 登录button 点击事件
- (void)loginBtnClick{
    
    // 填写用户名、密码，提交到后台验证，后台返回信息，通过就显示主界面，不通过就弹框提示。
    
    // 1、先判断用户名、密码的是否填写，格式是否正确
    BOOL isTelAndPassword = [self checkTel:_loginView.cellNumTF.text andPassword:_loginView.passwordTF.text];
    
    if (isTelAndPassword) {
        NSLog(@"用户名、密码填写并且格式正确!");
        
        // 2、用户名、密码填写并且格式正确，提交信息到后台
        
        // 2.1、登录：请求数据       
        [self loginRequestWithAccount:self.loginView.cellNumTF.text andUserPSW:self.loginView.passwordTF.text];
        
    }
    
    
}



// 注册button 点击事件
- (void)registerBtnClick{
    
    // 注册界面
    CYRegisterViewController *registerVC = [[CYRegisterViewController alloc] init];
    
    
    UINavigationController *registerNav = [CYUtilities createDefaultNavCWithRootVC:registerVC BgColor:nil TintColor:[UIColor whiteColor] translucent:NO titleColor:[UIColor whiteColor] title:@"注册" bgImg:[UIImage imageNamed:@"Title1"]];
    
    
    
//    registerNav.navigationBarHidden = YES;
//    registerNav.navigationBar.translucent = NO;
    
    [self presentViewController:registerNav animated:nil completion:nil];
    
}

// 忘记密码button 点击事件
- (void)forgetPSBtnClick{
    NSLog(@"忘记密码button：点击事件");
    
    
    // 忘记密码界面
    CYForgetPSViewController *forgetPSVC = [[CYForgetPSViewController alloc] init];
    
    self.navigationController.navigationBarHidden = NO;
    
    
    
    [self.navigationController pushViewController:forgetPSVC animated:nil];
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    
    // 向微信注册
//    [WXApi registerApp:cWXAppID];
    
    return YES;
    
}

// 微信登录button 点击事件
- (void)weChatLoginBtnClick{
    NSLog(@"微信登录button：点击事件");
    
//    [WXApi registerApp:cWXAppID];
    
    // 授权登录：构造SendAuthReq结构体
    SendAuthReq *req = [[SendAuthReq alloc] init];
    
    req.scope = cWXScope;
    req.state = cWXState;
    
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
    
    
}

- (void)onResp:(BaseResp *)resp{
    
}




@end
