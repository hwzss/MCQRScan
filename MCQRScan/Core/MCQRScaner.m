//
//  MCQRScaner.m
//  MC_Express
//
//  Created by kaifa on 2019/1/4.
//  Copyright © 2019 MC_MaoDou. All rights reserved.
//

#import "MCQRScaner.h"
#import <AVFoundation/AVFoundation.h>

typedef enum : NSUInteger {
    MCQRScanerStateScaning,
    MCQRScanerStatePause,
    MCQRScanerStateUnknow,
} MCQRScanerState;

@interface MCQRScaner ()<AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureSession *avSession;
@property (nonatomic, strong) AVCaptureDeviceInput *avInput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *aVideoIOutput;
@property (nonatomic, strong) AVCaptureMetadataOutput *avMetaDataOutput;

@property (nonatomic, strong) dispatch_queue_t qrSerialQueue;
@property (nonatomic, copy) MCQRScanerCompleteBlock scanCompleteBlock;
@property (nonatomic, copy) MCQRScanerMonitorBrightnessBlock monitorBrightnessBlock;

@property (nonatomic, weak) UIView *preview;
@property (nonatomic, weak) AVCaptureVideoPreviewLayer *avPreviewLayer;
@property (nonatomic, assign) CGRect scanRect;

@property (nonatomic, assign) MCQRScanerState scanState;
@end

@implementation MCQRScaner

- (instancetype)init {
    self = [super init];
    if (self) {
        _qrSerialQueue = dispatch_queue_create("mc.qrscanner.queue", DISPATCH_QUEUE_SERIAL);
        _scanRect = CGRectZero;
        _scanState = MCQRScanerStateUnknow;
    }
    return self;
}

- (void)openCarmeraToScanQR:(MCQRScanerCompleteBlock )complete {
    self.scanCompleteBlock = complete;
    
    // init capturesession
    if (!_avSession) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        _avInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
        if(!_avInput) {
#ifdef DEBUG
            @throw [NSException exceptionWithName:@"openCarmeraToScanQR:complete" reason:@"device init failed" userInfo:nil];
#endif
            return;
        }
        
        _avMetaDataOutput = [[AVCaptureMetadataOutput alloc] init];
        [_avMetaDataOutput setMetadataObjectsDelegate:self queue:_qrSerialQueue];
        if (!CGRectEqualToRect(_scanRect, CGRectZero)) {
            [self setMetaOutputScanRect:_scanRect];
        }
        
        _avSession = [[AVCaptureSession alloc] init];
        [_avSession setSessionPreset:AVCaptureSessionPresetHigh];
        [_avSession addInput:_avInput];
        [_avSession addOutput:_avMetaDataOutput];
        
        _avMetaDataOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                                  AVMetadataObjectTypeEAN13Code,
                                                  AVMetadataObjectTypeEAN8Code,
                                                  AVMetadataObjectTypeCode128Code];
        
        if (_monitorBrightnessBlock && !_aVideoIOutput) {
            _aVideoIOutput = [[AVCaptureVideoDataOutput alloc] init];
            [_aVideoIOutput setSampleBufferDelegate:self queue:_qrSerialQueue];
            [_avSession addOutput:_aVideoIOutput];
        }
    }
    
    if (_preview && !_avPreviewLayer) {
        _avPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_avSession];
        _avPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _avPreviewLayer.frame = _preview.layer.bounds;
        [_preview.layer addSublayer:_avPreviewLayer];
    }
    [self resumeScanQR];
}

- (void)resumeScanQR {
    [_avSession startRunning];
    self.scanState = MCQRScanerStateScaning;
}

- (void)pauseScanQR {
    [_avSession stopRunning];
    self.scanState = MCQRScanerStatePause;
}

- (void)setScanRetangleRect:(CGRect)scanRect {
    _scanRect = scanRect;
    [self setMetaOutputScanRect:_scanRect];
}

- (void)setMetaOutputScanRect:(CGRect )scanRect {
    if (_avMetaDataOutput) {
        CGRect frame = _preview? _preview.bounds : [UIScreen mainScreen].bounds;
        CGFloat frameW = frame.size.width;
        CGFloat frameH = frame.size.height;
        CGFloat x = scanRect.origin.x / frameW;
        CGFloat y = scanRect.origin.y / frameH;
        CGFloat w = scanRect.size.width / frameW;
        CGFloat h = scanRect.size.height / frameH;
        _avMetaDataOutput.rectOfInterest = CGRectMake(y, x, h, w);
    }
}

- (void)addPreview:(UIView *)preview {
    self.preview = preview;
    if (_avSession && !_avPreviewLayer) {
        _avPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_avSession];
        _avPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _avPreviewLayer.frame = _preview.layer.bounds;
        [_preview.layer addSublayer:_avPreviewLayer];
    }
}

- (void)scanQRFromImage:(UIImage *)image {
    
}


- (void)monitorBrightness:(MCQRScanerMonitorBrightnessBlock)monitorBlock {
    dispatch_async(_qrSerialQueue, ^{
        self.monitorBrightnessBlock = monitorBlock;
    });
    
    if (_avSession && !_aVideoIOutput) {
        _aVideoIOutput = [[AVCaptureVideoDataOutput alloc] init];
        [_aVideoIOutput setSampleBufferDelegate:self queue:_qrSerialQueue];
        [_avSession addOutput:_aVideoIOutput];
    }
}

#pragma -mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if(!_scanCompleteBlock) return;
    
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *_metaDataObject = [metadataObjects firstObject];
        NSString *scanedCode = _metaDataObject.stringValue;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.scanState == MCQRScanerStateScaning) {
                self.scanCompleteBlock(scanedCode);
            }
            [self pauseScanQR];
        });
    }
}

#pragma -mark AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if(!_monitorBrightnessBlock) return;
    
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *exifMetadataDict = CFDictionaryGetValue(metadataDict, kCGImagePropertyExifDictionary);
    float brightness = [[exifMetadataDict objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    
    if ([NSThread isMainThread]) {
        self.monitorBrightnessBlock(brightness);
    }else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.monitorBrightnessBlock(brightness);
        });
    }
    
    CFRelease(metadataDict);
}

@end
