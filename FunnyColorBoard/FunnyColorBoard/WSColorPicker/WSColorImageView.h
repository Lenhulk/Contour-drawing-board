//
//  WSColorImageView.h
//  1111
//
//  Created by iMac on 16/12/12.
//  Copyright © 2016年 zws. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSColorImageView : UIImageView

@property (nonatomic, strong) UIColor *selColor;
@property (copy, nonatomic) void(^currentColorBlock)(UIColor *color);


@end
