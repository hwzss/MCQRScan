//
//  MCQRScaner.h
//  MC_Express
//
//  Created by kaifa on 2019/1/4.
//  Copyright © 2019 MC_MaoDou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MCQRScanerCompleteBlock)(NSString *code);
typedef void(^MCQRScanerMonitorBrightnessBlock)(CGFloat brightnessValue);

@interface MCQRScaner : NSObject

/**
 设置扫描识别区域的位置

 @param scanRect 位置，基于preView坐标系
 */
- (void)setScanRetangleRect:(CGRect )scanRect;

/**
 添加视频预览的view

 @param preview 预览view
 */
- (void)addPreview:(UIView *)preview;

/**
 开启二维码扫描

 @param complete 扫描到二维码的回调
 */
- (void)openCarmeraToScanQR:(MCQRScanerCompleteBlock )complete;

/**
 从图片中识别二维码

 @param image 二维码图
 */
- (NSString *)scanQRFromImage:(UIImage *)image;

/**
 开启亮度检测

 @param monitorBlock 检测回调，可用于环境比较暗的时候开启闪光灯
 */
- (void)monitorBrightness:(MCQRScanerMonitorBrightnessBlock )monitorBlock;

/**
 暂停二维码扫描
 */
- (void)pauseScanQR;

/**
 继续二维码扫描
 */
- (void)resumeScanQR;

@end

NS_ASSUME_NONNULL_END
