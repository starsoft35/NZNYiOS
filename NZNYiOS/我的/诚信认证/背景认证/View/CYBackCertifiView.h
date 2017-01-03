//
//  CYBackCertifiView.h
//  nzny
//
//  Created by 男左女右 on 2016/10/22.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>

// 模型
#import "CYBackCertifiViewModel.h"


@interface CYBackCertifiView : UIView


// 哪个imageView选择的相机
@property (nonatomic,copy) NSString *flag;

// 模型
//@property (nonatomic,strong)CYBackCertifiViewModel *backCertifiViewModel;


// 数组
@property (nonatomic, strong) NSMutableArray *listArr;

// 1、学历认证ImgView
@property (weak, nonatomic) IBOutlet UIImageView *educationImgView;


// 2、身份证ImgView
@property (weak, nonatomic) IBOutlet UIImageView *IDCardImgView;


// 3、工资条ImgView
@property (weak, nonatomic) IBOutlet UIImageView *wageImgView;


// 4、房产证ImgView
@property (weak, nonatomic) IBOutlet UIImageView *propertyImgView;


// 5、行驶证ImgView
@property (weak, nonatomic) IBOutlet UIImageView *driveImgView;


// 6、其他ImgView
@property (weak, nonatomic) IBOutlet UIImageView *otherImgView;


// 7、其他1ImgView
@property (weak, nonatomic) IBOutlet UIImageView *otherFirstImgView;


// 8、其他2ImgView
@property (weak, nonatomic) IBOutlet UIImageView *otherSecondImgView;



// 9、其他3ImgView
@property (weak, nonatomic) IBOutlet UIImageView *otherThirdImgView;




@end
