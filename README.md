# MCQRScan
一个轻量级的二维码扫描识别工具类，已解耦合，核心代码很少，容易理解，以及自定义自己的 界面的 UI样式。

## 一. 使用
简单的构建一个二维码扫描界面

```
// 添加扫描时显示摄像头画面的 view
_scanView = [[MCScanUIView alloc] initWithFrame:self.view.bounds];
_scanView.scanRect = CGRectMake(kX, kY, kW, kH);
[self.view addSubview:_scanView];  
  
// 创建二维码扫描工具
_qrScaner = [[MCQRScaner alloc] init];

// 绑定摄像显示的 preview
[_qrScaner addPreview:preview];

// 打开相机识别二维码
[_qrScaner openCarmeraToScanQR:^(NSString * _Nonnull code) {
    NSLog(@"code: %@", code);
}];

```
默认是二维码出现在屏幕里就开始识别，如果想要二维码进入边框后在识别，可以添加如下代码：

```
[_qrScaner setScanRetangleRect:CGRectMake(kX, kY, kW, kH)];
```

具体代码可见 Demo 代码。

## 二. 核心类

####  MCQRScaner
提供识别二维码的全部功能，包括打开相机识别二维码、 从图片中识别二维码、 检测当前相机环境的明暗度：

1.打开二维码识别：

``` 
/**
 开启二维码扫描

 @param complete 扫描到二维码的回调
 */
- (void)openCarmeraToScanQR:(MCQRScanerCompleteBlock )complete;
```

2.从图片识别二维码

```
/**
 从图片中识别二维码

 @param image 二维码图
 */
- (NSString *)scanQRFromImage:(UIImage *)image;
```
3.检测当前拍摄环境的明亮度，可用于在比较暗的环境下打开闪光灯

```
/**
 开启亮度检测

 @param monitorBlock 检测回调，可用于环境比较暗的时候开启闪光灯
 */
- (void)monitorBrightness:(MCQRScanerMonitorBrightnessBlock )monitorBlock;
```

#### MCScanUIView
提供了一个二维码扫描是界面方框绘制的一个样本代码，代码简单，容易理解，自己可以重新定义。

#### MCQRScanController
基于 `MCQRScaner` 与 `MCScanUIView` 写的一个简单的二维码扫描界面，通过它你能更好的理解 `MCQRScaner` 与 `MCScanUIView` 如何搭配来形成一个二维码扫描界面，当然你也可以直接使用 `MCQRScanController` 来实现效果。


