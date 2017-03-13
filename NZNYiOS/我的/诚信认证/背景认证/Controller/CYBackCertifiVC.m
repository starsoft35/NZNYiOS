//
//  CYBackCertifiVC.m
//  nzny
//
//  Created by 男左女右 on 2016/10/22.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYBackCertifiVC.h"


// 背景认证视图
#import "CYBackCertifiView.h"


#define cEduCationCertiFlag (@"certificate1")
#define cIDCardCertiFlag (@"certificate2")
#define cWageCertiFlag (@"certificate3")
#define cPropertyCertiFlag (@"certificate4")
#define cDriveCertiFlag (@"certificate5")
#define cOtherCertiFlag (@"certificate6")
#define cOtherFirCertiFlag (@"certificate7")
#define cOtherSecCertiFlag (@"certificate8")
#define cOtherThirdCertiFlag (@"certificate9")



static NSString *boundary = @"AlvinLeonPostRequest";

@interface CYBackCertifiVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>


// 背景认证视图
@property (nonatomic,strong) CYBackCertifiView *backCertifiView;



// 哪个imageView选择的相机
@property (nonatomic,copy) NSString *flag;



@end

@implementation CYBackCertifiVC





- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"背景认证";
    
    // 先加载数据
    [self loadData];
    
//    // 创建背景认证视图
    [self setBackCertifiView];
    
    // 请求数据前，显示加载
    [self showLoadingView];
    
    
}

// 加载数据
- (void)loadData{
    
    // 参数
    NSDictionary *params = @{
                             @"userId":self.onlyUser.userID
                             };
    
    
    
    // 请求数据
    [CYNetWorkManager getRequestWithUrl:cCertificateListUrl params:params progress:^(NSProgress *uploadProgress) {
        NSLog(@"获取用户背景认证信息进度：%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"获取登录用户的证件列表已经上传证件数量：请求成功！");
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"获取登录用户的证件列表已经上传证件数量：获取成功！");
            
            
            // 清空：每次刷新都需要
            [self.dataArray removeAllObjects];
            
            // 解析数据，模型存到数组
            [self.dataArray addObjectsFromArray:[CYBackCertifiViewModel arrayOfModelsFromDictionaries:responseObject[@"res"][@"data"][@"list"]]];
            
            
            _backCertifiView.listArr = self.dataArray;
            
            // 创建背景认证视图
//            [self setBackCertifiView];
            
            //        [self.tableView reloadData];
            //
            //        [self.tableView.header endRefreshing];
            //        [self.tableView.footer endRefreshing];
            
            // 请求数据结束，取消加载
            [self hidenLoadingView];
            
        }
        else{
            NSLog(@"获取登录用户的证件列表已经上传证件数量：获取失败！");
            
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"获取登录用户的证件列表已经上传证件数量：请求失败！");
        
        
    } withToken:self.onlyUser.userToken];
    
    
}


