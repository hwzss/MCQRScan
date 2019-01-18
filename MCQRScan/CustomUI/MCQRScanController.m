//
//  MCQRScanController.m
//  MC_Express
//
//  Created by kaifa on 2019/1/4.
//  Copyright © 2019 MC_MaoDou. All rights reserved.
//

#import "MCQRScanController.h"
#import "MCQRScaner.h"
#import "MCAVDeviceUntil.h"
#import "MCScanUIView.h"
#import "MCCustomScanView.h"

@interface MCQRScanController ()

@property (nonatomic, strong)  MCQRScaner *qrScaner;
@property (nonatomic, strong)  MCCustomScanView *scanView;

@end

@implementation MCQRScanController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeViews];
}

- (void)initializeViews {
    //输出流视图
    UIView *preview  = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:preview];
    
    CGFloat kScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat kScreenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat kW = kScreenWidth * 0.8;
    CGFloat kH = kW * 0.74;
    CGFloat kX = (kScreenWidth - kW) * 0.5;
    CGFloat kY = (kScreenHeight - kH) * 0.5 - 10;
    //构建扫描样式视图
    _scanView = [[MCCustomScanView alloc] initWithFrame:self.view.bounds];
    _scanView.scanRect = CGRectMake(kX, kY, kW, kH);
    _scanView.message = @"将二维码/条码放入框内，即可自动扫描";
    _scanView.animationImage = [UIImage imageNamed:@"scanLine"];
    _scanView.edgeColor = [UIColor whiteColor];
    _scanView.flashSwitchBlock = ^(BOOL open) {
        open? [MCAVDeviceUntil mc_openFlashlight] : [MCAVDeviceUntil mc_closeFlashlight];
    };
    
    [self.view addSubview:_scanView];
    
    //初始化扫描工具
    _qrScaner = [[MCQRScaner alloc] init];
    [_qrScaner addPreview:preview];
    [_qrScaner setScanRetangleRect:CGRectMake(kX, kY, kW, kH)];
    
    if (self.scanedBlcok) {
        [_qrScaner openCarmeraToScanQR:self.scanedBlcok];
    }else {
        [_qrScaner openCarmeraToScanQR:^(NSString * _Nonnull code) {
            NSLog(@"code: %@, scanedBlcok 为空", code);
        }];
    }
    
    __weak typeof(self) weakSelf = self;
    [_qrScaner monitorBrightness:^(CGFloat brightnessValue) {
        if (brightnessValue < 0) {
            [weakSelf.scanView showFlashSwitch:YES];
        }else {
            [weakSelf.scanView showFlashSwitch:NO];
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_qrScaner resumeScanQR];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_scanView startScanAnimation];
    [_qrScaner resumeScanQR];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_scanView stopScanAnimation];
    [_scanView showFlashSwitch:NO];
    [_qrScaner pauseScanQR];
}

@end
