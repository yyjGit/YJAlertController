//
//  YJAlertAction.m
//  YJAlertController
//
//  Created by yyj on 2022/4/12.
//

#import "YJAlertAction.h"

@interface YJAlertAction ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) YJAlertActionStyle style;
@property (nonatomic, copy) void(^handler)(YJAlertAction *action); // <#Description#>
/// 图片
@property (nonatomic, strong) UIImage *image;

@end

@implementation YJAlertAction


+ (instancetype)actionWithTitle:(nullable NSString *)title style:(YJAlertActionStyle)style handler:(void (^ _Nullable)(YJAlertAction * _Nonnull))handler
{
    YJAlertAction *action = [[YJAlertAction alloc] init];
    action.title = title;
    action.style = style;
    action.handler = handler;
    return action;
}


+ (instancetype)actionWithTitle:(NSString *)title style:(YJAlertActionStyle)style image:(nonnull UIImage *)image handler:(void (^ _Nullable)(YJAlertAction * _Nonnull))handler
{
    YJAlertAction *action = [[YJAlertAction alloc] init];
    action.title = title;
    action.style = style;
    action.image = image;
    action.handler = handler;
    return action;
}
@end
