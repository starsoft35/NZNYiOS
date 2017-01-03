//
//  CYSearchViewCell.h
//  nzny
//
//  Created by 男左女右 on 2016/11/20.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>

// 模型
#import "CYSearchViewCellModel.h"


@interface CYSearchViewCell : UITableViewCell


// 模型
@property (nonatomic, strong) CYSearchViewCellModel *searchModel;

// 头像：imageView
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;


// 姓名：label
@property (weak, nonatomic) IBOutlet UILabel *nameLab;


// 性别：imageView
@property (weak, nonatomic) IBOutlet UIImageView *genderImgView;


// 年龄：label
@property (weak, nonatomic) IBOutlet UILabel *ageLab;


// 诚信等级：星一：imageView
@property (weak, nonatomic) IBOutlet UIImageView *firStarImgView;


// 诚信等级：星二：imageView
@property (weak, nonatomic) IBOutlet UIImageView *secStarImgView;


// 诚信等级：星三：imageView
@property (weak, nonatomic) IBOutlet UIImageView *thirdStarImgView;


// 诚信等级：星四：imageView
@property (weak, nonatomic) IBOutlet UIImageView *fourthStarImgView;


// 诚信等级：星五：imageView
@property (weak, nonatomic) IBOutlet UIImageView *fifthStarImgView;


// 爱情宣言：label
@property (weak, nonatomic) IBOutlet UILabel *declarationLab;


// 加关注：button
@property (weak, nonatomic) IBOutlet UIButton *followBtn;



@end
