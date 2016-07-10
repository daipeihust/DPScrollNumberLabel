//
//  DPScrollNumberLabel.h
//  DPScrollNumberLabelDemo
//
//  Created by Dai Pei on 16/5/23.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface DPScrollNumberLabel : UIView

@property (nonatomic, strong)NSNumber *displayedNumber;

- (instancetype)initWithNumber:(NSNumber *)originNumber fontSize:(CGFloat)size;
- (instancetype)initWithNumber:(NSNumber *)originNumber fontSize:(CGFloat)size textColor:(UIColor *)color;
- (instancetype)initWithNumber:(NSNumber *)originNumber font:(UIFont *)font;
- (instancetype)initWithNumber:(NSNumber *)originNumber font:(UIFont *)font textColor:(UIColor *)color;
- (instancetype)initWithNumber:(NSNumber *)originNumber fontSize:(CGFloat)size rowNumber:(NSUInteger)rowNumber;
- (instancetype)initWithNumber:(NSNumber *)originNumber fontSize:(CGFloat)size textColor:(UIColor *)color rowNumber:(NSUInteger)rowNumber;
- (instancetype)initWithNumber:(NSNumber *)originNumber font:(UIFont *)font textColor:(UIColor *)color rowNumber:(NSUInteger)rowNumber;//rowNumber should less than or equal 8

- (void)changeToNumber:(NSNumber *)number animated:(BOOL)animated;
- (void)changeToNumber:(NSNumber *)number interval:(CGFloat)interval animated:(BOOL)animated;


@end
