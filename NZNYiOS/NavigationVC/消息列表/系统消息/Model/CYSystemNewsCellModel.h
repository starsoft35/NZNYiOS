//
//  CYSystemNewsCellModel.h
//  nzny
//
//  Created by 男左女右 on 2017/2/18.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYBaseModel.h"

@interface CYSystemNewsCellModel : CYBaseModel


//// 系统消息类型 1-我提交的系统反馈 2-我报名的活动
//@property (nonatomic, assign) NSInteger Type;
//
//// 创建时间
//@property (nonatomic, copy) NSString *CreateDate;
//
//// 我的提问
//@property (nonatomic, copy) NSString *Ask;
//
//// 系统回答
//@property (nonatomic, copy) NSString *Answer;
//
//// 系统消息内容
//@property (nonatomic, copy) NSString *Content;
//
//// 报名的活动的ID
//@property (nonatomic, copy) NSString *ActivityId;




// 系统消息未读数量
@property (nonatomic, assign) NSInteger UnreadCount;

// 活动提示未读数量
@property (nonatomic, assign) NSInteger UnreadActivityCount;

// 我的问答未读数量
@property (nonatomic, assign) NSInteger UnreadFeedbackCount;

// 其它消息未读数量
@property (nonatomic, assign) NSInteger UnreadOtherCount;






@end
