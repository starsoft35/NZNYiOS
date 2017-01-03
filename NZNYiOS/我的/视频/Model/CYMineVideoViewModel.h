//
//  CYMineVideoViewModel.h
//  nzny
//
//  Created by 男左女右 on 2016/10/31.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYMineVideoViewModel : CYBaseModel

//
@property (nonatomic, copy) NSString *AuditDate;
@property (nonatomic, copy) NSString *AuditIdea;
@property (nonatomic, assign) NSInteger AuditStatus;
@property (nonatomic, copy) NSString *AuditUserId;
@property (nonatomic, copy) NSString *CreateDate;
@property (nonatomic, assign) BOOL Default;
@property (nonatomic, assign) BOOL Hot;
@property (nonatomic, copy) NSString *Id;

// 视频的介绍
@property (nonatomic, copy) NSString *Introduction;

// 视频的大小
@property (nonatomic, assign) double Size;
@property (nonatomic, copy) NSString *UserId;

// 视频的路径
@property (nonatomic, copy) NSString *Video;



@end
