//
//  CYOthersInfoView.m
//  nzny
//
//  Created by 男左女右 on 2016/11/22.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYOthersInfoView.h"

@implementation CYOthersInfoView


// 模型赋值
- (void)setOthersInfoViewModel:(CYOthersInfoViewModel *)othersInfoViewModel{
    
    // 模型赋值
    _othersInfoViewModel = othersInfoViewModel;
    
    // 头像
//    _headImgView.image = [CYUtilities setUrlImgWithHostUrl:cHostUrl andUrl:othersInfoViewModel.Portrait];
    if ([othersInfoViewModel.Portrait isEqualToString:@""]) {
        
        _headImgView.image = [UIImage imageNamed:@"默认头像"];
    }
    else {
        
        [_headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",cHostUrl,othersInfoViewModel.Portrait]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    }
    
    NSMutableArray *tempTagListArr = [[NSMutableArray alloc] init];
    [tempTagListArr addObject:_workLab];
    [tempTagListArr addObject:_houseAndCarLab];
    [tempTagListArr addObject:_hobbyLab];
    [tempTagListArr addObject:_heightLab];
    [tempTagListArr addObject:_starSignLab];
    
    int tempCount = 1;
    for (UILabel *tempLab in tempTagListArr) {
        
        if (tempCount <= othersInfoViewModel.UserTagList.count) {
            
            
            CYOtherTagModel *tempModel = othersInfoViewModel.UserTagList[tempCount - 1];
            
            tempLab.text = tempModel.Name;
            
            tempCount += 1;
        }
        else {
            
            tempLab.text = @"";
        }
        
        
        
    }
    
//    tempTagListArr = othersInfoViewModel.UserTagList;
//    for (CYOtherTagModel *tempTagModel in othersInfoViewModel.UserTagList) {
//        
//        if ([tempTagModel.Id isEqualToString:@"1"]) {
//            
//            
//            // 房车
//            _houseAndCarLab.text = tempTagModel.Name;
//            
//        }
//        else if ([tempTagModel.Id isEqualToString:@"77db687d-5d28-4429-a8bd-d981b5caa9ca"]) {
//            
//            // 身高
//            _heightLab.text = tempTagModel.Name;
//        }
//        else if ([tempTagModel.Id isEqualToString:@"53a2c987-700c-4dec-a3b1-3659b365b2b4"]) {
//            
//            // 星座
//            _starSignLab.text = tempTagModel.Name;
//        }
//        else if ([tempTagModel.Id isEqualToString:@"4"]) {
//            
//            // 工作
//            _workLab.text = tempTagModel.Name;
//        }
//        else if ([tempTagModel.Id isEqualToString:@"5"]) {
//            
//            // 爱好
//            _hobbyLab.text = tempTagModel.Name;
//            
//        }
//    }
    
    
    
    
    
    
    // 姓名
    _nameLab.text = othersInfoViewModel.RealName;
    
    // 年龄
    _ageLab.text = [NSString stringWithFormat:@"%ld 岁",(long)othersInfoViewModel.Age];
    
    // 性别
    
    if ([othersInfoViewModel.Gender isEqualToString:@"男"]) {
        _genderImgView.image = [UIImage imageNamed:@"资料性别男"];
        
    }
    else {
        
        _genderImgView.image = [UIImage imageNamed:@"资料性别女"];
    }
    
    // 关注人数
    _followCountLab.text = [NSString stringWithFormat:@"%ld",(long)othersInfoViewModel.FollowsCount];
    
    // 粉丝人数
    _fansCountLab.text = [NSString stringWithFormat:@"%ld",(long)othersInfoViewModel.FansCount];
    
    // 礼物数量
    _giftCountLab.text = [NSString stringWithFormat:@"%ld",(long)othersInfoViewModel.GiftCount];
    
    // 关注
    //  没有关注，现在可以关注
    if (othersInfoViewModel.IsFollow == NO) {
        
        
//        [_followBtn setBackgroundImage:[UIImage imageNamed:@"关注"] forState:UIControlStateNormal];
        
//        _followBtn.imageView.image = [UIImage imageNamed:@"详情关注-"];
        [_followBtn setImage:[UIImage imageNamed:@"详情关注-"] forState:UIControlStateNormal];
        [_followBtn setTitle:@"加关注" forState:UIControlStateNormal];
        
        [_followBtn setTitleColor:[UIColor colorWithRed:0.37 green:0.65 blue:0.99 alpha:1.00] forState:UIControlStateNormal];
        
    }
    
    // 已经关注，显示取消关注
    else {
        
        [_followBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        [_followBtn setTitle:@"取消关注" forState:UIControlStateNormal];
        [_followBtn setTitleColor:[UIColor colorWithRed:234.0 / 255.0 green:130.0 / 255.0 blue:47.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    
    
}



@end
