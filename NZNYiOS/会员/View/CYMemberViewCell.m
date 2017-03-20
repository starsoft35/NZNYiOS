//
//  CYMemberViewCell.m
//  nzny
//
//  Created by 男左女右 on 2017/3/16.
//  Copyright © 2017年 nznychina. All rights reserved.
//

#import "CYMemberViewCell.h"

#import "CYOtherTagModel.h"


@implementation CYMemberViewCell

{
    float _nowStarLever;
}


// 模型赋值
- (void)setMemberViewCellModel:(CYMemberViewCellModel *)memberViewCellModel{
    
    _memberViewCellModel = memberViewCellModel;
    
    
    // 头像
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",cHostUrl,memberViewCellModel.Portrait]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    
    // 姓名
    _nameLab.text = memberViewCellModel.RealName;
    
    
    // 性别
    if ([memberViewCellModel.Gender isEqualToString:@"男"]) {
        
        _genderImgView.image = [UIImage imageNamed:@"资料性别男"];
        
    }
    else {
        _genderImgView.image = [UIImage imageNamed:@"资料性别女"];
    }
    
    // 年龄
    _ageLab.text = [NSString stringWithFormat:@"%ld 岁",(long)memberViewCellModel.Age];
    
    // 诚信等级
    // 星级：
    _nowStarLever = memberViewCellModel.CertificateLevel;
    
    if (1) {
        
        // 星一：
        //        _creditRatingView
        _firStarImgView.image = [UIImage imageNamed:[self getStarImgNameWithNowStarLevel:_nowStarLever]];
        
        // 星二：
        _secStarImgView.image = [UIImage imageNamed:[self getStarImgNameWithNowStarLevel:_nowStarLever]];
        
        // 星三：
        _thirdStarImgView.image = [UIImage imageNamed:[self getStarImgNameWithNowStarLevel:_nowStarLever]];
        
        // 星四：
        _fourthStarImgView.image = [UIImage imageNamed:[self getStarImgNameWithNowStarLevel:_nowStarLever]];
        
        // 星五：
        _fifthStarImgView.image = [UIImage imageNamed:[self getStarImgNameWithNowStarLevel:_nowStarLever]];
        
    }
    else {
        
        //        [_creditRatingView removeFromSuperview];
        //        _creditRatingView.hidden = YES;
    }
    
    
    // 标签赋值
    [self setTagValureWithCYMemberViewCellModel:memberViewCellModel];
    
}



// 标签赋值
- (void)setTagValureWithCYMemberViewCellModel:(CYMemberViewCellModel *)memberViewCellModel{
    
    int tempCount = 1;
    NSString *tagStr = [[NSString alloc] init];
    for (CYOtherTagModel * tempTagModel in memberViewCellModel.UserTagList) {
        
        if (memberViewCellModel.UserTagList.count >= 1) {
            
            if (tempCount == 1) {
                
                tagStr = [tagStr stringByAppendingString:[NSString stringWithFormat:@"%@ ",tempTagModel.Name]];
            }
            else {
                
                tagStr = [tagStr stringByAppendingString:[NSString stringWithFormat:@"| %@ ",tempTagModel.Name]];
            }
            
            tempCount += 1;
        }
    }
    // 标签
    _tagLab.text = [NSString stringWithFormat:@"%@",tagStr];
    
}


// 获取星级图片的名字
- (NSString *)getStarImgNameWithNowStarLevel:(float)nowStarLevel{
    
    if (nowStarLevel >= 1) {
        
        _nowStarLever -= 1;
        
        // 全星
        return @"资料-已上传认证";
        
    }
    else if (nowStarLevel == 0.5) {
        
        _nowStarLever -= 0.5;
        
        // 半星
        return @"资料-已上传半颗星";
        
    }
    else
    {
        
        // 空星
        return @"资料未上传认证";
    }
    
}





@end
