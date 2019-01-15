//
//  EXPScanView.m
//  MC_Express
//
//  Created by kaifa on 2019/1/14.
//  Copyright © 2019 MC_MaoDou. All rights reserved.
//

#import "MCCustomScanView.h"

@interface MCCustomScanView ()

@property (nonatomic, strong) UIImageView * scanLineImageView;
@property (nonatomic, strong) UILabel *messageLabel;

/**
 是否正在动画
 */
@property (nonatomic, assign) BOOL isAnimating;

/**
 手电筒开关
 */
@property (nonatomic, strong) UIButton * flashButton;
/**
 闪光灯开关的状态
 */
@property (nonatomic, assign) BOOL flashOpen;

@end

@implementation MCCustomScanView

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel  = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageLabel.font = [UIFont systemFontOfSize:12];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = [UIColor whiteColor];
    }
    return _messageLabel;
}

- (void)setAnimationImage:(UIImage *)animationImage {
    if (_animationImage == animationImage) {
        return;
    }
    _animationImage = animationImage;
    
    self.scanLineImageView.image = _animationImage;
    [self addSubview:self.scanLineImageView];
}

- (void)setMessage:(NSString *)message {
    if (_message == message) {
        return;
    }
    _message = message;
    
    CGRect scanRect = self.scanRect;
    self.messageLabel.frame = CGRectMake(0, CGRectGetMaxY(scanRect) + 10, self.bounds.size.width, 20);
    self.messageLabel.text = _message;
    [self addSubview:self.messageLabel];
}

#pragma mark -- Events Handle
- (void)startScan {    
    if (_isAnimating == NO) {
        return;
    }
    
    CGRect scanRect = self.scanRect;
    [UIView animateWithDuration:3.0 animations:^{
        self.scanLineImageView.frame = CGRectMake(scanRect.origin.x, scanRect.origin.y + scanRect.size.height - 2, scanRect.size.width, 2);
    } completion:^(BOOL finished){
        if (finished) {
            self.scanLineImageView.frame = CGRectMake(scanRect.origin.x, scanRect.origin.y, scanRect.size.width, 2);
            [self performSelector:@selector(startScan) withObject:nil afterDelay:0.03];
        }
    }];
    
}

- (void)startScanAnimation {
    if(_isAnimating){
        return;
    }
    _isAnimating = YES;
    [self startScan];
}

- (void)stopScanAnimation {
    CGRect scanRect = self.scanRect;
    self.scanLineImageView.frame = CGRectMake(scanRect.origin.x, scanRect.origin.y, scanRect.size.width, 2);
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startScan) object:nil];
    self.isAnimating = NO;
    [self.scanLineImageView.layer removeAllAnimations];
}

- (void)flashButtonClicked:(UIButton *)flashButton {
    if (self.flashSwitchBlock != nil) {
        self.flashOpen = !self.flashOpen;
        self.flashSwitchBlock(self.flashOpen);
    }
    self.flashButton.selected = !self.flashButton.selected;
}

- (void)showFlashSwitch:(BOOL)show {
    if (!show && self.flashButton.selected) {
        return;
    }
    
    if (show == YES) {
        self.flashButton.hidden = NO;
        [self addSubview:self.flashButton];
    }else{
        self.flashButton.hidden = YES;
        [self.flashButton removeFromSuperview];
    }
}

#pragma mark -- Getter

- (UIImageView *)scanLineImageView {
    if (!_scanLineImageView) {
        CGRect scanRect = self.scanRect;
        _scanLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(scanRect.origin.x, scanRect.origin.y, scanRect.size.width, 4)];
        _scanLineImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _scanLineImageView;
}


- (UIButton *)flashButton {
    if (!_flashButton) {
        _flashButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_flashButton setImage:[UIImage imageNamed:@"scanFlashlight"] forState:UIControlStateNormal];
        [_flashButton addTarget:self action:@selector(flashButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _flashButton.center = CGPointMake(self.frame.size.width * 0.5, self.scanRect.origin.y + self.scanRect.size.height - 40);
    }
    return _flashButton;
}

- (void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startScan) object:nil];
}



@end
