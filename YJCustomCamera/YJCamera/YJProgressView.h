//
//  YJProgressView.h
//  GHMetroSupervision
//
//  Created by 杨建 on 2018/4/26.
//  Copyright © 2018年 浙江工汇网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJProgressView : UIView

@property (assign, nonatomic) NSInteger timeMax;

- (void)clearProgress;

@end
