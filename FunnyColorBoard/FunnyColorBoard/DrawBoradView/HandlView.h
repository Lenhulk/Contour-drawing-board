//
//  HandlView.h
//  12-画板
//
//  Created by xmg1 on 16/9/13.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

//1.定义协议
@protocol HandlViewDelegate <NSObject>
- (void)hanleView:(UIView *)handleV newImage:(UIImage *)image;
@end


@interface HandlView : UIView

@property (nonatomic ,strong) UIImage *image;
//2.定义代理属性.
@property (nonatomic,weak) id<HandlViewDelegate> delegate;

@end
