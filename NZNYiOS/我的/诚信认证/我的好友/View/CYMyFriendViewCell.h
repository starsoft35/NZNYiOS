//
//  CYMyFriendViewCell.h
//  nzny
//
//  Created by 男左女右 on 2016/11/9.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>

// 模型
#import "CYMyFriendViewCellModel.h"


@interface CYMyFriendViewCell : UITableViewCell


// 模型
@property (nonatomic, strong) CYMyFriendViewCellModel *myFriendViewCellModel;

// 头像：imageView
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;


// 姓名：label
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

// 性别：imageView
@property (weak, nonatomic) IBOutlet UIImageView *genderImgView;


// 年龄：label
@property (weak, nonatomic) IBOutlet UILabel *ageLab;

// 宣言：label
@property (weak, nonatomic) IBOutlet UILabel *declarationLab;


// 置顶
@property (weak, nonatomic) IBOutlet UILabel *topLab;



@end
