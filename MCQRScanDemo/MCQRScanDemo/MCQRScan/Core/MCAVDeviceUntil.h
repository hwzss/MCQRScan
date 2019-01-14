//
//  MCAVDeviceUntil.h
//  MC_Express
//
//  Created by kaifa on 2019/1/5.
//  Copyright © 2019 MC_MaoDou. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCAVDeviceUntil : NSObject

/**
 开启闪光灯
 */
+ (void)mc_openFlashlight;

/**
 关闭闪光灯
 */
+ (void)mc_closeFlashlight;

@end

NS_ASSUME_NONNULL_END
