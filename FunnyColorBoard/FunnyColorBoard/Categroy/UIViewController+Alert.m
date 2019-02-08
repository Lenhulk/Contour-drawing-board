//
//  UIViewController+Alert.m
//  AddTags
//
//  Created by weuse on 2017/5/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "UIViewController+Alert.h"

@implementation UIViewController (Alert)


- (void)showAlertVCWithTitle:(NSString *_Nonnull)title message:(NSString *_Nullable)message agreeText:(NSString *_Nullable)agrText agreeHandle:(void (^ __nullable)())handler agreeAcStyle:(UIAlertActionStyle)style cancelText:(NSString *__nullable)canText cancelHandle:(void (^ __nullable)())cancel{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (agrText == nil) agrText = @"确定";
    UIAlertAction *acAgree = [UIAlertAction actionWithTitle:agrText style:style handler:^(UIAlertAction * _Nonnull action) {
        if (handler) handler();
    }];
    
    if (canText == nil) canText = @"取消";
    UIAlertAction *acCancel = [UIAlertAction actionWithTitle:canText style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancel) cancel();
    }];
    
    [alert addAction:acCancel];
    [alert addAction:acAgree];
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)showAlertVCWithTitle:(NSString *_Nonnull)title message:(NSString *_Nullable)message agreeText:(NSString *_Nullable)text agreeHandle:(void (^ __nullable)())handler{
    [self showAlertVCWithTitle:title message:message agreeText:text agreeHandle:handler agreeAcStyle:UIAlertActionStyleDestructive cancelText:nil cancelHandle:nil];
}

- (void)showAlertVCWithTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message{
    if (title == nil) title = @"Warm Prompt";
    if (message == nil) message = @"";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *acCancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:acCancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showAlertVCWithTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message clickHandle:(void(^ __nullable)())handle{
    if (title == nil) title = @"Warm Prompt";
    if (message == nil) message = @"";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *acCancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (handle)
            handle();
    }];
    [alert addAction:acCancel];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)showAlertVCWithTitle:(NSString *_Nonnull)title message:(NSString *_Nullable)message agreeText1:(NSString *_Nullable)text1 agreeText2:(NSString *_Nullable)text2 agreeHandle1:(void (^ __nullable)())handler1 agreeHandle2:(void (^ __nullable)())handler2 cancelText:(NSString *_Nullable)canText cancelHandle:(void (^ __nullable)())cancel
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *acCancel = [UIAlertAction actionWithTitle:canText style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancel) cancel();
    }];
    
    UIAlertAction *acAgree1 = [UIAlertAction actionWithTitle:text1 style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (handler1) handler1();
    }];
    
    UIAlertAction *acAgree2 = [UIAlertAction actionWithTitle:text2 style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (handler2) handler2();
    }];
    
    [alert addAction:acCancel];
    [alert addAction:acAgree1];
    [alert addAction:acAgree2];
    
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}


- (void)showActionSheetWithTitle:(NSString *_Nonnull)title message:(NSString *__nullable)message agreeText:(NSString *_Nullable)agrText agreeStyle:(UIAlertActionStyle)style agreeHandle:(void (^ __nullable)())agree cancelText:(NSString *_Nullable)canText cancelHandle:(void (^ __nullable)())cancel
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (canText == nil) canText = @"Cancel";
    UIAlertAction *acCancel = [UIAlertAction actionWithTitle:canText style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancel) cancel();
    }];
    
    if (agrText == nil) agrText = @"Yes";
    UIAlertAction *acAgree = [UIAlertAction actionWithTitle:agrText style:style handler:^(UIAlertAction * _Nonnull action) {
        if (agree) agree();
    }];
    
    [alert addAction:acAgree];
    [alert addAction:acCancel];
    
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

@end
