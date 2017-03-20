//
//  CYMemberViewCell.h
//  nzny
//
//  Created by 男左女右 on 2017/3/16.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>


// 模型
#import "CYMemberViewCellModel.h"



@interface CYMemberViewCell : UITableViewCell


// 模型
@property (nonatomic, strong) CYMemberViewCellModel *memberViewCellModel;


// 头像：imageView
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;


// 姓名：label
@property (weak, nonatomic) IBOutlet UILabel *nameLab;


// 性别：imageView
@property (weak, nonatomic) IBOutlet UIImageView *genderImgView;


// 年龄
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



// 标签
@property (weak, nonatomic) IBOutlet UILabel *tagLab;





@end
