//
//  UtilsMacro.h
//  GHMetroSupervision
//
//  Created by 杨建 on 2018/4/9.
//  Copyright © 2018年 浙江工汇网络科技有限公司. All rights reserved.
//

#ifndef UtilsMacro_h
#define UtilsMacro_h

//获取屏幕宽度与高度 导航栏 Tabbar 状态栏
#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define Iphone6ScaleWidth(R) (R) * (SCREEN_WIDTH/375.0) // 6的标准
#define Iphone6ScaleHeight(R) (R) * (SCREENH_HEIGHT/667.0)
#define RealValue(with)((with)*(KScreenWidth/375.0f)) //根据ip6的屏幕来拉伸
#define StatusBarHeight  (kIs_iPhoneX ? 44.0f : 20.0f)
#define TabBarHeight  (kIs_iPhoneX ? 83.0f : 49.0f)
#define NavigationHeigh (kIs_iPhoneX ? 88.0f : 64.0f)
#define NavigationAndTabBarHeigh (TabBarHeight + NavigationHeigh)
#define iPhoneXBottomHeight  (kIs_iPhoneX ? 34.0f : 0.0f)

// 机型判断
#define kIs_iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define kIs_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kIs_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kIs_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define kIs_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//颜色转换 十六进制 rgb 转换 随机颜色
#define ColorWithHexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)/255.0) green:((float)((rgbValue & 0xFF00) >> 8)/255.0) blue:((float)((rgbValue & 0xFF))/255.0) alpha:1.0]
#define ColorWithHexRGBA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)/255.0) green:((float)((rgbValue & 0xFF00) >> 8)/255.0) blue:((float)((rgbValue & 0xFF))/255.0) alpha:(a)]
#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]
#define GRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]


//常用系统字体大小 字体 粗体 系统 字体名称
#define FontSize12 kFontSize(12)
#define FontSize13 kFontSize(13)
#define FontSize14 kFontSize(14)
#define FontSize15 kFontSize(15)
#define FontSize16 kFontSize(16)
#define FontSize17 kFontSize(17)
#define FontSize18 kFontSize(18)
#define FontSize19 kFontSize(19)
#define FontSize20 kFontSize(20)

#define kBoldFontSize(value) [UIFont boldSystemFontOfSize:value]
#define kFontSize(value) [UIFont systemFontOfSize:value]
#define kFont(name,value) [UIFont fontWithName:(name)size:(value)]

// 统一颜色值
#define APP_MAIN_COLOR  RGBColor(2,200,169) // 主色调
#define BTN_YES_COLOR   ColorWithHexRGB(0x00a0e8) // 按钮可交互颜色
#define BTN_NO_COLOR    ColorWithHexRGB(0xbbbbbb) // 按钮不可交互颜色
#define APP_BACKGROUNDCOLOR  ColorWithHexRGB(0xeeeeee) // 背景颜色
#define APP_LINE_COLOR     ColorWithHexRGB(0xdedede) // 线条颜色
#define APP_NAVIGATIONBAR_TINTCOLOR ColorWithHexRGB(0xffffff) // 导航栏按钮颜色
#define APP_NAVIGATIONBAR_BARTINTCOLOR ColorWithHexRGB(0x56C5B2)// 导航栏背景颜色
#define APP_CELLBACKGROUNDCOLOR ColorWithHexRGB(0xf9f9f9) // cell背景颜色
#define APP_BLUE ColorWithHexRGB(0x00a0e8) // 蓝色
#define APP_RED ColorWithHexRGB(0xff4242) // 红色
#define APP_GREEN ColorWithHexRGB(0x32c981) // 绿色
#define APP_WHITE ColorWithHexRGB(0xffffff) // 白色
#define APP_GRAY ColorWithHexRGB(0xf2f2f2) // 灰色
#define APP_BLACK ColorWithHexRGB(0x333333) // 黑色
#define APP_AVATARLINECOLOR ColorWithHexRGB(0xdddddd) // 头像边框颜色
#define APP_CLEARCOLOR [UIColor clearColor] // 清空颜色


#define APPMainTextTwoColor ColorWithHexRGB(0x666666) // 主二文本颜色
#define APPMainTextColor ColorWithHexRGB(0x333333) // 主文本颜色
#define AppSubTextColor ColorWithHexRGB(0x9e9e9e) // 子文本颜色
#define APPTextHintColor ColorWithHexRGB(0xcccccc) // 文本提示颜色
#define AppOtherTextColor ColorWithHexRGB(0x999999) // 其他文本颜色
#define AppMinorityTextColor ColorWithHexRGB(0x8a8a8a) // 少数文本颜色



// 常用数值
#define BTN_CORNERRADIUS 24 // Button圆角值
#define VIEW_BORDERWIDTH 1 // 视图圆角的线宽度
#define VIEW_CORNERRADIUS 24 // View圆角值
#define BTN_HEIGHT 48 // 按钮 视图布局
#define BTN_LEFT_OFFSET 30
#define BTN_RIGHT_OFFSET -30

#define PHONELENGTH 11 // 手机号只能11位
#define CODENUMBERLENGTH 6 // 验证码长度最多4位
#define USERNAMELENGHT 6 // 姓名最多6位

// 视图圆角
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View圆角
#define ViewRadius(View,Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

// 字符串格式化
#define kString(number) [NSString stringWithFormat:@"%ld", number]


// 弱引用/强引用
#define WeakSelf __weak typeof(self) weakSelf = self;
#define StrongSelf __strong typeof(self) strongType = self;

// 获取通知 AppWindow 图片 版本号 判断字符串 数组 字段 是否为空
#define NotificationCenter [NSNotificationCenter defaultCenter]
#define UserDefaults [NSUserDefaults standardUserDefaults]
#define AppWindow   [UIApplication sharedApplication].delegate.window
#define GUIImageFor(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]
#define AppVersion  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO ) // 字符串是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)// 数组是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0) // 字典是否为空
// 获取系统版本
#define IOS_SYSTEM_V9 + RSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define IS_IOS7 ([[UIDevice currentDevice].systemVersion doubleValue]  >= 7.0)
#define IS_IOS8 ([[UIDevice currentDevice].systemVersion doubleValue]  >= 8.0)

// 自定义Log
#ifdef DEBUG // 处于开发阶段
#define YJLog(...) NSLog(__VA_ARGS__)
#else // 处于发布阶段
#define YJLog(...)
#endif

//GCD - 只执行一次
#define DISPATCH_ONCE(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);
//GCD - 在Main线程上运行
#define DISPATCH_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);
//GCD - 开启异步线程
#define DISPATCH_GLOBAL_QUEUE_DEFAULT(globalQueueBlock) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlocl);

// 请求code值
#define Code1 1

// 发布内容
#define kReleaseLineWidth 70
#define kReleaseLineHieght 2
#define kReleaseLineInterval 5

#define kSTopSpacing 10
#define kSLeftSpacing 15
#define kSContentHeight 190
#define kSDeadlineHeight 78
#define kSImageDataHeight 209
#define kSFeedbackHeight 90



#endif /* UtilsMacro_h */
