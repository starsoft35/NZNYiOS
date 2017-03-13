//
//  CYBackCertifiView.m
//  nzny
//
//  Created by 男左女右 on 2016/10/22.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBackCertifiView.h"

// 模型
#import "CYBackCertifiViewModel.h"



#define cEduCationCertiFlag (@"certificate1")
#define cIDCardCertiFlag (@"certificate2")
#define cWageCertiFlag (@"certificate3")
#define cPropertyCertiFlag (@"certificate4")
#define cDriveCertiFlag (@"certificate5")
#define cOtherCertiFlag (@"certificate6")
#define cOtherFirCertiFlag (@"certificate7")
#define cOtherSecCertiFlag (@"certificate8")
#define cOtherThirdCertiFlag (@"certificate9")

@implementation CYBackCertifiView



- (void)setListArr:(NSMutableArray *)listArr{
    
    _listArr = listArr;
    
    for (CYBackCertifiViewModel *tempModel in listArr) {
        
        // 第一个imageView：学历证
        if ([tempModel.Name isEqualToString:@"certificate1"]) {
            
            switch (tempModel.AuditStatus) {
                case 1:
                    
                    // 未上传
                    _educationImgView.image = [UIImage imageNamed:@"学历证1"];
                    _educationImgView.userInteractionEnabled = YES;
                    break;
                    
                case 2:
                    
                    // 已上传，待审核：是2
                    _educationImgView.image = [UIImage imageNamed:@"学历证3"];
                    _educationImgView.userInteractionEnabled = NO;
                    break;
                    
                case 3:
                    
                    // 已认证：是3
                    _educationImgView.image = [UIImage imageNamed:@"学历证2"];
                    _educationImgView.userInteractionEnabled = YES;
                    break;
                    
                case 4:
                    
                    // 未通过
                    _educationImgView.image = [UIImage imageNamed:@"学历证4"];
                    _educationImgView.userInteractionEnabled = YES;
                    break;
                    
                    
                default:
                    break;
            }
            
            
        }
        // 第二个imageView：身份证
        else if ([tempModel.Name isEqualToString:@"certificate2"]) {
            
            switch (tempModel.AuditStatus) {
                case 1:
                    
                    // 未上传
                    _IDCardImgView.image = [UIImage imageNamed:@"身份证1"];
                    _IDCardImgView.userInteractionEnabled = YES;
                    break;
                    
                case 2:
                    
                    // 已上传，待审核：是2
                    _IDCardImgView.image = [UIImage imageNamed:@"身份证3"];
                    _IDCardImgView.userInteractionEnabled = NO;
                    break;
                    
                case 3:
                    
                    // 已认证：是3
                    _IDCardImgView.image = [UIImage imageNamed:@"身份证2"];
                    _IDCardImgView.userInteractionEnabled = YES;
                    break;
                    
                case 4:
                    
                    // 未通过
                    _IDCardImgView.image = [UIImage imageNamed:@"身份证4"];
                    _IDCardImgView.userInteractionEnabled = YES;
                    break;
                    
                    
                default:
                    break;
            }
            
            
        }
        // 第三个imageView：工资条
        else if ([tempModel.Name isEqualToString:@"certificate3"]) {
            
            switch (tempModel.AuditStatus) {
                case 1:
                    
                    // 未上传
                    _wageImgView.image = [UIImage imageNamed:@"工资条1"];
                    _wageImgView.userInteractionEnabled = YES;
                    break;
                    
                case 2:
                    
                    // 已上传，待审核：是2
                    _wageImgView.image = [UIImage imageNamed:@"工资条3"];
                    _wageImgView.userInteractionEnabled = NO;
                    break;
                    
                case 3:
                    
                    // 已认证：是3
                    _wageImgView.image = [UIImage imageNamed:@"工资条2"];
                    _wageImgView.userInteractionEnabled = YES;
                    break;
                    
                case 4:
                    
                    // 未通过
                    _wageImgView.image = [UIImage imageNamed:@"工资条4"];
                    _wageImgView.userInteractionEnabled = YES;
                    break;
                    
                    
                default:
                    break;
            }
            
            
        }
        // 第四个imageView：房产证
        else if ([tempModel.Name isEqualToString:@"certificate4"]) {
            
            switch (tempModel.AuditStatus) {
                case 1:
                    
                    // 未上传
                    _propertyImgView.image = [UIImage imageNamed:@"房产证1"];
                    _propertyImgView.userInteractionEnabled = YES;
                    break;
                    
                case 2:
                    
                    // 已上传，待审核：是2
                    _propertyImgView.image = [UIImage imageNamed:@"房产证3"];
                    _propertyImgView.userInteractionEnabled = NO;
                    break;
                    
                case 3:
                    
                    // 已认证：是3
                    _propertyImgView.image = [UIImage imageNamed:@"房产证2"];
                    _propertyImgView.userInteractionEnabled = YES;
                    break;
                    
                case 4:
                    
                    // 未通过
                    _propertyImgView.image = [UIImage imageNamed:@"房产证4"];
                    _propertyImgView.userInteractionEnabled = YES;
                    break;
                    
                    
                default:
                    break;
            }
            
            
        }
        // 第五个imageView：行驶证
        else if ([tempModel.Name isEqualToString:@"certificate5"]) {
            
            switch (tempModel.AuditStatus) {
                case 1:
                    
                    // 未上传
                    _driveImgView.image = [UIImage imageNamed:@"行驶证1"];
                    _driveImgView.userInteractionEnabled = YES;
                    break;
                    
                case 2:
                    
                    // 已上传，待审核：是2
                    _driveImgView.image = [UIImage imageNamed:@"行驶证3"];
                    _driveImgView.userInteractionEnabled = NO;
                    break;
                    
                case 3:
                    
                    // 已认证：是3
                    _driveImgView.image = [UIImage imageNamed:@"行驶证2"];
                    _driveImgView.userInteractionEnabled = YES;
                    break;
                    
                case 4:
                    
                    // 未通过
                    _driveImgView.image = [UIImage imageNamed:@"行驶证4"];
                    _driveImgView.userInteractionEnabled = YES;
                    break;
                    
                    
                default:
                    break;
            }
            
            
        }
        // 第六个imageView：其他
        else if ([tempModel.Name isEqualToString:@"certificate6"]) {
            
            switch (tempModel.AuditStatus) {
                case 1:
                    
                    // 未上传
                    _otherImgView.image = [UIImage imageNamed:@"添加"];
                    _otherImgView.userInteractionEnabled = YES;
                    break;
                    
                case 2:
                    
                    // 已上传，待审核：是2
                    _otherImgView.image = [UIImage imageNamed:@"其它审核中"];
                    _otherImgView.userInteractionEnabled = NO;
                    
                    // 其它1：显示
                    _otherFirstImgView.hidden = NO;
                    break;
                    
                case 3:
                    
                    // 已认证：是3
                    _otherImgView.image = [UIImage imageNamed:@"其它已认证"];
                    _otherImgView.userInteractionEnabled = YES;
                    
                    // 其它1：显示
                    _otherFirstImgView.hidden = NO;
                    
                    break;
                    
                case 4:
                    
                    // 未通过
                    _otherImgView.image = [UIImage imageNamed:@"其它未通过-"];
                    _otherImgView.userInteractionEnabled = YES;
                    
                    // 其它1：显示
                    _otherFirstImgView.hidden = NO;
                    break;
                    
                    
                default:
                    break;
            }
            
            
        }
        // 第七个imageView：其他1
        else if ([tempModel.Name isEqualToString:@"certificate7"]) {
            
            switch (tempModel.AuditStatus) {
                case 1:
                    
                    // 未上传
                    _otherFirstImgView.image = [UIImage imageNamed:@"添加"];
                    _otherFirstImgView.userInteractionEnabled = YES;
                    break;
                    
                case 2:
                    
                    // 已上传，待审核：是2
                    _otherFirstImgView.image = [UIImage imageNamed:@"其它审核中"];
                    _otherFirstImgView.userInteractionEnabled = NO;
                    
                    // 其它2：显示
                    _otherSecondImgView.hidden = NO;
                    break;
                    
                case 3:
                    
                    // 已认证：是3
                    _otherFirstImgView.image = [UIImage imageNamed:@"其它已认证"];
                    _otherFirstImgView.userInteractionEnabled = YES;
                    
                    // 其它2：显示
                    _otherSecondImgView.hidden = NO;
                    break;
                    
                case 4:
                    
                    // 未通过
                    _otherFirstImgView.image = [UIImage imageNamed:@"其它未通过-"];
                    _otherFirstImgView.userInteractionEnabled = YES;
                    
                    // 其它2：显示
                    _otherSecondImgView.hidden = NO;
                    break;
                    
                    
                default:
                    break;
            }
            
            
        }
        // 第八个imageView：其他2
        else if ([tempModel.Name isEqualToString:@"certificate8"]) {
            
            switch (tempModel.AuditStatus) {
                case 1:
                    
                    // 未上传
                    _otherSecondImgView.image = [UIImage imageNamed:@"添加"];
                    _otherSecondImgView.userInteractionEnabled = YES;
                    break;
                    
                case 2:
                    
                    // 已上传，待审核：是2
                    _otherSecondImgView.image = [UIImage imageNamed:@"其它审核中"];
                    _otherSecondImgView.userInteractionEnabled = NO;
                    
                    // 其它3：显示
                    _otherThirdImgView.hidden = NO;
                    break;
                    
                case 3:
                    
                    // 已认证：是3
                    _otherSecondImgView.image = [UIImage imageNamed:@"其它已认证"];
                    _otherSecondImgView.userInteractionEnabled = YES;
                    
                    // 其它3：显示
                    _otherThirdImgView.hidden = NO;
                    break;
                    
                case 4:
                    
                    // 未通过
                    _otherSecondImgView.image = [UIImage imageNamed:@"其它未通过-"];
                    _otherSecondImgView.userInteractionEnabled = YES;
                    
                    // 其它3：显示
                    _otherThirdImgView.hidden = NO;
                    break;
                    
                    
                default:
                    break;
            }
            
            
        }
        // 第九个imageView：其他3
        else if ([tempModel.Name isEqualToString:@"certificate9"]) {
            
            switch (tempModel.AuditStatus) {
                case 1:
                    
                    // 未上传
                    _otherThirdImgView.image = [UIImage imageNamed:@"添加"];
                    _otherThirdImgView.userInteractionEnabled = YES;
                    break;
                    
                case 2:
                    
                    // 已上传，待审核：是2
                    _otherThirdImgView.image = [UIImage imageNamed:@"其它审核中"];
                    _otherThirdImgView.userInteractionEnabled = NO;
                    break;
                    
                case 3:
                    
                    // 已认证：是3
                    _otherThirdImgView.image = [UIImage imageNamed:@"其它已认证"];
                    _otherThirdImgView.userInteractionEnabled = YES;
                    break;
                    
                case 4:
                    
                    // 未通过
                    _otherThirdImgView.image = [UIImage imageNamed:@"其它未通过-"];
                    _otherThirdImgView.userInteractionEnabled = YES;
                    break;
                    
                    
                default:
                    break;
            }
            
            
        }
        
        
    }
    
    
    
}

// 懒加载
//- (NSMutableArray *)listArr{
//
//    if (_listArr == nil) {
//
//        _listArr = [[NSMutableArray alloc] init];
//        
//    }
//    
//    return _listArr;
//}


@end
