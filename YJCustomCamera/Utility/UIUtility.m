//
//  UIUtility.m
//  GHMetroSupervision
//
//  Created by 杨建 on 2018/4/13.
//  Copyright © 2018年 浙江工汇网络科技有限公司. All rights reserved.
//

#import "UIUtility.h"
#import "UtilsMacro.h"
@implementation UIUtility
#pragma mark - UIView

+ (UIView *)initView {
    return [UIView new];
}

/**
 返回view

 @param backgroundColor backgroundColor
 @return UIview
 */
+ (UIView *)initViewWithBackgroundColor:(UIColor *)backgroundColor {
    UIView *view = [UIView new];
    view.backgroundColor = backgroundColor;
    return view;
}


/**
 按钮视图

 @param backgroundColor backgroundColor
 @param frame frame
 @param title title
 @param target target
 @param action action
 @return 按钮视图
 */
+ (UIView *)initCommonButtonViewWithBackgroundColor:(UIColor *)backgroundColor frmae:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = backgroundColor;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(BTN_LEFT_OFFSET, 20, SCREEN_WIDTH - BTN_LEFT_OFFSET *2, BTN_HEIGHT);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    button.backgroundColor = APP_BLUE;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    ViewRadius(button, BTN_CORNERRADIUS);
    [view addSubview:button];
    return view;
}


#pragma mark - UILabel
/**
 返回UILabel

 @param text text
 @param fontSize fontSize
 @param color color
 @return UILabel
 */
+ (UILabel *)initLabelWithText:(NSString *)text fontSize:(UIFont *)fontSize color:(UIColor *)color {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = fontSize;
    label.textColor = color;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

/**
 返回UILabel
 
 @param text text
 @param fontSize fontSize
 @param color color
 @param textAlignment textAlignment
 @return UILabel
 */
+ (UILabel *)initLabelWithText:(NSString *)text fontSize:(UIFont *)fontSize color:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = fontSize;
    label.textColor = color;
    label.textAlignment = textAlignment;
    return label;
}

#pragma mark - UIButton
/**
 返回常用交互按钮 固定颜色 字体 大小
 
 @param title title
 @param target target
 @param action action
 @return 返回按钮
 */
+ (UIButton *)initCommonButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:APP_WHITE forState:UIControlStateNormal];
    button.titleLabel.font = FontSize18;
    button.backgroundColor = APP_BLUE;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    ViewRadius(button, BTN_CORNERRADIUS);
    return button;
}

/**
 返回按钮自定义背景颜色 字体颜色 大小
 
 @param title title
 @param target target
 @param action action
 @return 返回按钮
 */
+ (UIButton *)initButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor font:(UIFont *)font target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.font = font;
    button.backgroundColor = backgroundColor;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}


/**
 返回按钮 固定颜色 字体 大小

 @param title title
 @param target target
 @param action action
 @return 返回按钮
 */
+ (UIButton *)initButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:APP_BLUE forState:UIControlStateNormal];
    button.titleLabel.font = FontSize16;
    button.backgroundColor = APP_WHITE;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}


/**
 返回按钮 固定颜色 字体 大小
 
 @param imageName imageName
 @return 返回按钮
 */
+ (UIButton *)initButtonWithImageName:(NSString *)imageName {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:GUIImageFor(imageName) forState:UIControlStateNormal];
    button.userInteractionEnabled = NO;
    return button;
}

/**
 返回按钮
 
 @param imageName imageName
 @param target target
 @param action action
 @return 返回按钮
 */
+ (UIButton *)initButtonWithImageName:(NSString *)imageName target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:GUIImageFor(imageName) forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}


/**
 返回按钮 固定颜色 字体 大小

 @param title title
 @param imageName imageName
 @param titleColor titleColor
 @param font font
 @param target target
 @param action action
 @return UIButton
 */
+ (UIButton *)initButtonWithTitle:(NSString *)title imageName:(NSString *)imageName titleColor:(UIColor *)titleColor font:(UIFont *)font target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.font = font;
    button.backgroundColor = APP_WHITE;
    [button setImage:GUIImageFor(imageName) forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}


/**
 设置左文字右图片
 
 @param button button
 @param title title
 @param imageName imageName
 @param interval interval
 */
+ (void)setupLeftTextRightImageWithButton:(UIButton *)button title:(NSString *)title imageName:(NSString *)imageName interval:(NSInteger)interval {
    UIImage *image = [UIImage imageNamed:imageName];
    [button setImage:image forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.titleLabel.backgroundColor = button.backgroundColor;
    button.imageView.backgroundColor = button.backgroundColor;
    //在使用一次titleLabel和imageView后才能正确获取titleSize
    CGSize titleSize = button.titleLabel.bounds.size;
    CGSize imageSize = button.imageView.bounds.size;
    button.backgroundColor = RGBColor(11, 70, 147);
    [button setTitleColor:APP_WHITE forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.imageEdgeInsets = UIEdgeInsetsMake(0,titleSize.width + interval, 0, -(titleSize.width + interval));
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageSize.width + interval), 0, imageSize.width + interval);
}


