//
//  MCQRScanController.h
//  MC_Express
//
//  Created by kaifa on 2019/1/4.
//  Copyright © 2019 MC_MaoDou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MCQRScanControllerScanedBlock)(NSString *scanedResult);

@interface MCQRScanController : UIViewController

@property (nonatomic, copy) MCQRScanControllerScanedBlock scanedBlcok;

@end

NS_ASSUME_NONNULL_END
