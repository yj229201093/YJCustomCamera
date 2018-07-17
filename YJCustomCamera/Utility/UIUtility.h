//
//  UIUtility.h
//  GHMetroSupervision
//
//  Created by 杨建 on 2018/4/13.
//  Copyright © 2018年 浙江工汇网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIUtility : NSObject


#pragma mark - UIView

/**
 返回View

 @return view
 */
+ (UIView *)initView;

/**
 返回view
 
 @param backgroundColor backgroundColor
 @return UIview
 */
+ (UIView *)initViewWithBackgroundColor:(UIColor *)backgroundColor;

/**
 按钮视图
 
 @param backgroundColor backgroundColor
 @param frame frame
 @param title title
 @param target target
 @param action action
 @return 按钮视图
 */
+ (UIView *)initCommonButtonViewWithBackgroundColor:(UIColor *)backgroundColor frmae:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action;

#pragma mark - UILabel
/**
 返回UILabel
 
 @param text text
 @param fontSize fontSize
 @param color color
 @return UILabel
 */
+ (UILabel *)initLabelWithText:(NSString *)text fontSize:(UIFont *)fontSize color:(UIColor *)color;

/**
 返回UILabel
 
 @param text text
 @param fontSize fontSize
 @param color color
 @param textAlignment textAlignment
 @return UILabel
 */
+ (UILabel *)initLabelWithText:(NSString *)text fontSize:(UIFont *)fontSize color:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment;

#pragma mark - UIButton
/**
 返回常用按钮 固定颜色 字体 大小
 
 @param title title
 @param target target
 @param action action
 @return 返回按钮
 */
+ (UIButton *)initCommonButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;

/**
 返回按钮自定义背景颜色 字体颜色 大小
 
 @param title title
 @param target target
 @param action action
 @return 返回按钮
 */
+ (UIButton *)initButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor font:(UIFont *)font target:(id)target action:(SEL)action;

/**
 返回按钮
 
 @param title title
 @param target target
 @param action action
 @return 返回按钮
 */
+ (UIButton *)initButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;

/**
 返回按钮 固定颜色 字体 大小
 
 @param imageName imageName
 @return 返回按钮
 */
+ (UIButton *)initButtonWithImageName:(NSString *)imageName;

/**
 返回按钮
 
 @param imageName imageName
 @param target target
 @param action action
 @return 返回按钮
 */
+ (UIButton *)initButtonWithImageName:(NSString *)imageName target:(id)target action:(SEL)action;


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
+ (UIButton *)initButtonWithTitle:(NSString *)title imageName:(NSString *)imageName titleColor:(UIColor *)titleColor font:(UIFont *)font target:(id)target action:(SEL)action;

/**
 设置左文字右图片
 
 @param button button
 @param title title
 @param imageName imageName
 @param interval interval
 */
+ (void)setupLeftTextRightImageWithButton:(UIButton *)button title:(NSString *)title imageName:(NSString *)imageName interval:(NSInteger)interval;

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
+ (void)setupLeftTextRightImageWithButton:(UIButton *)button title:(NSString *)title imageName:(NSString *)imageName backgroundColor:(UIColor *)backgroundColor titleColor:(UIColor *)titleColor font:(UIFont *)font interval:(NSInteger)interval;

/**
 设置按钮文字下图片上
 
 @param button button
 */
+ (void)setButtonTitleDownImageUpWith:(UIButton *)button;
#pragma mark - UITextField
/**
 返回textFile
 
 @param placeholder placeholder
 @param placeholderColor placeholderColor
 @param font font
 @return return UITextField
 */
+ (UITextField *)initTextFieldWithPlaceholder:(NSString *)placeholder placeholderColor:(UIColor *)placeholderColor font:(UIFont *)font;


#pragma mark - UITableView
/**
 返回tableView
 
 @param tableViewStyle tableViewStyle
 @param rowHeight rowHeight
 @param delegate delegate
 @return UITableView
 */
+ (UITableView *)initTableViewWithTableViewStyle:(UITableViewStyle)tableViewStyle rowHeight:(CGFloat)rowHeight delegate:(id)delegate;

/**
 设置tableView分割线不显示
 
 @param tableView tableView
 */
+ (void)setTableViewCellEditingStyleNone:(UITableView *)tableView;

/**
 设置tableViewCell不可点击
 
 @param cell cell
 */
+ (void)setTableViewCellSelectionStyle:(UITableViewCell *)cell;

#pragma mark - UITextView
/**
 初始化UITextView
 
 @param textColor textColor
 @param font font
 @param placeholder placeholder
 @return UITextView
 */
+ (UITextView *)initTextViewWithTextColor:(UIColor *)textColor font:(UIFont *)font placeholder:(NSString *)placeholder;

/**
 设置TextViewplaceholder文本
 
 @param textView textView
 @param placeholder placeholder
 @param font font
 */
+ (void)setupRemarkplaceHolderWithTextView:(UITextView *)textView placeholder:(NSString *)placeholder font:(UIFont *)font;

#pragma mark - UIImageView
/**
 初始化视图
 
 @param imageName imageName
 @return UIImageView
 */
+ (UIImageView *)initImageViewWithImageName:(NSString *)imageName;

@end
