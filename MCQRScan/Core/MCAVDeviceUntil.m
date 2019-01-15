//
//  MCAVDeviceUntil.m
//  MC_Express
//
//  Created by kaifa on 2019/1/5.
//  Copyright © 2019 MC_MaoDou. All rights reserved.
//

#import "MCAVDeviceUntil.h"
#import <AVFoundation/AVFoundation.h>


@implementation MCAVDeviceUntil

+ (void)mc_openFlashlight {
    [self flashlightSwitch:YES];
}

+ (void)mc_closeFlashlight {
    [self flashlightSwitch:NO];
}

+ (void)flashlightSwitch:(BOOL) on {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!device && ![device hasFlash] && ![device hasTorch]) return;
    
    [device lockForConfiguration:nil];
    device.torchMode = on? AVCaptureTorchModeOn : AVCaptureTorchModeOff;
    device.flashMode = on? AVCaptureFlashModeOn : AVCaptureFlashModeOff;
    [device unlockForConfiguration];
}

@end
