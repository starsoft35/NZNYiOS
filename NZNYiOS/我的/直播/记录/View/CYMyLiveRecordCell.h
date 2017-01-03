//
//  CYMyLiveRecordCell.h
//  nzny
//
//  Created by 男左女右 on 2016/12/18.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>

// 模型
#import "CYMyLiveRecordCellModel.h"

@interface CYMyLiveRecordCell : UITableViewCell


// 模型
@property (nonatomic, strong) CYMyLiveRecordCellModel *myLiveRecordCellModel;

// 时间：label
@property (weak, nonatomic) IBOutlet UILabel *startTimeLab;


// 标题：label
@property (weak, nonatomic) IBOutlet UILabel *titleLab;


// 观看人数：label
@property (weak, nonatomic) IBOutlet UILabel *watchCountLab;


// 下一页：imageView
@property (weak, nonatomic) IBOutlet UIImageView *nextPageImgView;


@end
