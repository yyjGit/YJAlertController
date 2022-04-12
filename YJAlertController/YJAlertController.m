//
//  YJAlertController.m
//  YJAlertController
//
//  Created by yyj on 2022/4/12.
//

#import "YJAlertController.h"

// 弹框
static CGFloat const kAlertMaxHeight = 640;
static CGFloat const kAlertLefeRightMargin = 32;
static CGFloat const kAlertCornerRadius = 15.0;
#define kAlertWidth (UIScreen.mainScreen.bounds.size.width - kAlertLefeRightMargin * 2)

// 标题
static CGFloat const kTitleTopMargin = 16.0; // 标题顶部间距

// 内容
static CGFloat const kMessageTopMargin = 24.0; // 消息顶部间距
static CGFloat const kMessageLeftRightMargin = 20.0; // 消息左右间距

// 点击按钮
static CGFloat const kTapItemTopMargin = 24.0; // 可点击元素顶部间距
static CGFloat const kTapItemHeight = 54.0; // 可点击元素高


@interface YJAlertItem : UIButton
@property (nonatomic, strong) YJAlertAction *action; // <#Description#>
@end
@implementation YJAlertItem
@end


@interface YJAlertController ()

@property (nonatomic, strong) UIButton *cover; // 背景阴影
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSMutableArray<YJAlertAction *> *actions;

@end


@implementation YJAlertController

#pragma mark - life cycle
+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message
{
    return[[YJAlertController alloc] initWithTitle:title message:message];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message
{
    self = [super initWithFrame:UIScreen.mainScreen.bounds];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        self.title = title;
        self.message = message;
        [self defaultConfig];
        
        [self addSubview:self.cover];
        [self addSubview:self.container];
        [self.container addSubview:self.titleLabel];
        [self.container addSubview:self.textView];

        self.cover.frame = self.bounds;
    }
    return self;
}


#pragma mark - event response
- (void)itemAction:(YJAlertItem *)sender
{
    if (sender.action.handler) {
        sender.action.handler(sender.action);
    }
    [self dismiss];
}

#pragma mark - public methods
- (void)addAction:(YJAlertAction *)action
{
    if (action) {
        [self.actions addObject:action];
    }
}

