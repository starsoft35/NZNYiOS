 //
//  CYRegisterMainView.h
//  NZNYiOS
//
//  Created by 男左女右 on 16/9/14.
//  Copyright © 2016年 NZNY. All rights reserved.
//

#import <UIKit/UIKit.h>

// 模型
#import "CYRegisterModel.h"


@interface CYRegisterMainView : UIView

// 模型
@property (strong,nonatomic)CYRegisterModel *registerM;

// 区号label
@property (weak, nonatomic) IBOutlet UILabel *areaNumLab;

// 手机号textField
@property (weak, nonatomic) IBOutlet UITextField *cellNumTF;

// 验证码textField
@property (weak, nonatomic) IBOutlet UITextField *verificationTF;

// 发送验证码button
@property (weak, nonatomic) IBOutlet UIButton *sendVerificationBtn;

// 密码textField
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

// 密码显示或隐藏imageView
@property (weak, nonatomic) IBOutlet UIImageView *passwordDisplayOrHideImgView;

// 提示密码格式label
@property (weak, nonatomic) IBOutlet UILabel *promptPSFormatLab;

// 注册button
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

// 已有账号，去登录button
@property (weak, nonatomic) IBOutlet UIButton *goLoginBtn;

// 微信登录button
@property (weak, nonatomic) IBOutlet UIButton *WeChatLoginBtn;


// 用户注册协议
@property (weak, nonatomic) IBOutlet UILabel *userRegisterProtocolLab;





@end
