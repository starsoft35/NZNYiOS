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


// 搜索:VC
#import "CYSearchVC.h"


// 消息列表:VC
#import "CYChatListVC.h"


// 余额不足弹窗：VC
#import "CYBalanceNotEnoughVC.h"

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


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}



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
    
}


// 附近的人：右边，nearBarButtonItem：点击事件
- (void)nearRightBarBtnItemClick{
    NSLog(@"附近的人：BaseViewController:nearRightBarBtnItemClick：点击事件");
    
}

// 新消息：右边，newsBarButtonItem：点击事件
- (void)newsRightBarBtnItemClick{
    NSLog(@"新消息：BaseViewController:newsRightBarBtnItemClick：点击事件");

    
    // 初始化会话列表
    CYChatListVC *chatListVC = [[CYChatListVC alloc] init];
    
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
    
#warning 加载数据
    // 假数据
//    _dataArray = @[
//                   @[
//                       @{
//                           @"cellTitle" : @"头像",
//                           @"cellIcon" : @"test_user_icon"
//                           },
//                       @{
//                           @"cellTitle" : @"姓名",
//                           @"cellDetailTitle" : @"张大大"
//                           },
//                       @{
//                           @"cellTitle" : @"用户ID",
//                           @"cellDetailTitle" : @"20160815"
//                           },
//                       @{
//                           @"cellTitle" : @"性别",
//                           @"cellDetailTitle" : @"女"
//                           },
//                       @{
//                           @"cellTitle" : @"年龄",
//                           @"cellDetailTitle" : @"18"
//                           },
//                       @{
//                           @"cellTitle" : @"婚姻状况",
//                           @"cellDetailTitle" : @"未知"
//                           },
//                       @{
//                           @"cellTitle" : @"所在地区",
//                           @"cellDetailTitle" : @"上海"
//                           },
//                       
//                       
//                       ],
//                   @[
//                       @{
//                           @"cellTitle" : @"爱情宣言",
//                           @"cellDetailTitle" : @"守护一颗心"
//                           }
//                       ]
//                   ];
    
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
    
    NSLog(@"倒计时：%ld",self.repeatSendVerifiTime);
    
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
            
            // 创建mainTabbar，设置为根视图控制器
            [self loginSuccess];
            
            
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
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    
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
- (void)requestLikeWithUserId:(NSString *)userId andReceiveUserId:(NSString *)receiveUserId andGiftCount:(NSInteger)likeCount{
    NSLog(@"点赞：网络请求！");
    
    [self showLoadingView];
    
    // 参数
    NSDictionary *params = @{
                             @"UserId":userId,
                             @"ReceiveUserId":receiveUserId,
                             @"Count":@(likeCount)
                             };
    
    // 网络请求：点一个赞
    [CYNetWorkManager postRequestWithUrl:cAddUserLikeUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"点一个赞：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"点一个赞：请求成功！");
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"点一个赞：点赞成功！");
            NSLog(@"点一个赞：%@",responseObject);
            
            
            
            // 请求数据结束，取消加载
//            [self hidenLoadingView];
            
#warning 点赞成功，发送消息到聊天列表
            
            [self showHubWithLabelText:@"点赞成功！" andHidAfterDelay:3.0];
            
        }
        else{
            NSLog(@"点一个赞：点赞:responseObject:%@",responseObject);
            NSLog(@"点一个赞：点赞:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"点一个赞：请求失败！");
        NSLog(@"点一个赞：error：%@",error);
        
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
    
    // 网络请求：送一支玫瑰花
    [CYNetWorkManager postRequestWithUrl:cAddFlowersUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"送一支玫瑰花进度：%@",uploadProgress);
        
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"送一支玫瑰花：请求成功！");
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"送一支玫瑰花：送礼成功！");
            NSLog(@"送一支玫瑰花：%@",responseObject);
            
            
            
            // 请求数据结束，取消加载
//            [self hidenLoadingView];
            
            [self showHubWithLabelText:@"送礼成功！" andHidAfterDelay:3.0];
            
        }
        else{
            NSLog(@"送一支玫瑰花：送礼:responseObject:%@",responseObject);
            NSLog(@"送一支玫瑰花：送礼:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"送一支玫瑰花：请求失败！");
        NSLog(@"失败原因：error：%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
    } withToken:self.onlyUser.userToken];
    
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

@end
