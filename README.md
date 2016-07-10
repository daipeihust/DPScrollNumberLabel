# DPScrollNumberLabel
## 简介
一个能够显示最多8位数字的控件，当你改变显示的数字的时，会有一个滚动动画。<br><br>
![image](https://github.com/948080952/DPScrollNumberLabel/blob/master/DPScrollNumber.gif) 
<br>效果图
## 使用
将DPScrollNumberLabel文件夹中的两个文件复制进工程，在需要使用的地方导入头文件<br>
```Objective-c
@interface ViewController ()

@property (nonatomic, strong)DPScrollNumberLabel *scrollLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollLabel = [[DPScrollNumberLabel alloc] initWithNumber:@(1) font:[UIFont fontWithName:@"AppleSDGothicNeo-SemiBold" size:40] textColor:[UIColor grayColor] rowNumber:5];
    
    self.scrollLabel.frame = CGRectMake(100, 100, self.scrollLabel.frame.size.width, self.scrollLabel.frame.size.height);
    
    [self.view addSubview:self.scrollLabel];
    
}
@end
```
