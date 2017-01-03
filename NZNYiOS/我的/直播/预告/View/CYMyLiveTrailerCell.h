//
//  CYMyLiveTrailerCell.h
//  nzny
//
//  Created by 男左女右 on 2016/12/14.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>

// 模型
#import "CYMyLiveTrailerCellModel.h"


@interface CYMyLiveTrailerCell : UICollectionViewCell


// 模型
@property (nonatomic, strong) CYMyLiveTrailerCellModel *myLiveTrailerCellModel;

// 我的：直播预告：背景：imageView
@property (weak, nonatomic) IBOutlet UIImageView *liveTrailerBgImgView;


// 直播状态：能否进入直播间：背景：imageView
@property (weak, nonatomic) IBOutlet UIImageView *liveStatusImgView;

// 直播状态：能否进入直播间：label
@property (weak, nonatomic) IBOutlet UILabel *liveStatusLab;


// 直播开始时间：label
@property (weak, nonatomic) IBOutlet UILabel *liveStartTimeLab;


// 分享：button
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

// 直播间标题：label
@property (weak, nonatomic) IBOutlet UILabel *titleLab;



@end
