//
//  CYTitleAndDetailCell.h
//  nzny
//
//  Created by 男左女右 on 2016/10/20.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>


// 模型
#import "CYTitleAndDetailModel.h"


@interface CYTitleAndDetailCell : UITableViewCell


// 模型
@property (nonatomic,strong) CYTitleAndDetailModel *titleAndDetailModel;


// title:Label
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

// detail:label
@property (weak, nonatomic) IBOutlet UILabel *detailLab;


// nextImgView
@property (weak, nonatomic) IBOutlet UIImageView *nextImgView;



@end
