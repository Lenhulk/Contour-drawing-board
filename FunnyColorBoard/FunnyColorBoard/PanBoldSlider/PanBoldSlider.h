//
//  PanBoldSlider.h
//  FunnyColorBoard
//
//  Created by 大雄 on 2018/6/3.
//  Copyright © 2018年 Niti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PanBoldSlider : UIView
@property (copy, nonatomic) void(^lineBoldBlock)(CGFloat lineB);
@end
