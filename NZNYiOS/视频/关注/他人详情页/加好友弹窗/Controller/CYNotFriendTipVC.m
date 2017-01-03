//
//  CYNotFriendTipVC.m
//  nzny
//
//  Created by 男左女右 on 2016/11/26.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYNotFriendTipVC.h"

// 不是好友弹窗View
#import "CYNotFriendTipView.h"

// 加好友VC
#import "CYAddFriendVC.h"



@interface CYNotFriendTipVC ()

@end

@implementation CYNotFriendTipVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 添加视图
    [self addView];
    
    
}

// 添加视图
- (void)addView{
    
    
    CYNotFriendTipView *notFriendTipView = [[[NSBundle mainBundle] loadNibNamed:@"CYNotFriendTipView" owner:nil options:nil] lastObject];
    
    
    // 弹窗关闭：点击事件
    [notFriendTipView.tipCloseBtn addTarget:self action:@selector(tipCloseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 送玫瑰花：点击事件
    [notFriendTipView.giveRoseBtn addTarget:self action:@selector(giveRoseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.view = notFriendTipView;
    
}


// 弹窗关闭：点击事件
- (void)tipCloseBtnClick{
    NSLog(@"弹窗关闭：点击事件");
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


// 送玫瑰花：点击事件
- (void)giveRoseBtnClick{
    NSLog(@"送玫瑰花：点击事件");
    
    CYAddFriendVC *addFriendVC = [[CYAddFriendVC alloc] init];
    
    addFriendVC.OppUserId = self.OppUserId;
    
    
    [self presentViewController:addFriendVC animated:YES completion:nil];
    
    
}


@end
