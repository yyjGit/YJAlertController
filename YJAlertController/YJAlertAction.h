//
//  YJAlertAction.h
//  YJAlertController
//
//  Created by yyj on 2022/4/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, YJAlertActionStyle) {
    YJAlertActionStyleDefault = 0,  // 默认的-灰色的
    YJAlertActionStyleHighlight     // 高亮-彩色的
};


@interface YJAlertAction : NSObject

///  标题
@property (nullable, nonatomic, readonly) NSString *title;

/// style
@property (nonatomic, readonly) YJAlertActionStyle style;

/// 图片
@property (nonatomic, readonly) UIImage *image;

/// 事件回调block
@property (nonatomic, readonly) void(^handler)(YJAlertAction *action); // <#Description#>


/// 创建 action
/// @param title 标题
/// @param style style description
/// @param handler 事件回调
+ (instancetype)actionWithTitle:(nullable NSString *)title style:(YJAlertActionStyle)style handler:(void (^ __nullable)(YJAlertAction *action))handler;


/// 创建 action
/// @param title 标题
/// @param style style description
/// @param image 图片
/// @param handler 事件回调
+ (instancetype)actionWithTitle:(nullable NSString *)title style:(YJAlertActionStyle)style image:(UIImage *)image handler:(void (^ __nullable)(YJAlertAction *action))handler;




@end

NS_ASSUME_NONNULL_END
