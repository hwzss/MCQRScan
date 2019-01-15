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

- (void)setScanRetangleRect:(CGRect )scanRect;
- (void)addPreview:(UIView *)preview;
- (void)openCarmeraToScanQR:(MCQRScanerCompleteBlock )complete;
- (void)scanQRFromImage:(UIImage *)image;

- (void)monitorBrightness:(MCQRScanerMonitorBrightnessBlock )monitorBlock;

- (void)pauseScanQR;
- (void)resumeScanQR;

@end

NS_ASSUME_NONNULL_END
