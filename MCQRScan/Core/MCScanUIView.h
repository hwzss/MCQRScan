//
//  MCScanUIView.h
//  MC_Express
//
//  Created by kaifa on 2019/1/11.
//  Copyright © 2019 MC_MaoDou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCScanUIView : UIView

/**
 view中扫描二维码框位置
 */
@property (nonatomic, assign) CGRect scanRect;

/**
 四个角边框长度「
 */
@property (nonatomic, assign) CGFloat edgeLength;

/**
 四个角边框宽度『
 */
@property (nonatomic, assign) CGFloat edgeWidth;

/**
扫面二维码框的边框宽度
 */
@property (nonatomic, assign) CGFloat scanRectborderWidth;

/**
 扫面二维码框的边框颜色
 */
@property (nonatomic, strong) UIColor *edgeColor;

/**
 整体背景色，比如黑色
 */
@property (nonatomic, strong) UIColor *maskBgColor;

@end

NS_ASSUME_NONNULL_END
