//
//  LTNavigationController.m
//  FunnyColorBoard
//
//  Created by 大雄 on 2018/6/6.
//  Copyright © 2018年 Niti. All rights reserved.
//

#import "LTNavigationController.h"
#import "LTNavigationControllerShouldPopProtocol.h"

@interface UINavigationController (UINavigationControllerNeedshouldPopItem)
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(nonnull UINavigationItem *)item;
@end
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wincomplete-implementation"
@implementation UINavigationController (UINavigationControllerNeedshouldPopItem)
@end
#pragma clang diagnostic pop


@interface LTNavigationController () <UINavigationBarDelegate>

@end

@implementation LTNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item{
    UIViewController *vc = self.topViewController;
    
    if (item != vc.navigationItem) {
        return [super navigationBar:navigationBar shouldPopItem:item];
    }
    
    if ([vc conformsToProtocol:@protocol(LTNavigationControllerShouldPopProtocol)]) {
        if ([(id<LTNavigationControllerShouldPopProtocol>)vc lt_navigationControllerShouldPopWhenSystemBackBtnClick:self]) {
            return [super navigationBar:navigationBar shouldPopItem:item];
        } else {
            return NO;
        }
    } else {
        return [super navigationBar:navigationBar shouldPopItem:item];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
