//
//  CYPerfectInfoModel.h
//  NZNYiOS
//
//  Created by 男左女右 on 16/9/18.
//  Copyright © 2016年 NZNY. All rights reserved.
//

#import "JSONModel.h"

@interface CYPerfectInfoModel : JSONModel

// 头像imageView
@property (weak, nonatomic)NSString *headImgView;

// 提示上传头像label
@property (weak, nonatomic)NSString *promptUploadLab;

// 姓名textField
@property (weak, nonatomic)NSString *nameTF;

// 提示姓名长度label
@property (weak, nonatomic)NSString *promptNameFormatLab;

// 提示姓名好处label
@property (weak, nonatomic)NSString *promptNameBenefitLab;

// 男士头像
@property (weak, nonatomic)NSString *manHeadImgView;

// 提示男士label
@property (weak, nonatomic)NSString *promptManLabel;

// 女士头像
@property (weak, nonatomic)NSString *ladyImgView;

// 提示女士label
@property (weak, nonatomic)NSString *promptLadyLab;

// 完成button
@property (weak, nonatomic)NSString *finishBtn;


@end
