//
//  ZCYSwipeViewController.h
//  ZCYWangYi
//
//  Created by dgp on 16/6/14.
//  Copyright © 2016年 ZCY. All rights reserved.
//


#import "CYBaseViewController.h"

@interface ZCYSwipeViewController : CYBaseViewController


// 横向滚动的视图
@property (nonatomic, strong) UIScrollView *bgScrollView;

// 保存子视图控制器以及标题
- (instancetype)initWithSubVC:(NSArray *)subVCArr andTitles:(NSArray *)titlesArr;

// 设置scrollView 的 frame
- (void)setScrollViewFrame;

@end
