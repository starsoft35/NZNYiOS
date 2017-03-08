//
//  CYAskFeedBackCell.h
//  nzny
//
//  Created by 男左女右 on 2017/2/22.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYAskFeedBackCell : UITableViewCell


// 问题：label
@property (weak, nonatomic) IBOutlet UILabel *askLab;


// 问题、答案分界线：progressView
@property (weak, nonatomic) IBOutlet UIProgressView *askAndAnswerBoundaryProgressView;


// 答案：label
@property (weak, nonatomic) IBOutlet UILabel *answerLab;






@end
