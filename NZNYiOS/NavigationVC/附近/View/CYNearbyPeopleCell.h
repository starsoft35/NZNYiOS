//
//  CYNearbyPeopleCell.h
//  nzny
//
//  Created by 张春咏 on 2017/1/6.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>


// 模型
#import "CYNearbyPeopleCellModel.h"



@interface CYNearbyPeopleCell : UITableViewCell


// 模型
@property (nonatomic,strong) CYNearbyPeopleCellModel *nearbyPeopleCellModel;

// 头像：imageView
@property (weak, nonatomic) IBOutlet UIImageView *headerImgView;


// 姓名：label
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

// 性别：imageView
@property (weak, nonatomic) IBOutlet UIImageView *genderImgView;

// 年龄：label
@property (weak, nonatomic) IBOutlet UILabel *ageLab;


// 距离：label
@property (weak, nonatomic) IBOutlet UILabel *distanceLab;

// 爱情宣言：label
@property (weak, nonatomic) IBOutlet UILabel *declarationLab;


@end
