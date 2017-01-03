//
//  CYInfoHeaderCellModel.h
//  nzny
//
//  Created by 男左女右 on 2016/10/20.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYInfoHeaderCellModel : CYBaseModel


// title：label
@property (weak, nonatomic) NSString *title;


// headImgView
@property (weak, nonatomic) NSString *headImgName;


// nextImgView
@property (weak, nonatomic) NSString *nextImgName;


@end
