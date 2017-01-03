//
//  CYInfoHeaderCell.h
//  nzny
//
//  Created by 男左女右 on 2016/10/20.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>


// 模型
#import "CYInfoHeaderCellModel.h"



@interface CYInfoHeaderCell : UITableViewCell


// 模型
@property (nonatomic,strong) CYInfoHeaderCellModel *infoHeaderCellModel;


// title：label
@property (weak, nonatomic) IBOutlet UILabel *titleLab;


// headImgView
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;


// nextImgView
@property (weak, nonatomic) IBOutlet UIImageView *nextImgView;



@end