/**
 设置左文字右图片

 @param button button
 @param title title
 @param imageName imageName
 @param backgroundColor backgroundColor
 @param titleColor titleColor
 @param font font
 @param interval interval
 */
+ (void)setupLeftTextRightImageWithButton:(UIButton *)button title:(NSString *)title imageName:(NSString *)imageName backgroundColor:(UIColor *)backgroundColor titleColor:(UIColor *)titleColor font:(UIFont *)font interval:(NSInteger)interval {
    UIImage *image = [UIImage imageNamed:imageName];
    [button setImage:image forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    button.titleLabel.backgroundColor = button.backgroundColor;
    button.imageView.backgroundColor = button.backgroundColor;
    //在使用一次titleLabel和imageView后才能正确获取titleSize
    CGSize titleSize = button.titleLabel.bounds.size;
    CGSize imageSize = button.imageView.bounds.size;
    button.backgroundColor = backgroundColor;
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.imageEdgeInsets = UIEdgeInsetsMake(0,titleSize.width + interval, 0, -(titleSize.width + interval));
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageSize.width + interval), 0, imageSize.width + interval);
}

/**
 设置按钮文字下图片上
 
 @param button button
 */
+ (void)setButtonTitleDownImageUpWith:(UIButton *)button {
    CGFloat offset = 70.0f;
    CGSize titleSize = button.titleLabel.bounds.size;
    CGSize imageSize = button.imageView.bounds.size;
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, -imageSize.height-offset/2, 0);
    button.imageEdgeInsets = UIEdgeInsetsMake(-titleSize.height-offset/2, 0, 0, -titleSize.width);
}


#pragma mark - UITextField

/**
 返回textFile

 @param placeholder placeholder
 @param placeholderColor placeholderColor
 @param font font
 @return return UITextField
 */
+ (UITextField *)initTextFieldWithPlaceholder:(NSString *)placeholder placeholderColor:(UIColor *)placeholderColor font:(UIFont *)font {
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = placeholder;
    textField.textColor = APPMainTextColor;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.font = font;
    [textField setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
    [textField setValue:font forKeyPath:@"_placeholderLabel.font"];
    return textField;
}

#pragma mark - UITableView

/**
 返回tableView

 @param tableViewStyle tableViewStyle
 @param rowHeight rowHeight
 @param delegate delegate
 @return UITableView
 */
+ (UITableView *)initTableViewWithTableViewStyle:(UITableViewStyle)tableViewStyle rowHeight:(CGFloat)rowHeight delegate:(id)delegate {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT) style:tableViewStyle];
    tableView.rowHeight = rowHeight;
    tableView.dataSource = delegate;
    tableView.delegate = delegate;
    tableView.backgroundColor = APP_BACKGROUNDCOLOR;
    tableView.tableFooterView = [UIView new];
    return tableView;
}



/**
 设置tableView分割线不显示

 @param tableView tableView
 */
+ (void)setTableViewCellEditingStyleNone:(UITableView *)tableView {
    tableView.separatorStyle = UITableViewCellEditingStyleNone;
}

/**
 设置tableViewCell不可点击
 
 @param tableView tableView
 */
+ (void)setTableViewCellSelectionStyle:(UITableViewCell *)cell {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}


#pragma mark - UIImageView

/**
 初始化视图

 @param imageName imageName
 @return UIImageView
 */
+ (UIImageView *)initImageViewWithImageName:(NSString *)imageName {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = GUIImageFor(imageName);
    return imageView;
}

#pragma mark - UITextView

/**
 初始化UITextView

 @param textColor textColor
 @param font font
 @param placeholder placeholder
 @return UITextView
 */
+ (UITextView *)initTextViewWithTextColor:(UIColor *)textColor font:(UIFont *)font placeholder:(NSString *)placeholder {
    UITextView *textView = [UITextView new];
    textView.textColor = textColor;
    textView.font = font;
    [self setupRemarkplaceHolderWithTextView:textView placeholder:placeholder font:font];
    return textView;
}


/**
 设置TextViewplaceholder文本

 @param textView textView
 @param placeholder placeholder
 @param font font
 */
+ (void)setupRemarkplaceHolderWithTextView:(UITextView *)textView placeholder:(NSString *)placeholder font:(UIFont *)font {
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = placeholder;
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = AppOtherTextColor;
    placeHolderLabel.font = font;
    [placeHolderLabel sizeToFit];
    [textView addSubview:placeHolderLabel];
    [textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
}
@end
