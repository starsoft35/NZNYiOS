//
//  CYMyUserInfoLocationVC.h
//  nzny
//
//  Created by 男左女右 on 2017/1/5.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYBaseViewController.h"


typedef void(^MyBlock)(NSString *address,NSArray *selections);


@interface CYMyUserInfoLocationVC : CYBaseViewController


// 地址：label
@property (weak, nonatomic) IBOutlet UILabel *locationLab;

// 使用当前位置：点击事件
- (IBAction)useCurrentLocationBtnClick:(id)sender;


@property (nonatomic,strong) NSArray *selections; //!< 选择的三个下标
@property (nonatomic,copy) MyBlock myBlock; //!< 回调地址的block

@end
