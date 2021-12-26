//
//  ViewController.m
//  DPScrollNumberLabelDemo
//
//  Created by Dai Pei on 16/5/23.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "ViewController.h"
#import "DPScrollNumberLabel.h"


@interface ViewController ()

@property (nonatomic, strong)DPScrollNumberLabel *scrollLabel;
@property (nonatomic, strong)UITextView *textView;
@property (nonatomic, strong)UIButton *button1;
@property (nonatomic, strong)UIButton *addOne;
@property (nonatomic, strong)UIButton *addFive;
@property (nonatomic, strong)UIButton *add100;
@property (nonatomic, strong)UIButton *add500;
@property (nonatomic, strong)UIButton *reduceOne;
@property (nonatomic, strong)UIButton *reduceFive;
@property (nonatomic, strong)UIButton *reduce100;
@property (nonatomic, strong)UIButton *reduce500;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollLabel = [[DPScrollNumberLabel alloc] initWithNumber:@(0) fontSize:48 signSetting:SignSettingSigned];
    
    self.scrollLabel.frame = CGRectMake(100, 100, self.scrollLabel.frame.size.width, self.scrollLabel.frame.size.height);
    
    self.scrollLabel.minRowNumber = 2;
    
    [self.view addSubview:self.scrollLabel];
    
    [self.view addSubview:self.textView];
    [self.view addSubview:self.button1];
    
    [self.view addSubview:self.addOne];
    [self.view addSubview:self.reduceOne];
    [self.view addSubview:self.addFive];
    [self.view addSubview:self.reduceFive];
    [self.view addSubview:self.add100];
    [self.view addSubview:self.reduce100];
    [self.view addSubview:self.add500];
    [self.view addSubview:self.reduce500];
    
}

- (void)buttonClicked:(UIButton *)sender {
    
    NSInteger tmp = self.scrollLabel.currentNumber.integerValue;
    
    switch (sender.tag) {
        case 0:
            [self.scrollLabel changeToNumber:@(self.textView.text.integerValue) animated:YES];
            break;
        case 1:
            [self.scrollLabel changeToNumber:@(tmp + 1) animated:YES];
            break;
        case 2:
            [self.scrollLabel changeToNumber:@(tmp + 5) animated:YES];
            break;
        case 3:
            [self.scrollLabel changeToNumber:@(tmp + 100) animated:YES];
            break;
        case 4:
            [self.scrollLabel changeToNumber:@(tmp + 500) animated:YES];
            break;
        case 5:
            [self.scrollLabel changeToNumber:@(tmp - 1) animated:YES];
            break;
        case 6:
            [self.scrollLabel changeToNumber:@(tmp - 5) animated:YES];
            break;
        case 7:
            [self.scrollLabel changeToNumber:@(tmp - 100) animated:YES];
            break;
        case 8:
            [self.scrollLabel changeToNumber:@(tmp - 500) animated:YES];
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.keyboardType = UIKeyboardTypeNumberPad;
        _textView.frame = CGRectMake(70, 170, 100, 30);
        _textView.backgroundColor = [UIColor grayColor];
    }
    return _textView;
}

- (UIButton *)button1 {
    if (!_button1) {
        _button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_button1 setTitle:@"change" forState:UIControlStateNormal];
        _button1.frame = CGRectMake(170, 170, 100, 20);
        _button1.tag = 0;
        [_button1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button1;
}

- (UIButton *)addOne {
    if (!_addOne) {
        _addOne = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_addOne setTitle:@"+1" forState:UIControlStateNormal];
        _addOne.frame = CGRectMake(70, 230, 100, 20);
        _addOne.tag = 1;
        [_addOne addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addOne;
}

- (UIButton *)addFive {
    if (!_addFive) {
        _addFive = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_addFive setTitle:@"+5" forState:UIControlStateNormal];
        _addFive.frame = CGRectMake(70, 260, 100, 20);
        _addFive.tag = 2;
        [_addFive addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addFive;
}

- (UIButton *)add100 {
    if (!_add100) {
        _add100 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_add100 setTitle:@"+100" forState:UIControlStateNormal];
        _add100.frame = CGRectMake(70, 290, 100, 20);
        _add100.tag = 3;
        [_add100 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _add100;
}

- (UIButton *)add500 {
    if (!_add500) {
        _add500 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_add500 setTitle:@"+500" forState:UIControlStateNormal];
        _add500.frame = CGRectMake(70, 320, 100, 20);
        _add500.tag = 4;
        [_add500 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _add500;
}

- (UIButton *)reduceOne {
    if (!_reduceOne) {
        _reduceOne = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_reduceOne setTitle:@"-1" forState:UIControlStateNormal];
        _reduceOne.frame = CGRectMake(170, 230, 100, 20);
        _reduceOne.tag = 5;
        [_reduceOne addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reduceOne;
}

- (UIButton *)reduceFive {
    if (!_reduceFive) {
        _reduceFive = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_reduceFive setTitle:@"-5" forState:UIControlStateNormal];
        _reduceFive.frame = CGRectMake(170, 260, 100, 20);
        _reduceFive.tag = 6;
        [_reduceFive addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reduceFive;
}

- (UIButton *)reduce100 {
    if (!_reduce100) {
        _reduce100 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_reduce100 setTitle:@"-100" forState:UIControlStateNormal];
        _reduce100.frame = CGRectMake(170, 290, 100, 20);
        _reduce100.tag = 7;
        [_reduce100 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reduce100;
}

- (UIButton *)reduce500 {
    if (!_reduce500) {
        _reduce500 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_reduce500 setTitle:@"-500" forState:UIControlStateNormal];
        _reduce500.frame = CGRectMake(170, 320, 100, 20);
        _reduce500.tag = 8;
        [_reduce500 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reduce500;
}

@end
