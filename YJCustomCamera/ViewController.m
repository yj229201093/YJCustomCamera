//
//  ViewController.m
//  YJCustomCamera
//
//  Created by gonghui on 2018/7/17.
//  Copyright © 2018年 YangJian. All rights reserved.
//

#import "ViewController.h"
#import "YJVideoController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)photograph:(id)sender {
    YJVideoController *videoC = [[YJVideoController alloc] init];
    videoC.takeBlock = ^(id item) {
        if ([item isKindOfClass:[NSURL class]]) {
            //视频url
            NSURL *videoURL = item;
            self.imageView.image = [self videoHandlePhoto:videoURL];
            
        } else {
            UIImage *image = item;
            self.imageView.image = image;
        }
    };
    [self presentViewController:videoC animated:YES completion:nil];
}



/**
 截图视频封面

 @param url 视频URL
 @return UIImage
 */
- (UIImage *)videoHandlePhoto:(NSURL *)url {
    AVURLAsset *urlSet = [AVURLAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlSet];
    imageGenerator.appliesPreferredTrackTransform = YES;    // 截图的时候调整到正确的方向
    NSError *error = nil;
    CMTime time = CMTimeMake(0,30); //缩略图创建时间 CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要获取某一秒的第几帧可以使用CMTimeMake方法)
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
    // 移除
    [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
    return image;
}
@end
