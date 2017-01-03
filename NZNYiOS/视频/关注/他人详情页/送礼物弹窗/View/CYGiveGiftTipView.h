//
//  CYGiveGiftTipView.h
//  nzny
//
//  Created by 男左女右 on 2016/11/23.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYGiveGiftTipView : UIView


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


// 999支玫瑰花：button
@property (weak, nonatomic) IBOutlet UIButton *ninehundredNitetyNineRoseBtn;



// 玫瑰数量：textField
@property (weak, nonatomic) IBOutlet UITextField *giftCountTextField;


// 送礼：button
@property (weak, nonatomic) IBOutlet UIButton *giveGiftBtn;



@end
