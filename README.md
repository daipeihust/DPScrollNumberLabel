# DPScrollNumberLabel
## 简介
一个能够显示最多8位数字的控件，当你改变显示的数字的时，会有一个滚动动画。<br><br>
![image](https://github.com/948080952/DPScrollNumberLabel/blob/master/DPScrollNumber.gif) 
<br>效果图
## 使用
将DPScrollNumberLabel文件夹中的两个文件复制进工程，在需要使用的地方导入头文件<br>
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
1.目前还不支持负数的显示<br>
2.动画时间的算法还有些问题<br>
3.显示的位数有限制，最大8位<br>


