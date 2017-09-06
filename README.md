# DPScrollNumberLabel
## 简介
一个能够显示最多8位数字的控件，当你改变显示的数字的时，会有一个滚动动画。

![image](https://github.com/948080952/DPScrollNumberLabel/blob/master/DPScrollNumber.gif) 

效果图

## 安装

### 通过CocoaPods安装

首先使用以下命令安装[CocoaPods](https://cocoapods.org)

```
$ gem install cocoapods
```

进入你的工程目录，运行以下命令

```
$ pod init
```

这时你的工程目录会生成一个文件名为Podfile的文件，在其中加入DPScrollNumberLabel的配置

```
target 'TargetName' do
  pod 'DPScrollNumberLabel', '~> 0.0.1'
end
```

最后运行以下命令：

```
$ pod install
```

##### 安装0.0.2

新版本加入了对负数的支持，但未经过大量的测试，可能存在一些未知的bug，如果你对负数没有需求，请安装0.0.1版本，如果你需要负数的展示或是你想尝试新版本，请安装0.0.2版本。在使用过程中如果遇到任何bug，欢迎提issue。

0.0.2版本安装过程与0.0.1相同，只需做如下替换即可：

```
target 'TargetName' do
  pod 'DPScrollNumberLabel', '~> 0.0.2'
end
```

> 注意：0.0.2的接口相对于0.0.1来说有些许变化，从0.0.1升级到0.0.2需要稍微花点时间进行适配

## 使用

首先在需要使用的地方导入头文件

```Objective-c

#import "DPScrollNumberLabel.h"

@interface ViewController ()

@property (nonatomic, strong)DPScrollNumberLabel *scrollLabel;

@end

```
初始化的方法传人字体大小或是一个字体，不要设置其frame，只需改变其位置即可，因为它是根据字体大小自动计算自身的大小

```Objective-c
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollLabel = [[DPScrollNumberLabel alloc] initWithNumber:@(1) font:[UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:40] textColor:[UIColor grayColor] rowNumber:5];
    
    self.scrollLabel.frame = CGRectMake(100, 100, self.scrollLabel.frame.size.width, self.scrollLabel.frame.size.height);
    
    [self.view addSubview:self.scrollLabel];
    
}
@end
```
当想要改变其数值时，调用下面方法即可,当animated参数为NO时不会播放动画
```Objective-c
[self.scrollLabel changeToNumber:@(10) animated:YES];
```
初始化接口公分为两大类：静态、动态

动态初始化方法不需要传入列数的参数，它的列数会根据展示的数字动态变化。例如：

```objective-c
- (instancetype)initWithNumber:(NSNumber *)number fontSize:(CGFloat)fontSize;
```

静态初始化可以指定一个列数，当你设置的值大于这个列数，不会产生任何反应。例如：

```objective-c
- (instancetype)initWithNumber:(NSNumber *)number fontSize:(CGFloat)fontSize rowNumber:(NSUInteger)rowNumber;
```

关于0.0.2负数模式，一共有三种：

`SignSettingUnsigned`：仅支持正数，跟0.0.1版本保持一致

`SignSettingNormal`：支持负数，当显示负数时前面会有-号，当显示正数时前面没有+号

`SignSettingSigned`：支持负数，负数前面会有-号，正数前面会有+号



## 更新日志

- 0.0.1 第一版，仅支持正数范围内数字变化时的滚动逻辑
- 0.0.2 加入了对负数的支持，共支持三种模式：仅仅有正数、无符号正数和有符号负数、有符号正数和负数

## 问题

1.动画时间的算法还有些问题

2.显示的位数有限制，最大8位