// 创建背景认证视图
- (void)setBackCertifiView{
    
    // 加载视图
    _backCertifiView = [[[NSBundle mainBundle] loadNibNamed:@"CYBackCertifiView" owner:nil options:nil] lastObject];
    
    
    // 1、学历认证ImgView：点击事件
    _backCertifiView.educationImgView.userInteractionEnabled = YES;
    [_backCertifiView.educationImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(educationImgViewClick)]];
    
    // 2、身份证ImgView：点击事件
    _backCertifiView.IDCardImgView.userInteractionEnabled = YES;
    [_backCertifiView.IDCardImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(IDCardImgViewClick)]];
    
    // 3、工资条ImgView：点击事件
    _backCertifiView.wageImgView.userInteractionEnabled = YES;
    [_backCertifiView.wageImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wageImgViewClick)]];
    
    // 4、房产证ImgView：点击事件
    _backCertifiView.propertyImgView.userInteractionEnabled = YES;
    [_backCertifiView.propertyImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(propertyImgViewClick)]];
    
    // 5、行驶证ImgView：点击事件
    _backCertifiView.driveImgView.userInteractionEnabled = YES;
    [_backCertifiView.driveImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(driveImgViewClick)]];
    
    // 6、其他：ImgView：点击事件
    _backCertifiView.otherImgView.userInteractionEnabled = YES;
    [_backCertifiView.otherImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(otherImgViewClick)]];
    
    
    
    // 7、其他1：ImgView：点击事件
    _backCertifiView.otherFirstImgView.userInteractionEnabled = NO;
    [_backCertifiView.otherFirstImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(otherFirstImgViewClick)]];
    
    _backCertifiView.otherFirstImgView.hidden = YES;
    
    
    // 8、其他2：ImgView：点击事件
    _backCertifiView.otherSecondImgView.userInteractionEnabled = NO;
    [_backCertifiView.otherSecondImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(otherSecondImgViewClick)]];
    
    _backCertifiView.otherSecondImgView.hidden = YES;
    
    
    // 9、其他3：ImgView：点击事件
    _backCertifiView.otherThirdImgView.userInteractionEnabled = NO;
    [_backCertifiView.otherThirdImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(otherThirdImgViewClick)]];
    
    _backCertifiView.otherThirdImgView.hidden = YES;
    
    
    
    self.view = _backCertifiView;
}

// 1、学历认证ImgView：点击事件
- (void)educationImgViewClick{
    NSLog(@"学历认证ImgView：点击事件");
    
    
    self.flag = cEduCationCertiFlag;
    
    
    // 点击imageView 选择相册，改变image
    [self headImgViewChangeClick];
    
    
    
}

// 头像点击事件：手势
- (void)headImgViewChangeClick{
    NSLog(@"头像点击事件：手势");
    
    // 选择框：相机、相册
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    
    //
    sheet.tag = 255;
    [sheet showInView:self.view];
    
    
}

// 选择框：相机、相册，选择的是哪一个：代理事件
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    // 取消
                    return;
                case 1:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    
                    break;
                case 2:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    
                    break;
                    
                default:
                    break;
            }
        }
        else {
            
            if (buttonIndex == 0) {
                
                return;
            }
            else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        
        // 跳转到相机或相册页面。
        UIImagePickerController *imgPickerController = [[UIImagePickerController alloc] init];
        
        imgPickerController.delegate = self;
        imgPickerController.allowsEditing = YES;
        imgPickerController.sourceType = sourceType;
        
        [self presentViewController:imgPickerController animated:YES completion:nil];
        
        //        [imgPickerController release];
    }
}


// ImagePicker delegate 事件
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        NSLog(@"选择的是照片~~");
        
        
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        
        
        // 上传图片
        [self uploadImgWithImg:image];
    }
    else {
        
        [self showHubWithLabelText:@"请选择照片上传" andHidAfterDelay:3.0];
    }
    
}


