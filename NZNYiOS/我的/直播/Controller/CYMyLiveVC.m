//
//  CYMyLiveVC.m
//  nzny
//
//  Created by 男左女右 on 2016/12/11.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYMyLiveVC.h"

// base滑动视图
#import "CYBaseSwipeViewController.h"


// 预告：VC
#import "CYMyLiveTrailerVC.h"

// 记录：VC
#import "CYMyLiveRecordVC.h"

// 直播报名：VC
#import "CYMyLiveSignUpVC.h"


@interface CYMyLiveVC ()

@end

@implementation CYMyLiveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // title
    self.title = @"直播";
    
//    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.00];
    
    
    
    // 添加视图
    [self addView];
    
    // 加载数据
//    [self loadData];
    
    
    
    //
}

// 添加视图
- (void)addView{
    
    
    _myLiveView = [[[NSBundle mainBundle] loadNibNamed:@"CYMyLiveView" owner:nil options:nil] lastObject];
    
    // 添加中部预告、记录视图
    CGFloat trailerRecordHeight = cScreen_Height - _myLiveView.gotoLiveBtn.frame.size.height - 76 - 20;
    // 预告：VC
    CYMyLiveTrailerVC *myLiveTrailerVC = [[CYMyLiveTrailerVC alloc] init];
    myLiveTrailerVC.view.frame = CGRectMake(0, 0, cScreen_Width, trailerRecordHeight);
    myLiveTrailerVC.baseCollectionView.frame = CGRectMake(0, 0, cScreen_Width, trailerRecordHeight);
    
    // 记录：VC
    CYMyLiveRecordVC *myLiveRecordVC = [[CYMyLiveRecordVC alloc] init];
    myLiveRecordVC.view.frame = CGRectMake(0, 0, cScreen_Width, trailerRecordHeight);
    myLiveRecordVC.baseTableView.frame = CGRectMake(0, 0, cScreen_Width, trailerRecordHeight);
    
    // 中部滑动视图
    CYBaseSwipeViewController *trailerRecordVC = [[CYBaseSwipeViewController alloc] initWithSubVC:@[myLiveTrailerVC,myLiveRecordVC] andTitles:@[@"预告",@"记录"]];
    trailerRecordVC.view.frame = CGRectMake(0, 0, cScreen_Width, trailerRecordHeight);
    trailerRecordVC.bgScrollView.frame = CGRectMake(0, (76.0 / 1334.0) * self.view.frame.size.height, cScreen_Width, trailerRecordHeight);
    
    _myLiveView.liveTrailerRecordView.frame = CGRectMake(0, 0, cScreen_Width, trailerRecordHeight);

    [_myLiveView.liveTrailerRecordView addSubview:trailerRecordVC.view];
    
    trailerRecordVC.bgScrollView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.00];
    
    // 我要上直播：点击事件
    [_myLiveView.gotoLiveBtn addTarget:self action:@selector(gotoLiveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.view addSubview:_myLiveView];
    self.view = _myLiveView;
}

// 我要上直播：点击事件
- (void)gotoLiveBtnClick{
    NSLog(@"我要上直播：点击事件");
    
    
    // 直播报名
    CYMyLiveSignUpVC *liveSignUpVC = [[CYMyLiveSignUpVC alloc] init];
    
    [self.navigationController pushViewController:liveSignUpVC animated:YES];
    
}


@end
