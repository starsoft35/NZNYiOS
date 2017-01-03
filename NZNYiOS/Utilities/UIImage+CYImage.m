//
//  UIImage+CYImage.m
//  NZNYiOS
//
//  Created by 男左女右 on 16/8/17.
//  Copyright © 2016年 NZNY. All rights reserved.
//

#import "UIImage+CYImage.h"

@implementation UIImage (CYImage)

// 加载最原始的图片，没有渲染
+ (instancetype)imageWithOriginalName:(NSString *)imageName{
    
    UIImage *image = [UIImage imageNamed:imageName];
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
@end
