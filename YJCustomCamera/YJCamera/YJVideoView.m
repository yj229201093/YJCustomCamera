//
//  YJVideoView.m
//  GHMetroSupervision
//
//  Created by 杨建 on 2018/4/26.
//  Copyright © 2018年 浙江工汇网络科技有限公司. All rights reserved.
//

#import "YJVideoView.h"
#import "YJProgressView.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "YJAVPlayer.h"
#import "Masonry.h"
#import "UIUtility.h"
#import "UtilsMacro.h"
//时间大于这个就是视频，否则为拍照
#define TimeMax 1

typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);
@interface YJVideoView()<AVCaptureFileOutputRecordingDelegate>

@property (nonatomic,strong) UIButton *switchCameraBtn; // 切换相机
@property (nonatomic,strong) UIButton *exitBtn; // 返回
@property (nonatomic,strong) UILabel *hintTitleLB; // 请出拍照，按住拍摄
@property (nonatomic,strong) UIImageView *photographImageView; // 拍照
@property (nonatomic,strong) YJProgressView *progressView;

@property (nonatomic,strong) UIView *finishView; // 完成后的视图
@property (nonatomic,strong) UIButton *afreshBtn; // 重新拍照
@property (nonatomic,strong) UIButton *confirmBtn; // 确定

//视频播放
@property (nonatomic,strong) YJAVPlayer *player;

//负责输入和输出设备之间的数据传递
@property(nonatomic)AVCaptureSession *session;
//负责从AVCaptureDevice获得输入数据
@property (strong,nonatomic) AVCaptureDeviceInput *captureDeviceInput;
//视频输出流
@property (strong,nonatomic) AVCaptureMovieFileOutput *captureMovieFileOutput;
//图像预览层，实时显示捕获的图像
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic,strong) UIImageView *bgView; // 背景
@property (strong, nonatomic) UIImageView *focusCursor; //聚焦光标

//后台任务标识
@property (assign,nonatomic) UIBackgroundTaskIdentifier backgroundTaskIdentifier;
@property (assign,nonatomic) UIBackgroundTaskIdentifier lastBackgroundTaskIdentifier;

//记录录制的时间 默认最大10秒
@property (assign, nonatomic) NSInteger seconds;
//记录需要保存视频的路径
@property (strong, nonatomic) NSURL *saveVideoUrl;
//是否在对焦
@property (assign, nonatomic) BOOL isFocus;
//是否是摄像 YES 代表是录制  NO 表示拍照
@property (assign, nonatomic) BOOL isVideo;

@property (nonatomic,strong) UIImage *takeImage;
@property (nonatomic,strong) UIImageView *takeImageView;


@end

@implementation YJVideoView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
//        if (self.yjSeconds == 0) {
//            self.yjSeconds = 10;
//        }
        [self setupCustomCamera];
    }
    return self;
}


/**
 添加视图
 */
- (void)setupSubviews {
    [self addSubview:self.bgView];
    [self addSubview:self.switchCameraBtn];
    [self addSubview:self.exitBtn];
    [self addSubview:self.progressView];
    [self addSubview:self.photographImageView];
    [self addSubview:self.hintTitleLB];
    [self addSubview:self.focusCursor];
    
    [self addSubview:self.finishView];
    [self.finishView addSubview:self.afreshBtn];
    [self.finishView addSubview:self.confirmBtn];
    
    [self.switchCameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(StatusBarHeight);
        make.right.equalTo(self).offset(-20);
        make.size.mas_offset(CGSizeMake(32, 26));
    }];
    
    [self.exitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(30);
        make.bottom.equalTo(self).offset(- (TabBarHeight - 9));
        make.size.mas_offset(CGSizeMake(36, 36));
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(- (TabBarHeight - 9));
        make.size.mas_offset(CGSizeMake(86, 86));
        make.centerX.equalTo(self);
    }];
    
    [self.photographImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.progressView);
        make.size.mas_offset(CGSizeMake(66, 66));
        make.centerX.equalTo(self.progressView);
    }];

    [self.hintTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.photographImageView.mas_top).offset(-20);
        make.centerX.equalTo(self);
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.finishView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(- (TabBarHeight - 9));
        make.centerX.equalTo(self);
        make.size.mas_offset(CGSizeMake(66+66+104, 66));
    }];
    
    [self.afreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.finishView).offset(0);
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.finishView).offset(0);
    }];
    
    
    [self performSelector:@selector(hiddenTipsLabel) withObject:nil afterDelay:4];
}


