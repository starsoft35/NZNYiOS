//
//  CYLikeTipWithMoneyView.h
//  nzny
//
//  Created by 男左女右 on 2017/2/8.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYLikeTipWithMoneyView : UIView


// 点赞背景


// likeTipMiddleView
@property (weak, nonatomic) IBOutlet UIView *likeTipMiddleView;


// 弹窗关闭：button
@property (weak, nonatomic) IBOutlet UIButton *tipCloseBtn;

// 一个赞：button
@property (weak, nonatomic) IBOutlet UIButton *oneLikeBtn;

// 10个赞：button
@property (weak, nonatomic) IBOutlet UIButton *tenLikeBtn;

// 32个赞：button
@property (weak, nonatomic) IBOutlet UIButton *thirtyTwoLikeBtn;

// 300个赞：button
@property (weak, nonatomic) IBOutlet UIButton *threeHundredLikeBtn;


// 点赞数量：textField
@property (weak, nonatomic) IBOutlet UITextField *likeCountTextField;

// 点赞：button
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;



@end
