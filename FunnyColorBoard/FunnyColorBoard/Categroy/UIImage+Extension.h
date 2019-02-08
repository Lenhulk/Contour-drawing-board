//
//  UIImage+Extension.h
//  AddFriendsDB
//
//  Created by apple004 on 2017/6/20.
//  Copyright © 2017年 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/// 根据颜色生成一张图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/// 按比例缩放[适应]newSize的图片 ,也就是可能只有一边满足newSize的大小就不拉伸了
- (UIImage *)scaleToSize:(CGSize)newSize;

/// 返回size大小的自定义圆角图片
- (UIImage *)drawRectWithRoundedCorner:(CGFloat)radius sizeToFit:(CGSize)size;

/// 生成一张模糊图片
+ (UIImage *)boxblurImage:(UIImage *)image boxSize:(int)boxSize;

/// 压缩图片质量
+ (NSData *)compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength;
///压缩图片尺寸
+ (NSData *)compressImageSize:(UIImage *)image toByte:(NSUInteger)maxLength;

/// 防止拍照获取的图片自动旋转
- (UIImage *)fixOrientation;
@end
