//
//  CYCommunityHeaderView.h
//  nzny
//
//  Created by 张春咏 on 2017/1/14.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYCommunityHeaderView : UIView


// 线下活动：imageView
@property (weak, nonatomic) IBOutlet UIImageView *offlineActiveImgView;


// 往期回顾：imageView
@property (weak, nonatomic) IBOutlet UIImageView *pastReViewImgView;


// 客服问答：imageView
@property (weak, nonatomic) IBOutlet UIImageView *customQuestionImgView;


// 活动公告：view
@property (weak, nonatomic) IBOutlet UIView *activeNotiveView;


// 活动公告：轮播图：View
@property (weak, nonatomic) IBOutlet UIView *activeNoticeCarouselView;



@end
