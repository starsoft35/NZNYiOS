//
//  CYServiceAskFeedBackVC.h
//  nzny
//
//  Created by 男左女右 on 2017/2/18.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYBaseViewController.h"

@interface CYServiceAskFeedBackVC : CYBaseViewController


// 反馈信息：TextView
@property (weak, nonatomic) IBOutlet UITextView *feedBackInfoTV;


// 剩余输入字数
@property (weak, nonatomic) IBOutlet UILabel *surplusCountLab;

// 最大输入字数
@property (weak, nonatomic) IBOutlet UILabel *maxCountLab;


// 提交
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;


@end
