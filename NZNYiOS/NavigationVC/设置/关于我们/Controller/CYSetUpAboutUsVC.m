//
//  CYSetUpAboutUsVC.m
//  nzny
//
//  Created by 男左女右 on 2017/1/7.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYSetUpAboutUsVC.h"

@interface CYSetUpAboutUsVC ()

@end

@implementation CYSetUpAboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于我们";
    
    
    // 设置行间距
    _aboutUsLab.frame = CGRectMake(0, 20, 320, 200);
    [_aboutUsLab setFont:[UIFont systemFontOfSize:15]];
    
    [_aboutUsLab setNumberOfLines:0];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_aboutUsLab.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5.0];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_aboutUsLab.text length])];
    _aboutUsLab.attributedText = attributedString;
    _aboutUsLab.contentMode = UIViewContentModeTop;
    [_aboutUsLab sizeToFit];
}


@end
