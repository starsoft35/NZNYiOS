//
//  CYMineMainTableViewCell.h
//  nzny
//
//  Created by 男左女右 on 16/10/8.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>

// 模型
#import "CYMineMainCellModel.h"


@interface CYMineMainTableViewCell : UITableViewCell

// 模型
@property (nonatomic,strong)CYMineMainCellModel *mineMainCellModel;


// 标题：cell的前面的文本
@property (weak, nonatomic) IBOutlet UILabel *mineCellTitleLab;

// 星级：视图：有五个imageView 子视图
@property (weak, nonatomic) IBOutlet UIView *creditRatingView;

// 星一：imageView
@property (weak, nonatomic) IBOutlet UIImageView *firstStarImgView;

// 星二：imageView
@property (weak, nonatomic) IBOutlet UIImageView *secStarImgView;


// 星三：imageView
@property (weak, nonatomic) IBOutlet UIImageView *thirdImgView;

// 星四：imageView
@property (weak, nonatomic) IBOutlet UIImageView *fourStarImgView;

// 星五：imageView
@property (weak, nonatomic) IBOutlet UIImageView *fiveImgView;



// 信息：cell的中间文本
@property (weak, nonatomic) IBOutlet UILabel *mineCellInfoLab;

// 下一页：imageView
@property (weak, nonatomic) IBOutlet UIImageView *nextImgView;


@end
