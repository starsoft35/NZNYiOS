//
//  CYMyUserInfoDeclarationVC.h
//  nzny
//
//  Created by 张春咏 on 2017/1/2.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYBaseViewController.h"

@interface CYMyUserInfoDeclarationVC : CYBaseViewController


// 爱情宣言：textView
@property (weak, nonatomic) IBOutlet UITextView *declarationTextView;


// 剩余输入字数：label
@property (weak, nonatomic) IBOutlet UILabel *surplusCountLab;


// 限制最大输入字数
@property (weak, nonatomic) IBOutlet UILabel *maxCountLab;


@end
