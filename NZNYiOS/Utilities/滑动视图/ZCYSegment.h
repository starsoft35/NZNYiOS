//
//  ZCYSegment.h
//  ZCYWangYi
//
//  Created by dgp on 16/6/14.
//  Copyright © 2016年 ZCY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCYSegment : UIView


// 初始化segment
- (instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray *)titles action:(void(^)(NSInteger index))clickAction;



// 当前选中的按钮
- (void)selectWithIndex:(NSInteger)index;


@end
