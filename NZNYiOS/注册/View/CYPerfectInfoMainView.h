//
//  CYPerfectInfoMainView.h
//  NZNYiOS
//
//  Created by 男左女右 on 16/9/17.
//  Copyright © 2016年 NZNY. All rights reserved.
//

#import <UIKit/UIKit.h>

// 模型
#import "CYPerfectInfoModel.h"


@interface CYPerfectInfoMainView : UIView

// 模型
@property (strong,nonatomic)CYPerfectInfoModel *perfectInfoM;

// 头像imageView
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;

// 提示上传头像label
@property (weak, nonatomic) IBOutlet UILabel *promptUploadLab;

// 姓名textField
@property (weak, nonatomic) IBOutlet UITextField *nameTF;

// 提示姓名长度label
@property (weak, nonatomic) IBOutlet UILabel *promptNameFormatLab;

// 提示姓名好处label
@property (weak, nonatomic) IBOutlet UILabel *promptNameBenefitLab;

// 男士头像
@property (weak, nonatomic) IBOutlet UIImageView *manImgView;

// 提示男士label
@property (weak, nonatomic) IBOutlet UILabel *promptManLabel;

// 女士头像
@property (weak, nonatomic) IBOutlet UIImageView *ladyImgView;

// 提示女士label
@property (weak, nonatomic) IBOutlet UILabel *promptLadyLab;

// 完成button
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

@end
