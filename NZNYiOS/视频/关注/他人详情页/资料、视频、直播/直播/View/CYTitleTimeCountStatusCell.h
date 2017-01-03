//
//  CYTitleTimeCountStatusCell.h
//  nzny
//
//  Created by 男左女右 on 2016/12/13.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>

// 模型
#import "CYOtherLiveCellModel.h"

@interface CYTitleTimeCountStatusCell : UITableViewCell

// 模型
@property (nonatomic, strong) CYOtherLiveCellModel *liveCellModel;

// 标题
@property (weak, nonatomic) IBOutlet UILabel *titleLab;


// 直播时间
@property (weak, nonatomic) IBOutlet UILabel *liveStartTimeLab;

// 观看人数
@property (weak, nonatomic) IBOutlet UILabel *liveWatchCountLab;


// 直播状态
@property (weak, nonatomic) IBOutlet UILabel *liveStatusLab;


// 下一页背景图
@property (weak, nonatomic) IBOutlet UIImageView *nextPageImgView;



@end
