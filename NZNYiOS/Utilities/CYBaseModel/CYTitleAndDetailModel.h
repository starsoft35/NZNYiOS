//
//  CYTitleAndDetailModel.h
//  nzny
//
//  Created by 男左女右 on 2016/10/20.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYTitleAndDetailModel : CYBaseModel


// title:Label
@property (weak, nonatomic) NSString *title;

// detail:label
@property (weak, nonatomic) NSString *detail;


// nextImgView
@property (weak, nonatomic) NSString *nextImgName;


@end