/**
 隐藏提示信息
 */
- (void)hiddenTipsLabel {
    self.hintTitleLB.hidden = YES;
}


/**
 设置自顶一下相机
 */
- (void)setupCustomCamera {
    //初始化会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc] init];
    //设置分辨率 (设备支持的最高分辨率)
    if ([self.session canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        self.session.sessionPreset = AVCaptureSessionPresetHigh;
    }
    //取得后置摄像头
    AVCaptureDevice *captureDevice = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
    //添加一个音频输入设备
    AVCaptureDevice *audioCaptureDevice=[[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    //初始化输入设备
    NSError *error = nil;
    self.captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    //添加音频
    error = nil;
    AVCaptureDeviceInput *audioCaptureDeviceInput = [[AVCaptureDeviceInput alloc]initWithDevice:audioCaptureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    
    //输出对象
    self.captureMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];//视频输出
    
    //将输入设备添加到会话
    if ([self.session canAddInput:self.captureDeviceInput]) {
        [self.session addInput:self.captureDeviceInput];
        [self.session addInput:audioCaptureDeviceInput];
        //设置视频防抖
        AVCaptureConnection *connection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([connection isVideoStabilizationSupported]) {
            connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeCinematic;
        }
    }
    
    //将输出设备添加到会话 (刚开始 是照片为输出对象)
    if ([self.session canAddOutput:self.captureMovieFileOutput]) {
        [self.session addOutput:self.captureMovieFileOutput];
    }
    
    //创建视频预览层，用于实时展示摄像头状态
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;//填充模式
    [self.bgView.layer addSublayer:self.previewLayer];
    
    [self addNotificationToCaptureDevice:captureDevice];
    [self addGenstureRecognizer];
}

#pragma mark - 视频输出代理 AVCaptureFileOutputRecordingDelegate
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections{
    NSLog(@"开始录制...");
    self.seconds = self.yjSeconds;
    [self performSelector:@selector(onStartTranscribe:) withObject:fileURL afterDelay:1.0];
}


- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    NSLog(@"视频录制完成.");
    [self changeViewLayout];
    if (self.isVideo) {
        self.saveVideoUrl = outputFileURL;
        if (!self.player) {
            self.player = [[YJAVPlayer alloc] initWithFrame:self.bgView.bounds withShowInView:self.bgView url:outputFileURL];
        } else {
            if (outputFileURL) {
                self.player.videoUrl = outputFileURL;
                self.player.hidden = NO;
            }
        }
    } else {
        //照片
        self.saveVideoUrl = nil;
        [self videoHandlePhoto:outputFileURL];
    }
}

- (void)videoHandlePhoto:(NSURL *)url {
    AVURLAsset *urlSet = [AVURLAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlSet];
    imageGenerator.appliesPreferredTrackTransform = YES;    // 截图的时候调整到正确的方向
    NSError *error = nil;
    CMTime time = CMTimeMake(0,30);//缩略图创建时间 CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要获取某一秒的第几帧可以使用CMTimeMake方法)
    CMTime actucalTime; //缩略图实际生成的时间
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:&actucalTime error:&error];
    if (error) {
        NSLog(@"截取视频图片失败:%@",error.localizedDescription);
    }
    CMTimeShow(actucalTime);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    if (image) {
        NSLog(@"视频截取成功");
    } else {
        NSLog(@"视频截取失败");
    }
    
    
    self.takeImage = image;//[UIImage imageWithCGImage:cgImage];
    
    [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
    
    if (!self.takeImageView) {
        self.takeImageView = [[UIImageView alloc] initWithFrame:self.frame];
        [self.bgView addSubview:self.takeImageView];
    }
    self.takeImageView.hidden = NO;
    self.takeImageView.image = self.takeImage;
}


- (void)onStartTranscribe:(NSURL *)fileURL {
    if ([self.captureMovieFileOutput isRecording]) {
        -- self.seconds;
        if (self.seconds > 0) {
            NSLog(@"%ld", self.seconds);
            if (self.yjSeconds - self.seconds >= TimeMax && !self.isVideo) {
                self.isVideo = YES; // 长按时间超过TimeMax 表示是视频录制
                self.progressView.timeMax = self.seconds;
            }
            [self performSelector:@selector(onStartTranscribe:) withObject:fileURL afterDelay:1.0];
        } else {
            if ([self.captureMovieFileOutput isRecording]) {
                [self.captureMovieFileOutput stopRecording];
            }
        }
    }
}


/**
 拍照或者拍摄完成改变UI
 */
- (void)changeViewLayout {
    self.exitBtn.hidden = YES;
    self.switchCameraBtn.hidden = YES;
    self.photographImageView.hidden = YES;
    self.finishView.hidden = NO;
    
    if (self.isVideo) {
        [self.progressView clearProgress];
    }
    // 更新界面
    
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];
    
    self.lastBackgroundTaskIdentifier = self.backgroundTaskIdentifier;
    self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    [self.session stopRunning];
}


/**
 重新调用界面时
 */
- (void)recoverViewLayout {
    if (self.isVideo) {
        self.isVideo = NO;
        [self.player stopPlayer];
        self.player.hidden = YES;
    }
    
    [self.session startRunning];
    
    if (!self.takeImageView.hidden) {
        self.takeImageView.hidden = YES;
    }
    
    self.exitBtn.hidden = NO;
    self.switchCameraBtn.hidden = NO;
    self.photographImageView.hidden = NO;
    self.finishView.hidden = YES;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
    }];
    
}
#pragma mark - 交互事件

