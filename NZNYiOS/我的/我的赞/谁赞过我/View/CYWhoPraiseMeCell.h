//
//  CYWhoPraiseMeCell.h
//  nzny
//
//  Created by 男左女右 on 2016/12/18.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>

// 模型
#import "CYWhoPraiseMeCellModel.h"


@interface CYWhoPraiseMeCell : UITableViewCell

// 模型
@property (nonatomic, strong) CYWhoPraiseMeCellModel *whoPraiseMeCellModel;

// 头像：imageView
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;

// 姓名：label
@property (weak, nonatomic) IBOutlet UILabel *nameLab;


// 性别：imageView
@property (weak, nonatomic) IBOutlet UIImageView *genderImgView;

// 年龄：label
@property (weak, nonatomic) IBOutlet UILabel *ageLab;


// 诚信等级：星一：imageView
@property (weak, nonatomic) IBOutlet UIImageView *firstStarImgView;

// 诚信等级：星二：imageView
@property (weak, nonatomic) IBOutlet UIImageView *secondStarImgView;

// 诚信等级：星三：imageView
@property (weak, nonatomic) IBOutlet UIImageView *thirdStarImgView;

// 诚信等级：星四：imageView
@property (weak, nonatomic) IBOutlet UIImageView *fourStarImgView;

// 诚信等级：星五：imageView
@property (weak, nonatomic) IBOutlet UIImageView *fiveStarImgView;


// 赞的图片：imageView
@property (weak, nonatomic) IBOutlet UIImageView *praiseImgView;


// 赞的数量:label
@property (weak, nonatomic) IBOutlet UILabel *praiseCountLab;


// 爱情宣言
@property (weak, nonatomic) IBOutlet UILabel *declarationLab;



@end