// 上传图片
- (void)uploadImgWithImg:(UIImage *)image{
    
    NSDictionary *uploadImgParams = @{
                                      @"UserId":self.onlyUser.userID,
                                      @"FileType":@"image"
                                      };
    
    [CYNetWorkManager uploadImgRequestWithUrl:cUploadImgUrl params:uploadImgParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSLog(@"上传图片：处理图片！");
        
        // 对图片进行压缩（参数一：要压缩的图片，参数二：压缩质量，可不写）
        NSData *data = UIImageJPEGRepresentation(image, 0.001);
        
        NSLog(@"image:%@",image);
        NSLog(@"data:%@",data);
        
        // 文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg",str];
        
        NSLog(@"fileName:%@",fileName);
        
        // 参数一：文件转换后的data数据
        // 参数二：图片放入的文件夹的名字
        // 参数三：图片的名字
        // 参数四：文件的类型
        [formData appendPartWithFileData:data name:@"FileData" fileName:fileName mimeType:@"image/jpg"];
        
    } progress:^(NSProgress *uploadProgress) {
        NSLog(@"上传进度：%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"上传图片请求：请求成功！");
        NSLog(@"responseObject:%@",responseObject);
        
        
        // 2.3.1.1、获取code 值
        NSString *code = responseObject[@"code"];
        
        
        // 2.3.1.2、判断返回值
        if ([code isEqualToString:@"0"]) {
            NSLog(@"上传图片：成功！");
            NSLog(@"msg:%@",responseObject[@"res"][@"msg"]);
            
            
            // 上传图片成功
//            // 1、保存返回的图片的路径
//            _imgPath = responseObject[@"res"][@"data"][@"path"];
//            NSLog(@"保存的图片路径，imagePath：%@",responseObject[@"res"][@"data"][@"path"]);
            
            // 2、保存用户证件：带参数：图片的路径
            [self saveCertificateInfoWithImgPath:responseObject[@"res"][@"data"][@"path"] andImage:image];
            
        }
        else{
            NSLog(@"上传图片：失败！");
            NSLog(@"msg:%@",responseObject[@"res"][@"msg"]);
            
            // 2.3.1.2.2、上传图片失败，弹窗
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"上传图片：请求失败！");
        NSLog(@"error:%@",error);
        
        [self showHubWithLabelText:@"网络请求出错，请检查网络重新上传！" andHidAfterDelay:3.0];
        
    } withToken:self.onlyUser.userToken];
    
    
}


// 上传图片成功，保存用户证件
- (void)saveCertificateInfoWithImgPath:(NSString *)imgPath andImage:(UIImage *)image{
    
    NSString *certifiID = [self getCurrentImgCertifiID];
    
    NSString *tempUrl = [NSString stringWithFormat:@"%@?id=%@&image=%@",cCertificateEditUrl,certifiID,imgPath];
    
    [CYNetWorkManager postRequestWithUrl:tempUrl params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"progress:%@",uploadProgress);
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"上传保存用户证件：请求成功！");
        
        
        // 2.3.1.1、获取code 值
        NSString *code = responseObject[@"code"];
        
        // 2.3.1.2、判断返回值
        if ([code isEqualToString:@"0"]) {
            NSLog(@"上传保存用户证件：上传保存证件成功！");
            
            
            // 上传保存用户证件成功，提示用户：保存成功
            [self showHubWithLabelText:@"上传成功！" andHidAfterDelay:3.0];
            
            // 修改imageView
//            [self changeImgViewWithImg:image];
            
            [self loadData];
            
        }
        else{
            NSLog(@"上传保存用户证件：上传保存证件失败！");
            NSLog(@"msg:%@",responseObject[@"res"][@"msg"]);
            
            // 2.3.1.2.2、上传图片失败，弹窗
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
        }
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"上传保存用户证件：请求失败！");
        NSLog(@"error:%@",error);
        [self showHubWithLabelText:@"上传证件失败，请检查网络" andHidAfterDelay:3.0];
        
    } withToken:self.onlyUser.userToken];
    
}

