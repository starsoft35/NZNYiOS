//
//  CYForgetPSModel.h
//  NZNYiOS
//
//  Created by 男左女右 on 16/9/18.
//  Copyright © 2016年 NZNY. All rights reserved.
//

#import "JSONModel.h"

@interface CYForgetPSModel : JSONModel


// 区号Label
@property (weak, nonatomic)NSString *areaNumLab;

// 手机号textField
@property (weak, nonatomic)NSString *cellNumTF;

// 验证码textField
@property (weak, nonatomic)NSString *verificationTF;

// 倒计时重发button
@property (weak, nonatomic) IBOutlet UIButton *repeatBtn;

// 密码textField
@property (weak, nonatomic)NSString *passwordTF;

// 密码显示或隐藏imageView
@property (weak, nonatomic)NSString *passwordDisplayOrHideImgView;

// 提示密码格式label
@property (weak, nonatomic)NSString *promptPSFormatLab;

// 直接登录button
@property (weak, nonatomic) IBOutlet UIButton *directLoginBtn;


@end
