//
//  YJVideoView.h
//  GHMetroSupervision
//
//  Created by 杨建 on 2018/4/26.
//  Copyright © 2018年 浙江工汇网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YJVideoViewDelegate<NSObject>

// 返回
- (void)goBack;

/**
 点击完成返回影像资料

 @param imageData 影像资料
 @param isVideo YES 影像 NO 图片
 */
- (void)clickFinishWithImageData:(id)imageData isVideo:(BOOL)isVideo;

@end

@interface YJVideoView : UIView


@property (nonatomic,weak) id<YJVideoViewDelegate> delegate;

/**
 开始会话
 */
- (void)startSession;

/**
 停止会话
 */
- (void)stopSession;

@property (nonatomic,assign) NSInteger yjSeconds; // 录屏时长




@end
