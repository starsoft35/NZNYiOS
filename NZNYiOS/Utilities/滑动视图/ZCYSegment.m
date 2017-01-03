//
//  ZCYSegment.m
//  ZCYWangYi
//
//  Created by dgp on 16/6/14.
//  Copyright © 2016年 ZCY. All rights reserved.
//

#import "ZCYSegment.h"


@interface ZCYSegment ()

{
    // 选中的button 下面的先
    UIView *_line;
    
    // 当前选中的button
    UIButton *_selectedButton;
    
}

// 保存初始化时，块传过来的值
@property (nonatomic,copy)void (^clickAction)(NSInteger index);

@end




@implementation ZCYSegment


// 初始化上部标题button
- (instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray *)titles action:(void(^)(NSInteger index))clickAction{
    
    if (self = [super initWithFrame:frame]) {
        
        // 保存block
        self.clickAction = clickAction;
        
        // 循环创建button
        for (NSInteger i = 0; i < titles.count; i++) {
            
            // 创建button
            //  MyUtil 自定义类
//            UIButton *tempButton = [MyUtil createBtnFrame:CGRectMake(i * frame.size.width / titles.count, 0, frame.size.width / titles.count, frame.size.height - 2) title:titles[i] bgImage:nil selectBgImage:nil image:nil target:self action:@selector(buttonClicked:)];
            UIButton *tempButton = [CYUtilities createBtnFrame:CGRectMake(i * frame.size.width / titles.count, 0, frame.size.width / titles.count, frame.size.height - 2) title:titles[i] imgName:nil bgImgName:nil selectedBgImgName:nil target:self action:@selector(buttonClicked:)];
            
            // 修改字体颜色：button
            [tempButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
            // 选中时字体颜色
            [tempButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            
            // tag
            tempButton.tag = 1000 + i;
            
            
            // button 添加到视图
            [self addSubview:tempButton];
            
            
            // 默认选中第0个button
            if (i == 0) {
                _selectedButton = tempButton;
                
                tempButton.selected = YES;
                
            }
        }
        
        
        // 设置line 的位置
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 2, frame.size.width / titles.count, 2)];
        _line.backgroundColor = [UIColor colorWithRed:0.37 green:0.65 blue:0.99 alpha:1.00];
        
        [self addSubview:_line];
    }
    
    return self;
}

// 上部button点击事件
- (void)buttonClicked:(UIButton *)button{
    
    if (_selectedButton != button) {
        
        
        // 选中的button，不是当前的button，即改变当前button的状态为选中的button
        //   先把选中的button 的选中状态改为NO
        _selectedButton.selected = NO;
        
        //   再把当前button的选中状态改为YES
        button.selected = YES;
        
        //   再把当前的button设置为选中的button
        _selectedButton = button;
        
        
        // 改变线的位置
//        CGRect frame = _line.frame;
//        frame.origin.x = button.frame.origin.x;
//        _line.frame = frame;
        
        // 执行外部闯过来的block
        _clickAction(button.tag - 1000);
        
    }
    
}


// 当前选中的button
- (void)selectWithIndex:(NSInteger)index{
    
    // 获取当前的button
    UIButton *button = (UIButton *)[self viewWithTag:1000 + index];
    
    // 改变选中的button的选中状态为NO
    _selectedButton.selected = NO;
    
    // 当前的button 的选中状态改为YES
    button.selected = YES;
    
    // 当前的button 设置为选中的button
    _selectedButton = button;
    
    
    // 改变线的位置
    CGRect frame = _line.frame;
    frame.origin.x = button.frame.origin.x;
    _line.frame = frame;
    
    
}


@end
