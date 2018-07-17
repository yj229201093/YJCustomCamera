//
//  YJVideoController.h
//  GHMetroSupervision
//
//  Created by 杨建 on 2018/4/26.
//  Copyright © 2018年 浙江工汇网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TakeOperationSureBlock)(id item);

@interface YJVideoController : UIViewController

@property (copy, nonatomic) TakeOperationSureBlock takeBlock;
@property (nonatomic,assign) BOOL photographFlag; // 拍照标识 不可录像

@end