- (void)show
{
    [self bindDataAndLayoutViews];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [self showAnimations];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - private methods
- (void)bindDataAndLayoutViews
{
    // 总高
    CGFloat alertHeight = kTapItemHeight + kTapItemTopMargin;
    
    // 标题
    if (self.titleLabel.isHidden == NO) {
        alertHeight += (kTitleTopMargin + self.titleLabel.font.lineHeight);
        self.titleLabel.frame = CGRectMake(0, kTitleTopMargin, kAlertWidth, self.titleLabel.font.lineHeight);
    }
    
    // 文本内容
    if (self.textView.isHidden == NO) {
        NSAttributedString *attributeMessage = [self attributeMessage];
        self.textView.attributedText = attributeMessage;
        CGSize messageSize = [attributeMessage boundingRectWithSize:CGSizeMake(kAlertWidth-kAlertLefeRightMargin*2, CGFLOAT_MAX)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                            context:nil].size;
        alertHeight += (messageSize.height + kMessageTopMargin);
        
        if (self.titleLabel.isHidden == NO) {
            self.textView.frame = CGRectMake(kMessageLeftRightMargin,
                                             CGRectGetMaxY(self.titleLabel.frame)+kMessageTopMargin,
                                             kAlertWidth-kMessageLeftRightMargin*2,
                                             messageSize.height);
        } else {
            self.textView.frame = CGRectMake(kMessageLeftRightMargin,
                                             kMessageTopMargin,
                                             kAlertWidth-kMessageLeftRightMargin*2,
                                             messageSize.height);
        }
    }
    alertHeight = alertHeight > kAlertMaxHeight ? kAlertMaxHeight : alertHeight;
    self.container.frame = CGRectMake(0, 0, kAlertWidth, alertHeight);
    self.container.center = self.center;
    
    // 按钮
    CGFloat itemW = self.actions.count == 1 ? kAlertWidth : (kAlertWidth / 2.0);
    for (int i = 0; i < self.actions.count; i++) {
        YJAlertAction *action = self.actions[i];
        YJAlertItem *item = [YJAlertItem buttonWithType:UIButtonTypeCustom];
        [self.container addSubview:item];
        item.action = action;
        [item addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
        [item setTitle:action.title forState:UIControlStateNormal];

        // 默认的
        if (action.style == YJAlertActionStyleDefault) {
            [item setBackgroundColor:self.defaultItemBackgroundColor];
            [item setTitleColor:self.defaultItemTitleColor forState:UIControlStateNormal];
            item.titleLabel.font = self.defaultItemFont;
        }
        // 高亮的
        else if (action.style == YJAlertActionStyleHighlight) {
            [item setBackgroundColor:self.highlightItemBackgroundColor];
            [item setTitleColor:self.highlightItemTitleColor forState:UIControlStateNormal];
            item.titleLabel.font = self.highlightItemFont;
        }
        // 有图片
//        if (action.image) {
//            [item setImage:action.image forState:UIControlStateNormal];
//        }
        item.frame = CGRectMake(i*itemW, alertHeight-kTapItemHeight, itemW, kTapItemHeight);
    }
}

- (NSAttributedString *)attributeMessage
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 2;
    style.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSForegroundColorAttributeName:self.messageColor,
                                 NSFontAttributeName:self.messageFont,
                                 NSParagraphStyleAttributeName:style};
    NSAttributedString *attri = [[NSAttributedString alloc] initWithString:self.message attributes:attributes];
    return attri;
}

- (void)showAnimations
{
    self.container.transform = CGAffineTransformMakeScale(0.02, 0.02);
    self.alpha = 0;
    [UIView animateWithDuration:0.4f delay:0 usingSpringWithDamping:0.65 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.container.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [self.container layoutIfNeeded];
    }];
}

- (void)defaultConfig
{
    // 标题颜色/字体
    self.titleColor = [UIColor blackColor];
    self.titleFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    
    // 内容颜色/字体
    self.messageColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    self.messageFont = [UIFont fontWithName:@"PingFangSC-Medium" size:14];

    // 点击按钮外观设置
    self.defaultItemTitleColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0];
    self.defaultItemBackgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
    self.defaultItemFont  = [UIFont systemFontOfSize:16];
    self.highlightItemTitleColor = [UIColor colorWithRed:254.0/255.0 green:209.0/255.0 blue:0.0 alpha:1.0];
    self.highlightItemBackgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
    self.highlightItemFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
}


#pragma mark - setters
- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
    self.titleLabel.hidden = (title==nil || title.length<=0);
}

- (void)setMessage:(NSString *)message
{
    _message = message;
    self.textView.hidden = (message==nil || message.length<=0);
}


#pragma mark - getters
- (UIButton *)cover
{
    if (!_cover) {
        _cover = [UIButton buttonWithType:UIButtonTypeCustom];
        _cover.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.6];
    }
    return _cover;
}

- (UIView *)container
{
    if (!_container) {
        _container = [[UIView alloc] init];
        _container.layer.cornerRadius = kAlertCornerRadius;
        _container.clipsToBounds = YES;
        _container.backgroundColor = [UIColor whiteColor];
    }
    return _container;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = self.titleFont;
        _titleLabel.textColor = self.titleColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _textView.editable = NO;
        _textView.textColor = self.messageColor;
        _textView.font = self.messageFont;
    }
    return _textView;
}

- (NSMutableArray<YJAlertAction *> *)actions {
    if (!_actions) {
        _actions = @[].mutableCopy;
    }
    return _actions;
}

@end
