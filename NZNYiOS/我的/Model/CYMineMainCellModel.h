//
//  CYMineMainCellModel.h
//  nzny
//
//  Created by 男左女右 on 16/10/11.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "JSONModel.h"

@interface CYMineMainCellModel : JSONModel

// 标题：cell的前面的文本
@property (nonatomic,copy) NSString *mineCellTitle;

// 信息：cell的中间文本
@property (nonatomic,copy) NSString *mineCellInfo;

// 星级：视图：有五个imageView 子视图
@property (nonatomic,strong) UIView *mineCreditRatingView;


// 星级：评级string
@property (nonatomic,assign) float mineStarLevel;

// 星级认证：cell
@property (nonatomic,assign) BOOL isStarLevelCell;


// 下一页：imageName
@property (nonatomic, copy) NSString *nextImgName;



@end
