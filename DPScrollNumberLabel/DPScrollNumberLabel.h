//
//  DPScrollNumberLabel.h
//  DPScrollNumberLabelDemo
//
//  Created by Dai Pei on 16/5/23.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//


#import <UIKit/UIKit.h>


/**
 the setting option for SignSetting

 - SignSettingUnsigned: only display positive number, default configuration is unsigned 
 - SignSettingNormal: negative numbers have negative sign but positive numbers don't have sign
 - SignSettingSigned: positive numbers have sign as well as negative numbers
 - default: SignSettingUnsigned
 */
typedef NS_ENUM(NSUInteger, SignSetting) {
    SignSettingUnsigned, 
    SignSettingNormal, 
    SignSettingSigned 
};


@interface DPScrollNumberLabel : UIView

/**
 it synchronize with the value you set by method '-changeToNumber:animated:' and '-changeToNumber:interval:animated:'
 */
@property (nonatomic, strong, readonly)NSNumber *currentNumber;

/**
 dynamic init method, the instance created by this method have a dynamic row count, it's row will change with the value you setting

 @param number: the initial number you want to display
 @param fontSize: the number font size you want
 @return the instance of DPScrollNumberLabel
 */
- (instancetype)initWithNumber:(NSNumber *)number fontSize:(CGFloat)fontSize;

/**
 dynamic init method, the instance created by this method have a dynamic row count, it's row will change with the value you setting

 @param number: the initial number you want to display
 @param fontSize: the number font size you want
 @param textColor: the number color you want
 @return the instance of DPScrollNumberLabel
 */
- (instancetype)initWithNumber:(NSNumber *)number fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor;

/**
 dynamic init method, the instance created by this method have a dynamic row count, it's row will change with the value you setting

 @param number: the initial number you want to display
 @param fontSize: the number font size you want
 @param signSetting: the sign setting for DPScrollNumberLabel, you have three option: unsigned, normal, signed. see SignSetting enum declaration for detail.
 @return the instance of DPScrollNumberLabel
 */
- (instancetype)initWithNumber:(NSNumber *)number fontSize:(CGFloat)fontSize signSetting:(SignSetting)signSetting;

/**
 dynamic init method, the instance created by this method have a dynamic row count, it's row will change with the value you setting

 @param number: the initial number you want to display
 @param fontSize: the number font size you want
 @param textColor: the number color you want
 @param signSetting: the sign setting for DPScrollNumberLabel, you have three option: unsigned, normal, signed. see SignSetting enum declaration for detail.
 @return the instance of DPScrollNumberLabel
 */
- (instancetype)initWithNumber:(NSNumber *)number fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor signSetting:(SignSetting)signSetting;

/**
 dynamic init method, the instance created by this method have a dynamic row count, it's row will change with the value you setting

 @param number: the initial number you want to display
 @param font: the number font you want
 @return the instance of DPScrollNumberLabel
 */
- (instancetype)initWithNumber:(NSNumber *)number font:(UIFont *)font;

/**
 dynamic init method, the instance created by this method have a dynamic row count, it's row will change with the value you setting

 @param number: the initial number you want to display
 @param font: the number font you want
 @param textColor: the number color you want
 @return the instance of DPScrollNumberLabel
 */
- (instancetype)initWithNumber:(NSNumber *)number font:(UIFont *)font textColor:(UIColor *)textColor;

/**
 dynamic init method, the instance created by this method have a dynamic row count, it's row will change with the value you setting

 @param number: the initial number you want to display
 @param font: the number font you want
 @param signSetting: the sign setting for DPScrollNumberLabel, you have three option: unsigned, normal, signed. see SignSetting enum declaration for detail.
 @return the instance of DPScrollNumberLabel
 */
- (instancetype)initWithNumber:(NSNumber *)number font:(UIFont *)font signSetting:(SignSetting)signSetting;

/**
 dynamic init method, the instance created by this method have a dynamic row count, it's row will change with the value you setting

 @param number: the initial number you want to display
 @param font: the number font you want
 @param textColor: the number color you want
 @param signSetting: the sign setting for DPScrollNumberLabel, you have three option: unsigned, normal, signed. see SignSetting enum declaration for detail.
 @return the instance of DPScrollNumberLabel
 */
- (instancetype)initWithNumber:(NSNumber *)number font:(UIFont *)font textColor:(UIColor *)textColor signSetting:(SignSetting)signSetting;


/*-------------------------------------------- dynamic init method end -------------------------------------------------
 
 if you set row number, the DPScrollNumberLabel instance's max num will less than the row num.
 For example, you set row number to 1, then the max count of this label will be 9.
 
 Note:rowNumber shouldn't more than 8
 
 ---------------------------------------------- static init method start -----------------------------------------------*/


/**
 static init method, the instance created by this method have a comfirmed row count, 
 if your value's row bigger than the comfirmed row, it won't have effect

 @param number: the initial number you want to display
 @param fontSize: the number font size you want
 @param rowNumber: the row count of DPScrollNumberLabel, it means the row count will be changeless
 @return the instance of DPScrollNumberLabel
 */
