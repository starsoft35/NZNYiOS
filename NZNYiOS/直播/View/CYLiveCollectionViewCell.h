//
//  CYLiveCollectionViewCell.h
//  nzny
//
//  Created by 男左女右 on 2016/11/19.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>

// 模型
#import "CYLiveCollectionViewCellModel.h"


@interface CYLiveCollectionViewCell : UICollectionViewCell


// 模型
@property (nonatomic, strong) CYLiveCollectionViewCellModel *liveCellModel;


// 直播背景图：imageView
@property (weak, nonatomic) IBOutlet UIImageView *liveBgImgView;


// 直播状态背景图：imageView
@property (weak, nonatomic) IBOutlet UIImageView *liveStatusBgImgView;

// 直播状态title：label
@property (weak, nonatomic) IBOutlet UILabel *liveStatusTitleLab;

// 直播时间或观看人数：label
@property (weak, nonatomic) IBOutlet UILabel *liveTimeOrWatchNumLab;

// 性别：imageView
@property (weak, nonatomic) IBOutlet UIImageView *liveGenderImgView;

// 姓名：label
@property (weak, nonatomic) IBOutlet UILabel *liveNameLab;


// 联系TA：button
@property (weak, nonatomic) IBOutlet UIButton *liveContactBtn;

// 直播标题：label
@property (weak, nonatomic) IBOutlet UILabel *liveTitleLab;


@end
