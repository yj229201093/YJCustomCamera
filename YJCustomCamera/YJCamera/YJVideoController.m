//
//  YJVideoController.m
//  GHMetroSupervision
//
//  Created by 杨建 on 2018/4/26.
//  Copyright © 2018年 浙江工汇网络科技有限公司. All rights reserved.
//

#import "YJVideoController.h"
#import "YJVideoView.h"

#define WeakSelf __weak typeof(self) weakSelf = self;

@interface YJVideoController ()<YJVideoViewDelegate>
@property (nonatomic,strong) YJVideoView *yjVideoView;

@end

@implementation YJVideoController


#pragma mark - View Controller LifeCyle // 生命周期的方法

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.yjVideoView startSession];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.yjVideoView stopSession];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)loadView {
    self.view = self.yjVideoView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialData];
    
    if (_photographFlag) {
        _yjVideoView.yjSeconds = 0; // 0秒就只能拍照
    } else {
        _yjVideoView.yjSeconds = 10;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Override // 重载父类的方法

#pragma mark - Initial Methods // 初始化的方法

- (void)initialData
{
    self.title = @"";
}


#pragma mark - Target Methods // 点击事件

/**
 返回
 */
- (void)goBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickFinishWithImageData:(id)imageData isVideo:(BOOL)isVideo {
    if (isVideo) {
        NSLog(@"回传视频");
        WeakSelf
        if (weakSelf.takeBlock) {
            weakSelf.takeBlock(imageData);
        }
    } else {
        NSLog(@"回传图片");
        WeakSelf
        if (weakSelf.takeBlock) {
            weakSelf.takeBlock(imageData);
        }
    }
}

#pragma mark - Delegate // 代理


#pragma mark - NetworkRequest // 网络请求


#pragma mark - Setter Getter Methods //  懒加载 setter Or getter
- (YJVideoView *)yjVideoView {
    if (!_yjVideoView) {
        _yjVideoView = [YJVideoView new];
        _yjVideoView.delegate = self;
    }
    return _yjVideoView;
}

#pragma mark - Notification Methods //通知事件


#pragma mark - Privater Methods // 私有方法(尽量抽取在公共类)

@end