- (instancetype)initWithNumber:(NSNumber *)number
                      fontSize:(CGFloat)fontSize
                     rowNumber:(NSUInteger)rowNumber;

/**
 static init method, the instance created by this method have a comfirmed row count, 
 if your value's row bigger than the comfirmed row, it won't have effect

 @param number: the initial number you want to display
 @param fontSize: the number font size you want
 @param textColor: the number color you want
 @param rowNumber: the row count of DPScrollNumberLabel, it means the row count will be changeless
 @return the instance of DPScrollNumberLabel
 */
- (instancetype)initWithNumber:(NSNumber *)number
                      fontSize:(CGFloat)fontSize
                     textColor:(UIColor *)textColor
                     rowNumber:(NSUInteger)rowNumber;

/**
 static init method, the instance created by this method have a comfirmed row count, 
 if your value's row bigger than the comfirmed row, it won't have effect

 @param number: the initial number you want to display
 @param fontSize: the number font size you want
 @param signSetting: the sign setting for DPScrollNumberLabel, you have three option: unsigned, normal, signed. see SignSetting enum declaration for detail.
 @param rowNumber: the row count of DPScrollNumberLabel, it means the row count will be changeless
 @return the instance of DPScrollNumberLabel
 */
- (instancetype)initWithNumber:(NSNumber *)number
                      fontSize:(CGFloat)fontSize
                      signSetting:(SignSetting)signSetting
                     rowNumber:(NSUInteger)rowNumber;

/**
 static init method, the instance created by this method have a comfirmed row count, 
 if your value's row bigger than the comfirmed row, it won't have effect

 @param number: the initial number you want to display
 @param fontSize: the number font size you want
 @param textColor: the number color you want
 @param signSetting: the sign setting for DPScrollNumberLabel, you have three option: unsigned, normal, signed. see SignSetting enum declaration for detail.
 @param rowNumber: the row count of DPScrollNumberLabel, it means the row count will be changeless
 @return the instance of DPScrollNumberLabel
 */
- (instancetype)initWithNumber:(NSNumber *)number
                      fontSize:(CGFloat)fontSize
                     textColor:(UIColor *)textColor
                      signSetting:(SignSetting)signSetting
                     rowNumber:(NSUInteger)rowNumber;

/**
 static init method, the instance created by this method have a comfirmed row count, 
 if your value's row bigger than the comfirmed row, it won't have effect

 @param number: the initial number you want to display
 @param font: the number font you want
 @param textColor: the number color you want
 @param rowNumber: the row count of DPScrollNumberLabel, it means the row count will be changeless
 @return the instance of DPScrollNumberLabel
 */
- (instancetype)initWithNumber:(NSNumber *)number
                          font:(UIFont *)font
                     textColor:(UIColor *)textColor
                     rowNumber:(NSUInteger)rowNumber;

/**
 static init method, the instance created by this method have a comfirmed row count, 
 if your value's row bigger than the comfirmed row, it won't have effect

 @param number: the initial number you want to display
 @param font: the number font you want
 @param signSetting: the sign setting for DPScrollNumberLabel, you have three option: unsigned, normal, signed. see SignSetting enum declaration for detail.
 @param rowNumber: the row count of DPScrollNumberLabel, it means the row count will be changeless
 @return the instance of DPScrollNumberLabel
 */
- (instancetype)initWithNumber:(NSNumber *)number
                          font:(UIFont *)font
                      signSetting:(SignSetting)signSetting
                     rowNumber:(NSUInteger)rowNumber;

/**
 static init method, the instance created by this method have a comfirmed row count, 
 if your value's row bigger than the comfirmed row, it won't have effect

 @param number: the initial number you want to display
 @param font: the number font you want
 @param textColor: the number color you want
 @param signSetting: the sign setting for DPScrollNumberLabel, you have three option: unsigned, normal, signed. see SignSetting enum declaration for detail.
 @param rowNumber: the row count of DPScrollNumberLabel, it means the row count will be changeless
 @return the instance of DPScrollNumberLabel
 */
- (instancetype)initWithNumber:(NSNumber *)number
                          font:(UIFont *)font
                     textColor:(UIColor *)textColor
                      signSetting:(SignSetting)signSetting
                     rowNumber:(NSUInteger)rowNumber;

/**
 When you want to change the display value, you can use this method, 
 and the interval of scroll animation will be calculated automatically

 @param number: the number you want to display
 @param animated: if you pass NO, the label will display your number without animation
 */
- (void)changeToNumber:(NSNumber *)number animated:(BOOL)animated;

/**
 When you want to change the display value and you want to calculate 
 the animation interval by yourself, you should use this method

 @param number: the number you want to display
 @param interval: the animation interval
 @param animated: if you pass NO, the label will display your number withour animation
 */
- (void)changeToNumber:(NSNumber *)number interval:(CGFloat)interval animated:(BOOL)animated;


@end
