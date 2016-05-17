//
//  CodeScanViewController.m
//  Purchase
//
//  Created by luoheng on 16/5/5.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "CodeScanViewController.h"
#import "ZXingObjC.h"
#import "NSTimer+EOCBlocksSupport.h"
#import <AVFoundation/AVFoundation.h>

static const float LineHeight = 4;
static const float SpaceLeft = 40;
static const float SpaceTop = 80;
static const float ScanHight = 250;

@interface CodeScanViewController ()<ZXCaptureDelegate>

@property (nonatomic, strong) ZXCapture   *capture;
@property (nonatomic, strong) UIView      *scanRectView;//扫描区域
@property (nonatomic, strong) UILabel     *tipLabel;//扫描提示
@property (nonatomic, strong) UIImageView *line;
@property (nonatomic, strong) NSTimer     *timer;
@property (nonatomic, assign) BOOL        isDown;
@property (nonatomic, assign) NSInteger   num;//计时次数

@end

@implementation CodeScanViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //定时器
    if (self.timer) {
        [self.timer invalidate];
    }
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer eoc_scheduledTimerWithTimeInterval:0.04 block:^{
        [weakSelf scanAnimation];
    } repeats:YES];
    self.line.hidden = NO;
    [self.capture start];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (self.timer) {
        [self.timer invalidate];
    }
    [self.capture stop];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"扫一扫", @"扫一扫");
    self.isDown = NO;
    self.num = 0;
    
    [self.view.layer addSublayer:self.capture.layer];
    [self.view addSubview:self.scanRectView];
    [self.scanRectView addSubview:self.line];
    [self.view addSubview:self.tipLabel];
    
    NSString * mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
        [UIAlertView showWithTitle:NSLocalizedString(@"请在“设置-隐私-相机“选项中,允许C-Life访问你的相机", @"请在“设置-隐私-相机“选项中,允许C-Life访问你的相机")
                           message:nil
                 cancelButtonTitle:NSLocalizedString(@"知道了", @"知道了")
                 otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                 }];
    }
}
-(void)scanAnimation
{
    if (self.isDown == NO) {
        self.num ++;
        self.line.frame = CGRectMake(0, LineHeight*self.num, self.scanRectView.frame.size.width, LineHeight);
        if (LineHeight*self.num >= self.scanRectView.frame.size.height) {
            self.isDown = YES;
        }
    }else {
        self.num --;
        self.line.frame = CGRectMake(0, LineHeight*self.num, self.scanRectView.frame.size.width, LineHeight);
        if (self.num == 0) {
            self.isDown = NO;
        }
    }
}
#pragma mark ----ZXCaptureDelegate Methods---
- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
    NSString * resultStr = result.text;
    NSLog(@"scan resultStr %@",resultStr);
    if (!result)
        return;
    else{
        [self.timer invalidate];
        self.line.hidden = YES;
        [self.capture stop];
        
        __weak typeof(self) weakSelf = self;
        [UIAlertView showWithTitle:NSLocalizedString(@"条码信息", @"条码信息")
                           message:SAFE_STRING(resultStr)
                 cancelButtonTitle:NSLocalizedString(@"取消", @"取消")
                 otherButtonTitles:@[NSLocalizedString(@"保存", @"保存")]
                          tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                              if (buttonIndex == 1) {
                                  if (weakSelf.sendTheCode) {
                                      weakSelf.sendTheCode(SAFE_STRING(resultStr));
                                  }
                                  [self.navigationController popViewControllerAnimated:YES];
                              }else{
                                  weakSelf.timer = [NSTimer eoc_scheduledTimerWithTimeInterval:0.04 block:^{
                                      [weakSelf scanAnimation];
                                  } repeats:YES];
                                  weakSelf.line.hidden = NO;
                                  [weakSelf.capture start];
                              }
     }];
    }
}
#pragma mark - Set && Get
- (UIImageView *)line{
    if (!_line) {
        _line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.scanRectView.frame.size.width, LineHeight)];
        _line.image = [UIImage imageNamed:@"scanLine"];
    }
    return _line;
}
- (ZXCapture *)capture{
    if (!_capture) {
        _capture = [[ZXCapture alloc] init];
        _capture.camera = _capture.back;
        _capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
        _capture.delegate = self;
        [_capture setRotation:90];
        _capture.layer.frame = self.view.frame;
        _capture.scanRect = CGRectMake(SpaceLeft*SizeScaleWidth, SpaceTop*SizeScaleHeight, ScreenWidth-2*SpaceLeft*SizeScaleWidth, ScanHight*SizeScaleHeight);
    }
    return _capture;
}
- (UIView *)scanRectView{
    if (!_scanRectView) {
        _scanRectView = [[UIView alloc]initWithFrame:CGRectMake(SpaceLeft*SizeScaleWidth, SpaceTop*SizeScaleHeight, ScreenWidth-2*SpaceLeft*SizeScaleWidth, ScanHight*SizeScaleHeight)];
        _scanRectView.backgroundColor = [UIColor clearColor];
        
        UIImageView * framer = [[UIImageView alloc] initWithFrame:_scanRectView.bounds];
        [framer setImage:[UIImage imageNamed:@"scanFrame"]];
        [_scanRectView addSubview:framer];
    }
    return _scanRectView;
}
- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,SpaceTop*SizeScaleHeight+ScanHight*SizeScaleHeight+20, ScreenWidth, 20)];
        _tipLabel.backgroundColor = [UIColor clearColor];
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.font = [UIFont customFontOfSize:14];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.text = NSLocalizedString(@"请将二维码或条码放入框内", @"请将二维码或条码放入框内");
    }
    return _tipLabel;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
