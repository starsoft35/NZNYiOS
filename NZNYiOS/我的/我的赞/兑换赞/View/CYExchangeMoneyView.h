//
//  CYExchangeMoneyView.h
//  nzny
//
//  Created by 男左女右 on 2016/12/20.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYExchangeMoneyView : UIView

// 关闭：button
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;


// 取消兑换：button
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

// 确认兑换：button
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;


@end
