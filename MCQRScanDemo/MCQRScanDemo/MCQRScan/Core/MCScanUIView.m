//
//  MCScanUIView.m
//  MC_Express
//
//  Created by kaifa on 2019/1/11.
//  Copyright © 2019 MC_MaoDou. All rights reserved.
//

#import "MCScanUIView.h"

@interface MCScanUIView ()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong) CAShapeLayer *squareLayer;

@property (nonatomic, assign)  BOOL needDrawPath;

@end

@implementation MCScanUIView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _scanRect = self.bounds;
        _edgeLength = 20;
        _edgeWidth = 3;
        _scanRectborderWidth = 1;
        _edgeColor = [UIColor whiteColor];
        _maskBgColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _needDrawPath = YES;
    }
    return self;
}

- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.fillColor = [UIColor blackColor].CGColor;
        layer.opacity = 0.5;
        layer.fillRule = kCAFillRuleEvenOdd;
        _shapeLayer = layer;
    }
    return _shapeLayer;
}

- (CAShapeLayer *)squareLayer {
    if (!_squareLayer) {
        CAShapeLayer *lineLayer = [CAShapeLayer layer];
        lineLayer.strokeColor = [UIColor whiteColor].CGColor;
        lineLayer.lineWidth = 6;
        lineLayer.fillColor = [UIColor clearColor].CGColor;
        _squareLayer = lineLayer;
    }
    return _squareLayer;
}

- (void)layoutSubviews {
    
    if (_needDrawPath) {
        [self drawPaths];
        self.needDrawPath = NO;
    }
}

- (void)drawPaths {
    CGRect rect = _scanRect;
    CGFloat lineWidth = _edgeLength;
    
    CGFloat trH = lineWidth;
    CGFloat trW = lineWidth;
    CGFloat brw = lineWidth;
    CGFloat brH = lineWidth;
    CGFloat tlw = lineWidth;
    CGFloat tlH = lineWidth;
    CGFloat blW = lineWidth;
    CGFloat blH = lineWidth;
    
    CGFloat sizeW = rect.size.width;
    CGFloat sizeH = rect.size.height;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    path.usesEvenOddFillRule = YES;
    UIBezierPath *path2 = [UIBezierPath bezierPathWithRect:rect];
    [path appendPath:path2];
    
    CAShapeLayer *layer = self.shapeLayer;
    layer.path = path.CGPath;
    layer.fillColor = _maskBgColor.CGColor;
    layer.frame = self.bounds;
    [self.layer addSublayer:layer];
    
    if (CGRectEqualToRect(self.bounds, rect) || CGRectEqualToRect(CGRectZero, rect)) {
        if (_squareLayer) {
            [_squareLayer removeFromSuperlayer];
        }
    }else {
        CAShapeLayer *lineLayer = self.squareLayer;
        lineLayer.lineWidth = _edgeWidth * 2;
        lineLayer.frame = rect;
        [self.layer addSublayer:lineLayer];
        
        UIBezierPath *path3 = [UIBezierPath bezierPath];
        [path3 moveToPoint:CGPointMake(0, 0)];
        [path3 addLineToPoint:CGPointMake(trW, 0)];
        [path3 moveToPoint:CGPointMake(0, 0)];
        [path3 addLineToPoint:CGPointMake(0, trH)];
        
        [path3 moveToPoint:CGPointMake(sizeW, 0)];
        [path3 addLineToPoint:CGPointMake(sizeW - tlw, 0)];
        [path3 moveToPoint:CGPointMake(sizeW, 0)];
        [path3 addLineToPoint:CGPointMake(sizeW, tlH)];
        
        [path3 moveToPoint:CGPointMake(0, sizeH)];
        [path3 addLineToPoint:CGPointMake(0, sizeH - brH)];
        [path3 moveToPoint:CGPointMake(0, sizeH)];
        [path3 addLineToPoint:CGPointMake(brw, sizeH)];
        
        [path3 moveToPoint:CGPointMake(sizeW, sizeH)];
        [path3 addLineToPoint:CGPointMake(sizeW - blW, sizeH)];
        [path3 moveToPoint:CGPointMake(sizeW, sizeH)];
        [path3 addLineToPoint:CGPointMake(sizeW, sizeH - blH)];
        
        lineLayer.path = path3.CGPath;
        lineLayer.masksToBounds = YES;
        //边框
        lineLayer.borderColor = _edgeColor.CGColor;
        lineLayer.borderWidth = _scanRectborderWidth;
    }
    
}

#pragma -mark setter

- (void)setFrame:(CGRect)frame {
    self.needDrawPath = YES;
    [super setFrame:frame];
}

- (void)setEdgeLength:(CGFloat)edgeLength {
    if (_edgeLength == edgeLength) return;
    _edgeLength = edgeLength;
    
    self.needDrawPath = YES;
    [self setNeedsLayout];
}

- (void)setEdgeColor:(UIColor *)edgeColor {
    if (CGColorEqualToColor(_edgeColor.CGColor, edgeColor.CGColor)) {
        return;
    }
    _edgeColor = edgeColor;
    
    self.needDrawPath = YES;
    [self setNeedsLayout];
}

- (void)setEdgeWidth:(CGFloat)edgeWidth {
    if (edgeWidth == edgeWidth) return;
    _edgeWidth = edgeWidth;
    
    self.needDrawPath = YES;
    [self setNeedsLayout];
}

- (void)setScanRect:(CGRect)scanRect {
    if (CGRectEqualToRect(_scanRect, scanRect)) return;
    _scanRect = scanRect;
    
    self.needDrawPath = YES;
    [self setNeedsLayout];
}

- (void)setScanRectborderWidth:(CGFloat)scanRectborderWidth {
    if (_scanRectborderWidth == scanRectborderWidth) return;
    _scanRectborderWidth = scanRectborderWidth;
    
    self.needDrawPath = YES;
    [self setNeedsLayout];
}

- (void)setMaskBgColor:(UIColor *)maskBgColor {
    if (CGColorEqualToColor(_maskBgColor.CGColor, maskBgColor.CGColor)) return;
    _maskBgColor = maskBgColor;
    
    self.needDrawPath = YES;
    [self setNeedsLayout];
}

@end
