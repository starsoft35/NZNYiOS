//
//  CYOtherLiveVC.h
//  nzny
//
//  Created by 男左女右 on 2016/11/23.
//  Copyright © 2016年 nznychina. All rights reserved.
//

//#import "CYBaseCollectionViewController.h"
#import "CYBaseTableViewController.h"


@interface CYOtherLiveVC : CYBaseTableViewController



// 所查看的用户Id
@property (nonatomic, copy) NSString *oppUserId;


// 视频信息数据源
@property (nonatomic,strong) NSMutableArray *liveListDataArr;

// 暂时没有内容提示：label
@property (nonatomic, strong) UILabel *noDataLab;

@end
