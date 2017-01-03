//
//  CYAudienceListCell.m
//  nzny
//
//  Created by 男左女右 on 2016/12/18.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYAudienceListCell.h"

@implementation CYAudienceListCell


// 模型赋值
- (void)setAudienceListCellModel:(CYAudienceListCellModel *)audienceListCellModel{
    
    
    _audienceListCellModel = audienceListCellModel;
    
    
    // 头像
//    _headImgView.image = [CYUtilities setUrlImgWithHostUrl:cHostUrl andUrl:audienceListCellModel.Portrait];
    _headImgView.image = [UIImage imageNamed:audienceListCellModel.Portrait];
}


@end
