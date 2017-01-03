//
//  CYMyLiveSignUpView.h
//  nzny
//
//  Created by 男左女右 on 2016/12/11.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYMyLiveSignUpView : UIView


// 姓名：label
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

// 手机号：textField
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;

// 直播标题：textField
@property (weak, nonatomic) IBOutlet UITextField *liveTitleTF;


// 我要上直播：button
@property (weak, nonatomic) IBOutlet UIButton *gotoLiveBtn;



@end
