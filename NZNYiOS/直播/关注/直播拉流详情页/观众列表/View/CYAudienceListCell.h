//
//  CYAudienceListCell.h
//  nzny
//
//  Created by 男左女右 on 2016/12/18.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>

// 模型
#import "CYAudienceListCellModel.h"


@interface CYAudienceListCell : UICollectionViewCell

// 模型
@property (nonatomic, strong) CYAudienceListCellModel *audienceListCellModel;


// 头像
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;



@end
