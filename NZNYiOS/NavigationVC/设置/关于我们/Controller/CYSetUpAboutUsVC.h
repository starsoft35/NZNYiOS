//
//  CYSetUpAboutUsVC.h
//  nzny
//
//  Created by 男左女右 on 2017/1/7.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYBaseViewController.h"

// 模型
#import "CYSetUpAboutUsVCModel.h"


@interface CYSetUpAboutUsVC : CYBaseViewController


// 模型
@property (nonatomic, strong) CYSetUpAboutUsVCModel *setUpAboutUsVCModel;


// 子标题
@property (weak, nonatomic) IBOutlet UILabel *subTitleLab;


// 关于我们：label
@property (weak, nonatomic) IBOutlet UILabel *aboutUsLab;



@end
