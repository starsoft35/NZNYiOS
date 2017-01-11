//
//  CYVideoCollectionViewCell.h
//  nzny
//
//  Created by 男左女右 on 2016/11/22.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>

// 模型
#import "CYVideoCollectionViewCellModel.h"


@interface CYVideoCollectionViewCell : UICollectionViewCell


// 模型
@property (nonatomic, strong) CYVideoCollectionViewCellModel *videoCellModel;


// 视频背景：imageView
@property (weak, nonatomic) IBOutlet UIImageView *videoBgImgView;


// 视频：显示文本的阴影
@property (weak, nonatomic) IBOutlet UIImageView *videoBgForTextToShowImgView;



// 几零后、星座：label
@property (weak, nonatomic) IBOutlet UILabel *ageAndStarSignLab;

// 性别：imageView
@property (weak, nonatomic) IBOutlet UIImageView *genderImgView;


// 姓名：label
@property (weak, nonatomic) IBOutlet UILabel *nameLab;


// 联系他：button
@property (weak, nonatomic) IBOutlet UIButton *connectBtn;

// 播放：button
@property (weak, nonatomic) IBOutlet UIButton *playBtn;



@end
