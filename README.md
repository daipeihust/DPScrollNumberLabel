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

## 使用
将DPScrollNumberLabel文件夹中的两个文件复制进工程，在需要使用的地方导入头文件

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
## 问题
1.目前还不支持负数的显示

2.动画时间的算法还有些问题

3.显示的位数有限制，最大8位


