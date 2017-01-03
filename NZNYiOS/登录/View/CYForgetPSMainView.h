//
//  CYForgetPSMainView.h
//  NZNYiOS
//
//  Created by 男左女右 on 16/9/17.
//  Copyright © 2016年 NZNY. All rights reserved.
//

#import <UIKit/UIKit.h>

// 模型
#import "CYForgetPSModel.h"


@interface CYForgetPSMainView : UIView

// 模型
@property (strong,nonatomic)CYForgetPSModel *forgetPSM;

// 区号Label
@property (weak, nonatomic) IBOutlet UILabel *areaNumLab;

// 手机号textField
@property (weak, nonatomic) IBOutlet UITextField *cellNumTF;

// 验证码textField
@property (weak, nonatomic) IBOutlet UITextField *verificationTF;

// 发送验证码、倒计时重发button
@property (weak, nonatomic) IBOutlet UIButton *sendVerificationBtn;

// 密码textField
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

// 密码显示或隐藏imageView
@property (weak, nonatomic) IBOutlet UIImageView *passwordDisplayOrHideImgView;

// 提示密码格式label
@property (weak, nonatomic) IBOutlet UILabel *promptPSFormatLab;

// 直接登录button
@property (weak, nonatomic) IBOutlet UIButton *directLoginBtn;



@end
