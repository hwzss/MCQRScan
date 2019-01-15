//
//  EXPScanView.h
//  MC_Express
//
//  Created by kaifa on 2019/1/14.
//  Copyright © 2019 MC_MaoDou. All rights reserved.
//

#import "MCScanUIView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^MCCustomScanViewFlashStateChangeBlock)(BOOL open);

@interface MCCustomScanView : MCScanUIView

/**
 打开/关闭闪光灯的回调
 */
@property (nonatomic,copy) MCCustomScanViewFlashStateChangeBlock flashSwitchBlock;


/**
 *  扫描动画效果的图片
 */
@property (nonatomic, strong) UIImage * animationImage;

/**
 提示语
 */
@property (nonatomic, copy) NSString *message;

/**
 *  开始扫描动画
 */
- (void)startScanAnimation;

/**
 *  结束扫描动画
 */
- (void)stopScanAnimation;

/**
 是否显示闪光灯开关
 */
- (void)showFlashSwitch:(BOOL)show;
@end

NS_ASSUME_NONNULL_END
