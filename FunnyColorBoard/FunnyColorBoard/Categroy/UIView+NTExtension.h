//
//  UIView+Extension.h
//  AddFriendsDB
//
//  Created by apple004 on 2017/6/20.
//  Copyright © 2017年 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NTExtension)

-(void)setNt_x:(CGFloat)x;

-(void)setNt_y:(CGFloat)y;

-(void)setNt_width:(CGFloat)width;

-(void)setNt_height:(CGFloat)height;

-(void)setNt_centerX:(CGFloat)centerX;

-(void)setNt_centerY:(CGFloat)centerY;

-(void)setNt_size:(CGSize)size;

-(void)setNt_right:(CGFloat)right;

-(void)setNt_bottom:(CGFloat)bottom;

-(CGFloat)nt_x;

-(CGFloat)nt_y;

-(CGFloat)nt_width;

-(CGFloat)nt_height;

-(CGFloat)nt_centerX;

-(CGFloat)nt_centerY;

-(CGSize)nt_size;

-(CGFloat)nt_right;

-(CGFloat)nt_bottom;

/// 获取Xib控件
+(instancetype)viewFromXib;

/// 获取父容器的控制器
+ (UIViewController *)fatherView:(UIView *)view;

@end
