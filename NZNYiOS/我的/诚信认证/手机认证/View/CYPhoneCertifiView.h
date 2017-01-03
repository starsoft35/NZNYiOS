//
//  CYPhoneCertifiView.h
//  nzny
//
//  Created by 男左女右 on 2016/10/24.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYPhoneCertifiView : UIView


// 手机号：textField
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;


// 验证码：textField
@property (weak, nonatomic) IBOutlet UITextField *verificationTF;

// 验证码：button
@property (weak, nonatomic) IBOutlet UIButton *verificationBtn;

// 立即认证：button
@property (weak, nonatomic) IBOutlet UIButton *immediateVerifiBtn;




@end
