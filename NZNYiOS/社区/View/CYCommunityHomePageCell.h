//
//  CYCommunityHomePageCell.h
//  nzny
//
//  Created by 男左女右 on 2017/1/15.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>

// 模型
#import "CYCommunityHomePageCellModel.h"


@interface CYCommunityHomePageCell : UITableViewCell



// 头像
@property (nonatomic,strong) CYCommunityHomePageCellModel *communityHomePageCellModel;

// 导航图片
@property (weak, nonatomic) IBOutlet UIImageView *navigationPictureImgView;

// 所属类别
@property (weak, nonatomic) IBOutlet UILabel *categoryLab;

// 标题
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

// 简介
@property (weak, nonatomic) IBOutlet UILabel *summaryLab;


// 发布时间
@property (weak, nonatomic) IBOutlet UILabel *releaseTimeLab;














@end