/**
 切换相机
 */
- (void)switchCamera {
    NSLog(@"切换相机");
    [self setSwicthCamera];
}

/**
 退出相机
 */
- (void)eixtCamera {
    NSLog(@"退出相机");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(goBack)]) {
        [self.delegate goBack];
    }
    [self stopSession];
}


/**
 确定 保存到相册
 */
- (void)confirmAction {
    NSLog(@"确定");
    if (self.saveVideoUrl) {
        WeakSelf
        ALAssetsLibrary *assetsLibrary=[[ALAssetsLibrary alloc]init];
        [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:self.saveVideoUrl completionBlock:^(NSURL *assetURL, NSError *error) {
            NSLog(@"outputUrl:%@",weakSelf.saveVideoUrl);
//            [[NSFileManager defaultManager] removeItemAtURL:weakSelf.saveVideoUrl error:nil];
            if (weakSelf.lastBackgroundTaskIdentifier!= UIBackgroundTaskInvalid) {
                [[UIApplication sharedApplication] endBackgroundTask:weakSelf.lastBackgroundTaskIdentifier];
            }
            if (error) {
                NSLog(@"保存视频到相簿过程中发生错误，错误信息：%@",error.localizedDescription);
            } else {
                NSLog(@"成功保存视频到相簿.");
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(clickFinishWithImageData:isVideo:)]) {
                    [weakSelf.delegate clickFinishWithImageData:self.saveVideoUrl isVideo:YES];
                }
                [weakSelf eixtCamera];
            }
        }];
    } else {
        //照片
        UIImageWriteToSavedPhotosAlbum(self.takeImage, self, nil, nil);
        if (self.delegate && [self.delegate respondsToSelector:@selector(clickFinishWithImageData:isVideo:)]) {
            [self.delegate clickFinishWithImageData:self.takeImage isVideo:NO];
        }
        [self eixtCamera];
    }
}

/**
 重新拍照
 */
- (void)afreshAcyion {
    NSLog(@"重新拍照");
    [self recoverViewLayout];
}


#pragma mark - 懒加载
- (UIButton *)switchCameraBtn {
    if (!_switchCameraBtn) {
        _switchCameraBtn = [UIUtility initButtonWithImageName:@"switchover" target:self action:@selector(switchCamera)];
    }
    return _switchCameraBtn;
}

- (UIButton *)exitBtn {
    if (!_exitBtn) {
        _exitBtn = [UIUtility initButtonWithImageName:@"backDown" target:self action:@selector(eixtCamera)];
    }
    return _exitBtn;
}

- (UIImageView *)photographImageView {
    if (!_photographImageView) {
        _photographImageView = [UIUtility initImageViewWithImageName:@"photographBtn"];
        _photographImageView.userInteractionEnabled = YES;
    }
    return _photographImageView;
}

- (UILabel *)hintTitleLB {
    if (!_hintTitleLB) {
        _hintTitleLB = [UIUtility initLabelWithText:@"轻触拍照，按住摄像" fontSize:FontSize15 color:APP_WHITE textAlignment:NSTextAlignmentCenter];
    }
    return _hintTitleLB;
}

