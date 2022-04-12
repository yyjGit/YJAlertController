//
//  YJAlertController.h
//  YJAlertController
//
//  Created by yyj on 2022/4/12.
//

#import <UIKit/UIKit.h>
#import "YJAlertAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface YJAlertController : UIView

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *message;

// 标题颜色/字体
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont *titleFont;

// 内容颜色/字体
@property (nonatomic, strong) UIColor *messageColor;
@property (nonatomic, strong) UIFont *messageFont;

// 点击按钮外观设置
@property (nonatomic, strong) UIColor *defaultItemTitleColor;
@property (nonatomic, strong) UIColor *defaultItemBackgroundColor;
@property (nonatomic, strong) UIFont *defaultItemFont;
@property (nonatomic, strong) UIColor *highlightItemTitleColor;
@property (nonatomic, strong) UIColor *highlightItemBackgroundColor;
@property (nonatomic, strong) UIFont *highlightItemFont;


/// 类初始化方法
/// @param title 标题
/// @param message 内容
+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message;

/// 添加 action
/// @param action action description
- (void)addAction:(YJAlertAction *)action;

/// 显示
- (void)show;

// 取消显示
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
