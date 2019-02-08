//
//  UIView+Extension.m
//  AddFriendsDB
//
//  Created by apple004 on 2017/6/20.
//  Copyright © 2017年 test. All rights reserved.
//

#import "UIView+NTExtension.h"

@implementation UIView (NTExtension)

+ (instancetype)viewFromXib{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

+ (UIViewController *)fatherView:(UIView *)view{
    UIResponder *responder = view;
    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
    }
    return nil;
}

-(void)setNt_x:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
-(void)setNt_y:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
-(void)setNt_width:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
-(void)setNt_height:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
-(void)setNt_centerX:(CGFloat)centerX{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}
-(void)setNt_centerY:(CGFloat)centerY{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}
-(void)setNt_size:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
-(void)setNt_right:(CGFloat)right{
    self.nt_x = right - self.nt_width;
}
-(void)setNt_bottom:(CGFloat)bottom{
    self.nt_y = bottom - self.nt_height;
}


-(CGFloat)nt_x{
    return self.frame.origin.x;
}
-(CGFloat)nt_y{
    return self.frame.origin.y;
}
-(CGFloat)nt_width{
    return self.frame.size.width;
}
-(CGFloat)nt_height{
    return self.frame.size.height;
}
-(CGFloat)nt_centerX{
    return self.center.x;
}
-(CGFloat)nt_centerY{
    return self.center.y;
}
-(CGSize)nt_size{
    return self.frame.size;
}
-(CGFloat)nt_right{
    return CGRectGetMaxX(self.frame);
}
-(CGFloat)nt_bottom{
    return CGRectGetMaxY(self.frame);
}



@end
