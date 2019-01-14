//
//  DemoScanVc.m
//  MCQRScanDemo
//
//  Created by kaifa on 2019/1/14.
//  Copyright © 2019 MC_MaoDou. All rights reserved.
//

#import "DemoScanVc.h"
#import "MCQRScaner.h"
#import "MCScanUIView.h"

@interface DemoScanVc ()

@property (nonatomic, strong)  MCQRScaner *qrScaner;
@property (nonatomic, strong)  MCScanUIView *scanView;

@end

@implementation DemoScanVc

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
    _scanView = [[MCScanUIView alloc] initWithFrame:self.view.bounds];
    _scanView.scanRect = CGRectMake(kX, kY, kW, kH);
    [self.view addSubview:_scanView];
    
    //初始化扫描工具
    _qrScaner = [[MCQRScaner alloc] init];
    [_qrScaner addPreview:preview];
    [_qrScaner setScanRetangleRect:CGRectMake(kX, kY, kW, kH)];
    

    [_qrScaner openCarmeraToScanQR:^(NSString * _Nonnull code) {
        NSLog(@"code: %@", code);
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_qrScaner resumeScanQR];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [_qrScaner resumeScanQR];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [_qrScaner pauseScanQR];
}

@end
