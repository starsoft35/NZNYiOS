//
//  CYPortraitVC.m
//  nzny
//
//  Created by 男左女右 on 2016/12/31.
//  Copyright © 2016年 nznychina. All rights reserved.
//

#import "CYPortraitVC.h"

@interface CYPortraitVC ()

@end

@implementation CYPortraitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"头像";
    
    // 设置视图
    [self setPortraitView];
    
    
}

// 设置视图
- (void)setPortraitView{
    
//    self.headerImgView.image = [CYUtilities setUrlImgWithHostUrl:cHostUrl andUrl:self.onlyUser.Portrait];
    if ([self.onlyUser.Portrait isEqualToString:@""]) {
        
        self.headerImgView.image = [UIImage imageNamed:@"默认头像"];
    }
    else {
        
        [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",cHostUrl,self.onlyUser.Portrait]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    }
    
}

// 手机上传：点击事件
- (IBAction)phoneUploadBtnClick:(id)sender {
    NSLog(@"手机上传：点击事件");
    
    // 跳转到相机或相册页面。
//    UIImagePickerController *imgPickerController = [[UIImagePickerController alloc] init];
//    
//    imgPickerController.delegate = self;
//    imgPickerController.allowsEditing = YES;
//    imgPickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//    
//    [self presentViewController:imgPickerController animated:YES completion:nil];
    
    
    // 头像点击事件：手势
    [self headImgViewChangeClick];
    
}


// 拍照上传：单击事件
- (IBAction)takePhotosUploadBtnClick:(id)sender {
    NSLog(@"拍照上传：点击事件");
    
    
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
    
    // 显示加载
    [self showLoadingView];
    
    
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
            
            // 2、网络请求：修改头像：带参数：图片的路径
            [self requestChangePortraitWithPortraitPath:responseObject[@"res"][@"data"][@"path"] andImg:image];
            
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

// 网络请求：修改头像：带参数：图片的路径
- (void)requestChangePortraitWithPortraitPath:(NSString *)portraitPath andImg:(UIImage *)image{
    NSLog(@"网络请求：修改头像：带参数：图片的路径");
    
    // 请求数据
    NSString *newUrl = [NSString stringWithFormat:@"%@?userId=%@&portrait=%@",cModifyPortraitUrl,self.onlyUser.userID,portraitPath];
    
    // 显示加载
    [self showLoadingView];
    
    // 请求数据：修改头像
    [CYNetWorkManager postRequestWithUrl:newUrl params:nil progress:^(NSProgress *uploadProgress) {
        NSLog(@"修改头像进度：%@",uploadProgress);
        
    } whenSuccess:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"修改头像：请求成功！");
        
        // 1、
        NSString *code = responseObject[@"code"];
        
        // 1.2.1.1.2、和成功的code 匹配
        if ([code isEqualToString:@"0"]) {
            NSLog(@"修改头像：获取成功！");
            NSLog(@"修改头像：%@",responseObject);
            
            [self hidenLoadingView];
            
            // 修改imageView
            [self changeImgViewWithImg:image];
            
            // 返回上一个界面
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else{
            NSLog(@"修改头像：获取失败:responseObject:%@",responseObject);
            NSLog(@"修改头像：获取失败:responseObject:res:msg:%@",responseObject[@"res"][@"msg"]);
            // 1.2.1.1.2.2、获取失败：弹窗提示：获取失败的返回信息
            [self showHubWithLabelText:responseObject[@"res"][@"msg"] andHidAfterDelay:3.0];
            
        }
        
        
    } whenFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"修改头像：请求失败！:error:%@",error);
        
        [self showHubWithLabelText:@"请检查网络，重新加载" andHidAfterDelay:3.0];
        
    } withToken:self.onlyUser.userToken];
}

// 上传图片成功，修改imageView
- (void)changeImgViewWithImg:(UIImage *)image{
    
    // 上传图片成功，修改imageView
    self.headerImgView.image = image;
    
}


@end
