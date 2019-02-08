//
//  UIViewController+Alert.h
//  AddTags
//
//  Created by weuse on 2017/5/2.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Alert)

/**
 *   AlertVC with a single title & Prompt & button
 **/
- (void)showAlertVCWithTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message;
- (void)showAlertVCWithTitle:(NSString *_Nullable)title message:(NSString *_Nullable)message clickHandle:(void(^ __nullable)())handle;


/**
 *   AlertVC with Destructive-style AgreeBtn & Cancel
 **/
- (void)showAlertVCWithTitle:(NSString *_Nonnull)title message:(NSString *_Nullable)message agreeText:(NSString *_Nullable)text agreeHandle:(void (^ __nullable)())handler;


/**
 *   【Main】AlertVC with editabel-style AgreeBtn & Cancel
 **/
- (void)showAlertVCWithTitle:(NSString *_Nonnull)title message:(NSString *_Nullable)message agreeText:(NSString *_Nullable)agrText agreeHandle:(void (^ __nullable)())handler agreeAcStyle:(UIAlertActionStyle)style cancelText:(NSString *__nullable)canText cancelHandle:(void (^ __nullable)())cancel;


/**
 *   AlertVC with 2 Editable-AgreeBtn and 1 Cancel
 **/
- (void)showAlertVCWithTitle:(NSString *_Nonnull)title message:(NSString *_Nullable)message agreeText1:(NSString *_Nullable)text1 agreeText2:(NSString *_Nullable)text2 agreeHandle1:(void (^ __nullable)())handler1 agreeHandle2:(void (^ __nullable)())handler2 cancelText:(NSString *_Nullable)canText cancelHandle:(void (^ __nullable)())cancel;


/**
 *   ActionSheetVC with 1 & 1
 **/
- (void)showActionSheetWithTitle:(NSString *_Nonnull)title message:(NSString *__nullable)message agreeText:(NSString *_Nullable)agrText agreeStyle:(UIAlertActionStyle)style agreeHandle:(void (^ __nullable)())agree cancelText:(NSString *_Nullable)canText cancelHandle:(void (^ __nullable)())cancel;

@end
