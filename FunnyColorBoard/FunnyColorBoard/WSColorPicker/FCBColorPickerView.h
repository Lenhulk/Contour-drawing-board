//
//  FCBColorPickerView.h
//  FunnyColorBoard
//
//  Created by Lenhulk on 2018/6/2.
//  Copyright © 2018年 Niti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCBColorPickerView : UIView

@property (copy, nonatomic) void(^pickupBlock)(UIColor *color);
@end
