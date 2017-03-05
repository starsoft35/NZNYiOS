//
//  CYActiveEnrollConditionTipView.h
//  nzny
//
//  Created by 男左女右 on 2017/3/5.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYActiveEnrollConditionTipView : UIView


// 弹窗关闭：button
@property (weak, nonatomic) IBOutlet UIButton *tipCloseBtn;



// 活动费用：label
@property (weak, nonatomic) IBOutlet UILabel *activeFeeLab;



// 确认报名：button
@property (weak, nonatomic) IBOutlet UIButton *confirmEnrollBtn;



@end
