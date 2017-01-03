//
//  CYOtherDetailsVC.h
//  nzny
//
//  Created by 男左女右 on 2016/11/23.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseTableViewController.h"

// 模型
#import "CYOtherDetailsModel.h"


@interface CYOtherDetailsVC : CYBaseTableViewController

// 模型
@property (nonatomic, strong) CYOtherDetailsModel *otherDetailsModel;


// 所查看的用户Id
@property (nonatomic, copy) NSString *oppUserId;

@end
