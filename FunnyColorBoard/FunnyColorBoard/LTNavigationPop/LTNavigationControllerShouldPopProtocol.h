//
//  LTNavigationControllerShouldPopProtocol.h
//  FunnyColorBoard
//
//  Created by 大雄 on 2018/6/6.
//  Copyright © 2018年 Niti. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LTNavigationController;

@protocol LTNavigationControllerShouldPopProtocol <NSObject>

- (BOOL)lt_navigationControllerShouldPopWhenSystemBackBtnClick:(LTNavigationController *)navC;

@end
