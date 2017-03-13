//
//  CYCertificateDetailVC.h
//  nzny
//
//  Created by 男左女右 on 2016/11/30.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseTableViewController.h"

@interface CYCertificateDetailVC : CYBaseTableViewController



// 认证列表数组
@property (nonatomic, strong) NSMutableArray *newCertificateArr;


// 所查看的诚信等级的人
@property (nonatomic, copy) NSString *oppUserId;



@end
