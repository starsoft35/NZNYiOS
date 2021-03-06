//
//  CYChatVC.m
//  nzny
//
//  Created by 男左女右 on 2016/11/16.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYChatVC.h"


// 他人详情页
#import "CYOthersInfoVC.h"



@interface CYChatVC ()

@end

@implementation CYChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.hidesBottomBarWhenPushed = YES;
}


// 点击Cell中头像的回调
- (void)didTapCellPortrait:(NSString *)userId{
    NSLog(@"点击了userId：%@ 的头像，进入他的个人详情页",userId);
    
    // 他人详情页
    CYOthersInfoVC *othersInfoVC = [[CYOthersInfoVC alloc] init];
    
    //    othersInfoVC.view.frame = CGRectMake(0, 0, 400, 400);
    
    othersInfoVC.oppUserId = userId;
    
    othersInfoVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:othersInfoVC animated:YES];
    
}

@end
