//
//  CYHonestyVC.m
//  nzny
//
//  Created by 男左女右 on 2016/10/22.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYHonestyVC.h"


// titleAndDetailCell
#import "CYTitleAndDetailCell.h"

// 手机认证VC
#import "CYPhoneCertifiVC.h"


// 背景认证VC
#import "CYBackCertifiVC.h"




@interface CYHonestyVC ()

@end

@implementation CYHonestyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"诚信认证";
    
//    [self loadData];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"viewWillAppear");
    [self loadData];
}

- (void)loadData{
    
    
    
    // 手机认证：detail
    NSString *phoneCertifiDetail = [[NSString alloc] init];
    
    
//    NSLog(@"onlyUser.userAccount:%@",self.onlyUser.userAccount);
//    
    // 当前用户
    if (self.onlyUser.userAccount != nil) {
        
        // 手机已认证
//        phoneCertifiDetail = [NSString stringWithFormat:@"%@ **** %@ 已认证",[self.onlyUser.userAccount substringToIndex:3],[self.onlyUser.userAccount substringFromIndex:7]];
        phoneCertifiDetail = [NSString stringWithFormat:@"已认证"];
        
    }
    else {
        
        phoneCertifiDetail = @"手机未认证";
    }
    
    self.dataArray = (NSMutableArray *)@[
                   @[
                       @{
                           @"title":@"手机认证",
                           @"detail":phoneCertifiDetail
                           }
                       
                       ],
                   @[
                       
                       @{
                           @"title":@"背景认证",
                           @"detail":@""
                           }
                       ]
                   ];
    
    
    [self.baseTableView reloadData];
}




// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 注册
    [self.baseTableView registerNib:[UINib nibWithNibName:@"CYTitleAndDetailCell" bundle:nil] forCellReuseIdentifier:@"CYTitleAndDetailCell"];
    
    // cell
    CYTitleAndDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CYTitleAndDetailCell"];
    
    // 模型
    CYTitleAndDetailModel *model = [[CYTitleAndDetailModel alloc] init];
    
    
    
    // 假数据
    model.title = self.dataArray[indexPath.section][indexPath.row][@"title"];
    model.detail = self.dataArray[indexPath.section][indexPath.row][@"detail"];
    
    
    // 模型赋值
    cell.titleAndDetailModel = model;
    
    
    if (indexPath.section == 0 && indexPath.row == 0 && self.onlyUser.userAccount != nil) {
        
        cell.nextImgView.image = nil;
        [_numberLab removeFromSuperview];
        
        
        
//        _numberLab = [[UILabel alloc] initWithFrame:numbLabFrame];
        _numberLab = [[UILabel alloc] init];
        
        _numberLab.textAlignment = NSTextAlignmentRight;
        _numberLab.font = [UIFont systemFontOfSize:15];
        
        _numberLab.text = [NSString stringWithFormat:@"%@ **** %@",[self.onlyUser.userAccount substringToIndex:3],[self.onlyUser.userAccount substringFromIndex:7]];
        // 手机号label的size：自动计算label的高度、宽度
        CGSize tempLabelSize = [self labelAutoCalculateRectWith:self.numberLab.text FontSize:15 MaxSize:CGSizeMake(240.0 / 375.0 * cScreen_Width, cell.detailLab.frame.size.height)];
        
        // 已认证label的size：自动计算label的高度、宽度
        CGSize detailLabSize = [self labelAutoCalculateRectWith:@"已认证" FontSize:15 MaxSize:CGSizeMake(240.0 / 375.0 * cScreen_Width, cell.detailLab.frame.size.height)];
        
        
        // 手机号label的x：手机屏宽 - nextImgView到右边的距离 - nextImgView的宽 - nextImgView到已认证label的距离 - 已认证label的宽 - 已认证到手机号label的距离 - 手机号的宽
        float numbLabFrameX = cScreen_Width - 13 - cell.nextImgView.frame.size.width - 12 - detailLabSize.width - 10 - tempLabelSize.width;
        
        
        // 手机号label的frame
        CGRect numbLabFrame = CGRectMake(numbLabFrameX, cell.detailLab.frame.origin.y, tempLabelSize.width, cell.detailLab.frame.size.height);
        
        
        _numberLab.frame = numbLabFrame;
        
        
        cell.detailLab.textColor = [UIColor colorWithRed:0.91 green:0.51 blue:0.23 alpha:1.00];
        
        [cell addSubview:_numberLab];
        
    }
    
    return cell;
    
}


// headerHeight
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20.0 / 1334.0 * cScreen_Height;
}

// footHeight
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}

// cell:height
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return 88.0 / 1334.0 * cScreen_Height;
//}


// cell：单击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了cell：%@",indexPath);
    
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        if (self.onlyUser.userAccount == nil) {
            
            CYPhoneCertifiVC *phoneCertifiVC = [[CYPhoneCertifiVC alloc] init];
            
            [self.navigationController pushViewController:phoneCertifiVC animated:YES];
        }
        
        
    }
    else if (indexPath.section == 1 && indexPath.row == 0){
        
        CYBackCertifiVC *backCertifiVC = [[CYBackCertifiVC alloc] init];
        
        [self.navigationController pushViewController:backCertifiVC animated:YES];
    }
    
    //当离开某行时，让某行的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
