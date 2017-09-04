//
//  DPScrollNumberLabel.h
//  DPScrollNumberLabelDemo
//
//  Created by Dai Pei on 16/5/23.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SignSetting) {
    SignSettingUnsigned, // only display positive number, default configuration is unsigned
    SignSettingNormal, // negative numbers have negative sign but positive numbers don't have sign
    SignSettingSigned // positive numbers have sign as well as negative numbers
};


@interface DPScrollNumberLabel : UIView

@property (nonatomic, strong, readonly)NSNumber *currentNumber;

- (instancetype)initWithNumber:(NSNumber *)originNumber fontSize:(CGFloat)size;
- (instancetype)initWithNumber:(NSNumber *)originNumber fontSize:(CGFloat)size textColor:(UIColor *)color;
- (instancetype)initWithNumber:(NSNumber *)originNumber fontSize:(CGFloat)size signSetting:(SignSetting)signSetting;
- (instancetype)initWithNumber:(NSNumber *)originNumber fontSize:(CGFloat)size textColor:(UIColor *)color signSetting:(SignSetting)signSetting;

- (instancetype)initWithNumber:(NSNumber *)originNumber font:(UIFont *)font;
- (instancetype)initWithNumber:(NSNumber *)originNumber font:(UIFont *)font textColor:(UIColor *)color;
- (instancetype)initWithNumber:(NSNumber *)originNumber font:(UIFont *)font signSetting:(SignSetting)signSetting;
- (instancetype)initWithNumber:(NSNumber *)originNumber font:(UIFont *)font textColor:(UIColor *)color signSetting:(SignSetting)signSetting;

/********************************
 
 if you set row number, the DPScrollNumberLabel instance's max num will less than the row num.
 For example, you set row number to 1, then the max count of this label will be 9.
 
 Note:rowNumber shouldn't more than 8
 
 ********************************/
- (instancetype)initWithNumber:(NSNumber *)originNumber
                      fontSize:(CGFloat)size
                     rowNumber:(NSUInteger)rowNumber;

- (instancetype)initWithNumber:(NSNumber *)originNumber
                      fontSize:(CGFloat)size
                     textColor:(UIColor *)color
                     rowNumber:(NSUInteger)rowNumber;

- (instancetype)initWithNumber:(NSNumber *)originNumber
                      fontSize:(CGFloat)size
                      signSetting:(SignSetting)signSetting
                     rowNumber:(NSUInteger)rowNumber;

- (instancetype)initWithNumber:(NSNumber *)originNumber
                      fontSize:(CGFloat)size
                     textColor:(UIColor *)color
                      signSetting:(SignSetting)signSetting
                     rowNumber:(NSUInteger)rowNumber;

- (instancetype)initWithNumber:(NSNumber *)originNumber
                          font:(UIFont *)font
                     textColor:(UIColor *)color
                     rowNumber:(NSUInteger)rowNumber;

- (instancetype)initWithNumber:(NSNumber *)originNumber
                          font:(UIFont *)font
                      signSetting:(SignSetting)signSetting
                     rowNumber:(NSUInteger)rowNumber;

- (instancetype)initWithNumber:(NSNumber *)originNumber
                          font:(UIFont *)font
                     textColor:(UIColor *)color
                      signSetting:(SignSetting)signSetting
                     rowNumber:(NSUInteger)rowNumber;

- (void)changeToNumber:(NSNumber *)number animated:(BOOL)animated;
- (void)changeToNumber:(NSNumber *)number interval:(CGFloat)interval animated:(BOOL)animated;


@end
