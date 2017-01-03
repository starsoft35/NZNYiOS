//
//  CYChatVC.m
//  nzny
//
//  Created by 男左女右 on 2016/11/16.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYChatVC.h"

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
    
    
}

@end
