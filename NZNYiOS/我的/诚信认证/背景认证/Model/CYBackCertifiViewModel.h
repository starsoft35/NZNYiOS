//
//  CYBackCertifiViewModel.h
//  nzny
//
//  Created by 男左女右 on 2016/10/27.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

//@class Res;
//@class Data;
//@class List;

@interface CYBackCertifiViewModel : CYBaseModel

//// code：请求是否成功：0：成功，1：失败
//@property (nonatomic, copy) NSString *code;
//
//// res：返回信息
//@property (nonatomic, strong) Res *res;




// AuditDate：
@property (nonatomic, copy) NSString *AuditData;
@property (nonatomic, copy) NSString *AuditIdea;
@property (nonatomic, assign) NSInteger AuditStatus;
@property (nonatomic, copy) NSString *AuditUserId;
@property (nonatomic, copy) NSString *CreateDate;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *Image;
@property (nonatomic, copy) NSString *Name;
@property (nonatomic, copy) NSString *UserId;




@end



//// Res：子模型
//@interface Res : CYBaseModel
//
//// data：返回的数据
//@property (nonatomic, strong) Data *data;
//
//// msg：返回的消息
//@property (nonatomic, copy) NSString *msg;
//
//@end
//
//
//// Res 的子模型：Data
//@interface Data : CYBaseModel
//
//// count：
//@property (nonatomic, assign) NSInteger *count;
//
//// list：
//@property (nonatomic, strong) NSArray<List *>*list;
//
//@end
//
//
//// Data 的子模型：List
//@interface List : CYBaseModel
//
//// AuditDate：
//@property (nonatomic, copy) NSString *AuditData;
//@property (nonatomic, copy) NSString *AuditIdea;
//@property (nonatomic, assign) NSNumber *AuditStatus;
//@property (nonatomic, copy) NSString *AuditUserId;
//@property (nonatomic, copy) NSString *CreateDate;
//@property (nonatomic, copy) NSString *Id;
//@property (nonatomic, copy) NSString *Image;
//@property (nonatomic, copy) NSString *Name;
//@property (nonatomic, copy) NSString *UserId;
//
//@end
