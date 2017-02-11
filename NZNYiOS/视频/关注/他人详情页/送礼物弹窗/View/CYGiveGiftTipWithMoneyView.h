//
//  CYGiveGiftTipWithMoneyView.h
//  nzny
//
//  Created by 男左女右 on 2017/2/8.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CYBaseViewController.h"


@interface CYGiveGiftTipWithMoneyView : UIView

// 弹窗关闭：button
@property (weak, nonatomic) IBOutlet UIButton *tipCloseBtn;


// 一支玫瑰花：button
@property (weak, nonatomic) IBOutlet UIButton *oneRoseBtn;

// 3支玫瑰花：button
@property (weak, nonatomic) IBOutlet UIButton *threeRoseBtn;
// 9支玫瑰花：button
@property (weak, nonatomic) IBOutlet UIButton *nineRoseBtn;

// 99支玫瑰花：button
@property (weak, nonatomic) IBOutlet UIButton *ninetyNineRoseBtn;



// 玫瑰数量：textField
@property (weak, nonatomic) IBOutlet UITextField *giftCountTextField;

// 输入的玫瑰数量的价格：label
@property (weak, nonatomic) IBOutlet UILabel *tfRoseCountCostLab;


// 送礼：button
@property (weak, nonatomic) IBOutlet UIButton *giveGiftBtn;


// 送礼文本的主视图
@property (weak, nonatomic) IBOutlet UIView *allTextMainView;




@end