- (YJProgressView *)progressView {
    if (!_progressView) {
        _progressView = [YJProgressView new];
        _progressView.backgroundColor = APP_CLEARCOLOR;
        _progressView.layer.masksToBounds = YES;
        _progressView.layer.cornerRadius = self.progressView.frame.size.width/2;
    }
    return _progressView;
}

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [UIUtility initImageViewWithImageName:@""];
        _bgView.userInteractionEnabled = YES;
    }
    return _bgView;
}

- (UIView *)finishView {
    if (!_finishView) {
        _finishView = [UIUtility initViewWithBackgroundColor:APP_CLEARCOLOR];
        _finishView.hidden = YES;
    }
    return _finishView;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [UIUtility initButtonWithImageName:@"photographConfrim" target:self action:@selector(confirmAction)];
    }
    return _confirmBtn;
}


- (UIButton *)afreshBtn {
    if (!_afreshBtn) {
        _afreshBtn = [UIUtility initButtonWithImageName:@"photographBack" target:self action:@selector(afreshAcyion)];
    }
    return _afreshBtn;
}

- (UIImageView *)focusCursor {
    if (!_focusCursor) {
        _focusCursor = [UIUtility initImageViewWithImageName:@"Group"];
//        _focusCursor.intrinsicContentSize = CGSizeMake(60, 60);
        _focusCursor.alpha = 0;
    }
    return _focusCursor;
}


#pragma mark - Touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([[touches anyObject] view] == self.photographImageView) {
        NSLog(@"点击了拍照按钮");
        //根据设备输出获得连接
        AVCaptureConnection *connection = [self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeAudio];
        //根据连接取得设备输出的数据
        if (![self.captureMovieFileOutput isRecording]) {
            //如果支持多任务则开始多任务
            if ([[UIDevice currentDevice] isMultitaskingSupported]) {
                self.backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
            }
            if (self.saveVideoUrl) {
                [[NSFileManager defaultManager] removeItemAtURL:self.saveVideoUrl error:nil];
            }
            
            //预览图层和视频方向保持一致
            connection.videoOrientation = [self.previewLayer connection].videoOrientation;
            NSString *outputFielPath=[NSTemporaryDirectory() stringByAppendingString:@"myMovie.mov"];
            NSLog(@"save path is :%@",outputFielPath);
            NSURL *fileUrl=[NSURL fileURLWithPath:outputFielPath];
            NSLog(@"fileUrl:%@",fileUrl);
            [self.captureMovieFileOutput startRecordingToOutputFileURL:fileUrl recordingDelegate:self];
        } else {
            [self.captureMovieFileOutput stopRecording];
        }
    }
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([[touches anyObject] view] == self.photographImageView) {
         NSLog(@"结束触摸");
        if (!self.isVideo) {
            [self performSelector:@selector(endRecord) withObject:nil afterDelay:0.3];
        } else {
            [self endRecord];
        }
    }
}

- (void)endRecord {
    [self.captureMovieFileOutput stopRecording];//停止录制
}

#pragma mark - 开放接口
/**
 开始会话
 */
- (void)startSession {
    NSLog(@"开始会话");
    [self.session startRunning];
}


/**
 停止会话
 */
- (void)stopSession {
    NSLog(@"停止会话");
    [self.session startRunning];
}
    
#pragma mark - 通知
/**
 移除通知
 
 @param captureDevice captureDevice
 */
-(void)removeNotificationFromCaptureDevice:(AVCaptureDevice *)captureDevice{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}

/**
 *  移除所有通知
 */
-(void)removeNotification{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

- (void)addNotificationToCaptureSession:(AVCaptureSession *)captureSession{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    //会话出错
    [notificationCenter addObserver:self selector:@selector(sessionRuntimeError:) name:AVCaptureSessionRuntimeErrorNotification object:captureSession];
}

/**
 *  设备连接成功
 *
 *  @param notification 通知对象
 */
-(void)deviceConnected:(NSNotification *)notification{
    NSLog(@"设备已连接...");
}
/**
 *  设备连接断开
 *
 *  @param notification 通知对象
 */
-(void)deviceDisconnected:(NSNotification *)notification{
    NSLog(@"设备已断开.");
}
/**
 *  捕获区域改变
 *
 *  @param notification 通知对象
 */
-(void)areaChange:(NSNotification *)notification{
    NSLog(@"捕获区域改变...");
}

/**
 *  会话出错
 *
 *  @param notification 通知对象
 */
-(void)sessionRuntimeError:(NSNotification *)notification{
    NSLog(@"会话发生错误.");
}


/**
 *  取得指定位置的摄像头
 *
 *  @param position 摄像头位置
 *
 *  @return 摄像头设备
 */
-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position] == position) {
            return camera;
        }
    }
    return nil;
}

