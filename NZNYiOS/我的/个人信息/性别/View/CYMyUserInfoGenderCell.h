//
//  CYMyUserInfoGenderCell.h
//  nzny
//
//  Created by 男左女右 on 2017/1/2.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYMyUserInfoGenderCell : UITableViewCell

// 性别：label
@property (weak, nonatomic) IBOutlet UILabel *genderLab;


// 是否选中：imageView
@property (weak, nonatomic) IBOutlet UIImageView *ifCheckedImgView;


@end
