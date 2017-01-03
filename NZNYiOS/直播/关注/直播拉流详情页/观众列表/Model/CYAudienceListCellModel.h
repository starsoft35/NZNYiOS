//
//  CYAudienceListCellModel.h
//  nzny
//
//  Created by 男左女右 on 2016/12/18.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYAudienceListCellModel : CYBaseModel

// 直播Id
@property (nonatomic, copy) NSString *LiveId;


// 观众Id
@property (nonatomic, copy) NSString *UserId;

// 头像
@property (nonatomic, copy) NSString *Portrait;


@end