// 获得当前点击的证件的ID
- (NSString *)getCurrentImgCertifiID{
    
    
    
    NSString *certifiID = [[NSString alloc] init];
    CYBackCertifiViewModel *tempModel = [[CYBackCertifiViewModel alloc] init];
    
    if ([self.flag isEqualToString:cEduCationCertiFlag]) {
        
        // 学历证
        tempModel = self.dataArray[0];
        certifiID = tempModel.Id;
    }
    else if ([self.flag isEqualToString:cIDCardCertiFlag]) {
        
        // 身份证
        tempModel = self.dataArray[1];
        certifiID = tempModel.Id;
    }
    else if ([self.flag isEqualToString:cWageCertiFlag]) {
        
        // 工资条
        tempModel = self.dataArray[2];
        certifiID = tempModel.Id;
    }
    else if ([self.flag isEqualToString:cPropertyCertiFlag]) {
        
        // 房产证
        tempModel = self.dataArray[3];
        certifiID = tempModel.Id;
    }
    else if ([self.flag isEqualToString:cDriveCertiFlag]) {
        
        // 行驶证
        tempModel = self.dataArray[4];
        certifiID = tempModel.Id;
    }
    else if ([self.flag isEqualToString:cOtherCertiFlag]) {
        
        // 其他证
        tempModel = self.dataArray[5];
        certifiID = tempModel.Id;
    }
    else if ([self.flag isEqualToString:cOtherFirCertiFlag]) {
        
        // 其他证1
        tempModel = self.dataArray[6];
        certifiID = tempModel.Id;
    }
    else if ([self.flag isEqualToString:cOtherSecCertiFlag]) {
        
        // 其他证2
        tempModel = self.dataArray[7];
        certifiID = tempModel.Id;
    }
    else if ([self.flag isEqualToString:cOtherThirdCertiFlag]) {
        
        // 其他证3
        tempModel = self.dataArray[8];
        certifiID = tempModel.Id;
    }
    
    
    return certifiID;
    
}


// 上传图片成功，修改imageView
- (void)changeImgViewWithImg:(UIImage *)image{
    
    // 上传图片成功，修改imageView
    if ([self.flag isEqualToString:cEduCationCertiFlag]) {
        
        // 1、学历证
        _backCertifiView.educationImgView.image = [UIImage imageNamed:@"学历证3"];
        _backCertifiView.educationImgView.userInteractionEnabled = NO;
    }
    else if ([self.flag isEqualToString:cIDCardCertiFlag]) {
        
        // 2、身份证
        _backCertifiView.IDCardImgView.image = [UIImage imageNamed:@"身份证3"];
        _backCertifiView.IDCardImgView.userInteractionEnabled = NO;
    }
    else if ([self.flag isEqualToString:cWageCertiFlag]) {
        
        // 3、工资条
        _backCertifiView.wageImgView.image = [UIImage imageNamed:@"工资条3"];
        _backCertifiView.wageImgView.userInteractionEnabled = NO;
    }
    else if ([self.flag isEqualToString:cPropertyCertiFlag]) {
        
        // 4、房产证
        _backCertifiView.propertyImgView.image = [UIImage imageNamed:@"房产证3"];
        _backCertifiView.propertyImgView.userInteractionEnabled = NO;
    }
    else if ([self.flag isEqualToString:cDriveCertiFlag]) {
        
        // 5、行驶证
        _backCertifiView.driveImgView.image = [UIImage imageNamed:@"行驶证3"];
        _backCertifiView.driveImgView.userInteractionEnabled = NO;
    }
    else if ([self.flag isEqualToString:cOtherCertiFlag]) {
        
        // 6、其他证
        _backCertifiView.otherImgView.image = [UIImage imageNamed:@"其它审核中"];
        _backCertifiView.otherImgView.userInteractionEnabled = NO;
        
        // 其他1：显示（点击了添加，其他1变为添加，）
        if (_backCertifiView.otherFirstImgView.hidden) {
            
            // 其他1：显示
            _backCertifiView.otherFirstImgView.hidden = NO;
            
            // 其他1：点击事件
            _backCertifiView.otherFirstImgView.userInteractionEnabled = YES;
            
            _backCertifiView.otherFirstImgView.image = [UIImage imageNamed:@"添加"];
            
        }
    }
    else if ([self.flag isEqualToString:cOtherFirCertiFlag]) {
        
        // 7、其他证1
        _backCertifiView.otherFirstImgView.image = [UIImage imageNamed:@"其它审核中"];
        _backCertifiView.otherFirstImgView.userInteractionEnabled = NO;
        
        
        // 7.1、其他2：显示（点击了其他1（此时为添加），其他2变为添加，）
        if (_backCertifiView.otherSecondImgView.hidden) {
            
            // 其他2：显示
            _backCertifiView.otherSecondImgView.hidden = NO;
            
            // 其他2：点击事件
            _backCertifiView.otherSecondImgView.userInteractionEnabled = YES;
            
            _backCertifiView.otherSecondImgView.image = [UIImage imageNamed:@"添加"];
            
        }
        
        
    }
    else if ([self.flag isEqualToString:cOtherSecCertiFlag]) {
        
        // 8、其他证2
        _backCertifiView.otherSecondImgView.image = [UIImage imageNamed:@"其它审核中"];
        _backCertifiView.otherSecondImgView.userInteractionEnabled = NO;
        
        // 8.1、其他3：显示（点击了其他2（此时为添加），其他3变为添加，）
        if (_backCertifiView.otherThirdImgView.hidden) {
            
            // 其他3：显示
            _backCertifiView.otherThirdImgView.hidden = NO;
            
            
            // 其他3：点击事件
            _backCertifiView.otherThirdImgView.userInteractionEnabled = YES;
            
            _backCertifiView.otherThirdImgView.image = [UIImage imageNamed:@"添加"];
            
        }
    }
    else if ([self.flag isEqualToString:cOtherThirdCertiFlag]) {
        
        // 其他证3
        _backCertifiView.otherThirdImgView.image = [UIImage imageNamed:@"其它审核中"];
        _backCertifiView.otherThirdImgView.userInteractionEnabled = NO;
    }
    
}