/**
 *  给输入设备添加通知
 */
- (void)addNotificationToCaptureDevice:(AVCaptureDevice *)captureDevice{
    //注意添加区域改变捕获通知必须首先设置设备允许捕获
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        captureDevice.subjectAreaChangeMonitoringEnabled=YES;
    }];
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    //捕获区域发生改变
    [notificationCenter addObserver:self selector:@selector(areaChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}

/**
 *  改变设备属性的统一操作方法
 *
 *  @param propertyChange 属性改变操作
 */
- (void)changeDeviceProperty:(PropertyChangeBlock)propertyChange{
    AVCaptureDevice *captureDevice= [self.captureDeviceInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        //自动白平衡
        if ([captureDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
            [captureDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
        }
        //自动根据环境条件开启闪光灯
        if ([captureDevice isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [captureDevice setFlashMode:AVCaptureFlashModeAuto];
        }
        
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    }else{
        NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}

/**
 *  添加点按手势，点按时聚焦
 */
-(void)addGenstureRecognizer{
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];
    [self.bgView addGestureRecognizer:tapGesture];
}


-(void)tapScreen:(UITapGestureRecognizer *)tapGesture{
    if ([self.session isRunning]) {
        CGPoint point= [tapGesture locationInView:self.bgView];
        //将UI坐标转化为摄像头坐标
        CGPoint cameraPoint= [self.previewLayer captureDevicePointOfInterestForPoint:point];
        [self setFocusCursorWithPoint:point];
        [self focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposureMode:AVCaptureExposureModeContinuousAutoExposure atPoint:cameraPoint];
    }
}

/**
 *  设置聚焦光标位置
 *
 *  @param point 光标位置
 */
-(void)setFocusCursorWithPoint:(CGPoint)point{
    if (!self.isFocus) {
        self.isFocus = YES;
        self.focusCursor.center = point;
        self.focusCursor.transform = CGAffineTransformMakeScale(1.25, 1.25);
        self.focusCursor.alpha = 1.0;
        [UIView animateWithDuration:0.5 animations:^{
            self.focusCursor.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [self performSelector:@selector(onHiddenFocusCurSorAction) withObject:nil afterDelay:0.5];
        }];
    }
}

- (void)onHiddenFocusCurSorAction {
    self.focusCursor.alpha=0;
    self.isFocus = NO;
}

/**
 *  设置聚焦点
 *
 *  @param point 聚焦点
 */
-(void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
    }];
}

/**
 设置切换相机
 */
- (void)setSwicthCamera {
    AVCaptureDevice *currentDevice=[self.captureDeviceInput device];
    AVCaptureDevicePosition currentPosition=[currentDevice position];
    [self removeNotificationFromCaptureDevice:currentDevice];
    AVCaptureDevice *toChangeDevice;
    AVCaptureDevicePosition toChangePosition = AVCaptureDevicePositionFront;//前
    if (currentPosition == AVCaptureDevicePositionUnspecified || currentPosition == AVCaptureDevicePositionFront) {
        toChangePosition = AVCaptureDevicePositionBack;//后
    }
    toChangeDevice=[self getCameraDeviceWithPosition:toChangePosition];
    [self addNotificationToCaptureDevice:toChangeDevice];
    //获得要调整的设备输入对象
    AVCaptureDeviceInput *toChangeDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:toChangeDevice error:nil];
    
    //改变会话的配置前一定要先开启配置，配置完成后提交配置改变
    [self.session beginConfiguration];
    //移除原有输入对象
    [self.session removeInput:self.captureDeviceInput];
    //添加新的输入对象
    if ([self.session canAddInput:toChangeDeviceInput]) {
        [self.session addInput:toChangeDeviceInput];
        self.captureDeviceInput = toChangeDeviceInput;
    }
    //提交会话配置
    [self.session commitConfiguration];
}

@end
