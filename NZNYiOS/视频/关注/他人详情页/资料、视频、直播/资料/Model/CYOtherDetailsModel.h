//
//  CYOtherDetailsModel.h
//  nzny
//
//  Created by 男左女右 on 2016/11/27.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYOtherDetailsModel : CYBaseModel


// 诚信等级
@property (nonatomic, assign) float CertificateLevel;

// FId
@property (nonatomic, assign) NSInteger FId;

// 学历
@property (nonatomic, copy) NSString *Education;

// 婚姻状况
@property (nonatomic, copy) NSString *Marriage;

// 城市
@property (nonatomic, copy) NSString *City;

// 爱情宣言
@property (nonatomic, copy) NSString *Declaration;


@end