// 2、身份证认证ImgView：点击事件
- (void)IDCardImgViewClick{
    NSLog(@"身份证认证ImgView：点击事件");
    
    self.flag = cIDCardCertiFlag;
    
    // 点击imageView 选择相册，改变image
    [self headImgViewChangeClick];
    
    
}

// 3、工资条认证ImgView：点击事件
- (void)wageImgViewClick{
    NSLog(@"工资条认证ImgView：点击事件");
    
    
    self.flag = cWageCertiFlag;
    
    // 点击imageView 选择相册，改变image
    [self headImgViewChangeClick];
    
}

// 4、房产证认证ImgView：点击事件
- (void)propertyImgViewClick{
    NSLog(@"房产证认证ImgView：点击事件");
    
    
    self.flag = cPropertyCertiFlag;
    
    // 点击imageView 选择相册，改变image
    [self headImgViewChangeClick];
}

// 5、行驶证认证ImgView：点击事件
- (void)driveImgViewClick{
    NSLog(@"行驶证认证ImgView：点击事件");
    
    
    self.flag = cDriveCertiFlag;
    
    // 点击imageView 选择相册，改变image
    [self headImgViewChangeClick];
}

// 6、其他认证ImgView：点击事件
- (void)otherImgViewClick{
    NSLog(@"其他认证ImgView：点击事件");
    
    
    self.flag = cOtherCertiFlag;
    
    // 点击imageView 选择相册，改变image
    [self headImgViewChangeClick];
}

// 7、其他：1：认证ImgView：点击事件
- (void)otherFirstImgViewClick{
    NSLog(@"其他：1：认证ImgView：点击事件");
    
    
    self.flag = cOtherFirCertiFlag;
    
    // 点击imageView 选择相册，改变image
    [self headImgViewChangeClick];
}

// 8、其他：2：认证ImgView：点击事件
- (void)otherSecondImgViewClick{
    NSLog(@"其他：2：认证ImgView：点击事件");
    
    
    self.flag = cOtherSecCertiFlag;
    
    // 点击imageView 选择相册，改变image
    [self headImgViewChangeClick];
}

// 9、其他：3：认证ImgView：点击事件
- (void)otherThirdImgViewClick{
    NSLog(@"其他：3：认证ImgView：点击事件");
    
    self.flag = cOtherThirdCertiFlag;
    
    // 点击imageView 选择相册，改变image
    [self headImgViewChangeClick];
    
}


@end
