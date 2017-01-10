//
//  CYOtherVideoVC.h
//  nzny
//
//  Created by 男左女右 on 2016/11/23.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBaseCollectionViewController.h"

@interface CYOtherVideoVC : CYBaseCollectionViewController


// 所查看的用户Id
@property (nonatomic, copy) NSString *oppUserId;

// 视频的id
@property (nonatomic, copy) NSString *videoId;


// 视频信息数据源
@property (nonatomic,strong) NSMutableArray *videoListDataArr;


@end
