//
//  DPScrollNumberLabel.m
//  DPScrollNumberLabelDemo
//
//  Created by Dai Pei on 16/5/23.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPScrollNumberLabel.h"

@interface DPAnimationAttribute : NSObject

@property (nonatomic, assign) NSInteger     repeatCount;
@property (nonatomic, assign) CGFloat       startDuration;
@property (nonatomic, assign) CGFloat       cycleDuration;
@property (nonatomic, assign) CGFloat       endDuration;
@property (nonatomic, assign) NSInteger     targetNumber;
@property (nonatomic, assign) CGFloat       startDelay;
@property (nonatomic, assign) NSInteger     sign;

@end

@implementation DPAnimationAttribute

@end


@interface DPAnimationTask : NSObject

@property (nonatomic, assign) NSInteger     targetNumber;
@property (nonatomic, assign) NSInteger     changeValue;
@property (nonatomic, assign) CGFloat       interval;

@end

@implementation DPAnimationTask

@end

typedef NS_ENUM(NSUInteger, ScrollAnimationDirection) {
    ScrollAnimationDirectionIncrease,
    ScrollAnimationDirectionDecrease,
    ScrollAnimationDirectionCount
};

typedef NS_ENUM(NSUInteger, Sign) {
    SignNegative = 0,
    SignZero = 1, // when the display number is zero, there is no sign
    SignPositive = 2
};

static const CGFloat normalModulus = 0.3f;
static const CGFloat bufferModulus = 0.7f;

static const NSUInteger numberCellLineCount = 21;
static const NSUInteger signCellLineCount = 3;

static NSString * const numberCellText = @"0\n9\n8\n7\n6\n5\n4\n3\n2\n1\n0\n1\n2\n3\n4\n5\n6\n7\n8\n9\n0";

@interface DPScrollNumberLabel()

@property (nonatomic, strong, readwrite) NSNumber           *currentNumber;
@property (nonatomic, strong) NSNumber                      *targetNumber;
@property (nonatomic, strong) NSMutableArray<UILabel *>     *cellArray;
@property (nonatomic, strong) UILabel                       *signCell;
@property (nonatomic, assign) CGFloat                       fontSize;
@property (nonatomic, assign) NSUInteger                    numberRow;
@property (nonatomic, strong) NSMutableArray                *taskQueue;
@property (nonatomic, assign) BOOL                          isAnimating;
@property (nonatomic, assign) CGFloat                       cellWidth;
@property (nonatomic, assign) CGFloat                       numberCellHeight;
@property (nonatomic, assign) CGFloat                       signCellHeight;
@property (nonatomic, assign) NSInteger                     finishedAnimationCount;
@property (nonatomic, assign) NSUInteger                    maxRowNumber;
@property (nonatomic, strong) UIColor                       *textColor;
@property (nonatomic, strong) UIFont                        *font;
@property (nonatomic, assign) SignSetting                   signSetting;
@property (nonatomic, assign) NSUInteger                    signRow;

@end

@implementation DPScrollNumberLabel

#pragma mark - Init

- (instancetype)initWithNumber:(NSNumber *)number fontSize:(CGFloat)fontSize {
    return [self initWithNumber:number fontSize:fontSize textColor:[UIColor grayColor] rowNumber:0];
}

- (instancetype)initWithNumber:(NSNumber *)number fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor {
    return [self initWithNumber:number fontSize:fontSize textColor:textColor rowNumber:0];
}

- (instancetype)initWithNumber:(NSNumber *)number fontSize:(CGFloat)fontSize signSetting:(SignSetting)signSetting {
    return [self initWithNumber:number fontSize:fontSize textColor:[UIColor grayColor] signSetting:signSetting];
}

- (instancetype)initWithNumber:(NSNumber *)number fontSize:(CGFloat)fontSize rowNumber:(NSUInteger)rowNumber {
    return [self initWithNumber:number fontSize:fontSize textColor:[UIColor grayColor] rowNumber:rowNumber];
}

- (instancetype)initWithNumber:(NSNumber *)number fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor signSetting:(SignSetting)signSetting {
    return [self initWithNumber:number fontSize:fontSize textColor:textColor signSetting:signSetting rowNumber:0];
}

- (instancetype)initWithNumber:(NSNumber *)number fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor rowNumber:(NSUInteger)rowNumber {
    return [self initWithNumber:number fontSize:fontSize textColor:textColor signSetting:SignSettingUnsigned rowNumber:rowNumber];
}

- (instancetype)initWithNumber:(NSNumber *)number fontSize:(CGFloat)fontSize signSetting:(SignSetting)signSetting rowNumber:(NSUInteger)rowNumber {
    return [self initWithNumber:number fontSize:fontSize textColor:[UIColor grayColor] signSetting:signSetting rowNumber:rowNumber];
}

- (instancetype)initWithNumber:(NSNumber *)number fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor signSetting:(SignSetting)signSetting rowNumber:(NSUInteger)rowNumber {
    self = [super init];
    if (self) {
        self.targetNumber = number;
        self.currentNumber = number;
        self.font = [UIFont systemFontOfSize:fontSize];
        self.textColor = textColor;
        self.isAnimating = NO;
        self.finishedAnimationCount = 0;
        self.numberRow = (rowNumber > 0 && rowNumber <= 8) ? rowNumber : 0;
        self.maxRowNumber = (self.numberRow == 0) ? 8 : rowNumber;
        self.signSetting = signSetting;
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithNumber:(NSNumber *)number font:(UIFont *)font {
    return [self initWithNumber:number font:font textColor:[UIColor grayColor] rowNumber:0];
}

- (instancetype)initWithNumber:(NSNumber *)number font:(UIFont *)font textColor:(UIColor *)textColor {
    return [self initWithNumber:number font:font textColor:textColor rowNumber:0];
}

- (instancetype)initWithNumber:(NSNumber *)number font:(UIFont *)font signSetting:(SignSetting)signSetting {
    return [self initWithNumber:number font:font textColor:[UIColor grayColor] signSetting:signSetting rowNumber:0];
}

- (instancetype)initWithNumber:(NSNumber *)number font:(UIFont *)font textColor:(UIColor *)textColor signSetting:(SignSetting)signSetting {
    return [self initWithNumber:number font:font textColor:textColor signSetting:signSetting rowNumber:0];
}

- (instancetype)initWithNumber:(NSNumber *)number font:(UIFont *)font textColor:(UIColor *)textColor rowNumber:(NSUInteger)rowNumber {
    return [self initWithNumber:number font:font textColor:textColor signSetting:SignSettingUnsigned rowNumber:rowNumber];
}

- (instancetype)initWithNumber:(NSNumber *)number font:(UIFont *)font signSetting:(SignSetting)signSetting rowNumber:(NSUInteger)rowNumber {
    return [self initWithNumber:number font:font textColor:[UIColor grayColor] signSetting:signSetting rowNumber:rowNumber];
}

- (instancetype)initWithNumber:(NSNumber *)number font:(UIFont *)font textColor:(UIColor *)textColor signSetting:(SignSetting)signSetting rowNumber:(NSUInteger)rowNumber {
    self = [super init];
    if (self) {
        self.targetNumber = number;
        self.currentNumber = number;
        self.font = font;
        self.textColor = textColor;
        self.isAnimating = NO;
        self.finishedAnimationCount = 0;
        self.numberRow = (rowNumber > 0 && rowNumber <= 8) ? rowNumber : 0;
        self.maxRowNumber = (self.numberRow == 0) ? 8 : rowNumber;
        self.signSetting = signSetting;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self initSign];
    [self initCells];
    [self initParent];
}

- (void)initSign {
    switch (self.signSetting) {
        case SignSettingUnsigned:
            self.signRow = 0;
            int displayedNumber = self.targetNumber.intValue;
            if (displayedNumber < 0) {
                self.targetNumber = @(abs(displayedNumber));
            }
            break;
        case SignSettingSigned:
        case SignSettingNormal:
            self.signRow = 1;
            break;
        default:
            break;
    }
}

#pragma mark - ConfigViews

- (void)initParent{
    
    self.bounds = CGRectMake(0, 0, (self.numberRow + self.signRow) * self.cellWidth, self.numberCellHeight / numberCellLineCount);
    self.backgroundColor = [UIColor clearColor];
    self.layer.masksToBounds = YES;
}

- (void)initCells {
    int originNumber = self.targetNumber.intValue;
    int sign = originNumber >= 0 ? 1 : -1;
    if (self.numberRow == 0) {
        self.numberRow = [self calculateNumberRow:originNumber];
    }
    self.cellArray = [[NSMutableArray alloc] init];
    
    CGRect rect = [numberCellText boundingRectWithSize:CGSizeZero
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:self.font}
                                     context:nil];
    self.cellWidth = rect.size.width;
    self.numberCellHeight = rect.size.height;
    self.signCellHeight = rect.size.height * signCellLineCount / numberCellLineCount;
    
    NSArray *displayNumberArray = [self getEachCellValueArrayWithTargetNumber:self.targetNumber.integerValue];
    
    for (NSInteger i = 0; i < self.numberRow; i++) {
        UILabel *numberCell = [self makeNumberCell];
        numberCell.frame = CGRectMake((self.numberRow + self.signRow - 1 - i) * self.cellWidth, 0, self.cellWidth, self.numberCellHeight);
        NSNumber *displayNum = [displayNumberArray objectAtIndex:i];
        [self moveNumberCell:numberCell toNumber:displayNum.integerValue sign:sign];
        [self addSubview:numberCell];
        [self.cellArray addObject:numberCell];
    }
    
    self.signCell.frame = CGRectMake(0, 0, self.cellWidth, self.signCellHeight);
    [self addSubview:self.signCell];
    int displayedNumber = self.targetNumber.intValue;
    if (displayedNumber > 0) {
        [self moveSignCellToSign:SignPositive];
    } else if (displayedNumber < 0) {
        [self moveSignCellToSign:SignNegative];
    } else {
        [self moveSignCellToSign:SignZero];
    }
    
}

- (void)updateCellModelToFitRowNumber:(NSInteger)rowNumber {
    
    if (rowNumber > self.numberRow) {
        for (NSInteger i = self.numberRow; i < rowNumber; i++) {
            UILabel *scrollCell = [self makeNumberCell];
            scrollCell.frame = CGRectMake((self.numberRow + self.signRow - 1 - i) * self.cellWidth, -self.numberCellHeight * 10 / numberCellLineCount, self.cellWidth, self.numberCellHeight);
            [self.cellArray addObject:scrollCell];
        }
    }else {
        for (NSInteger i = rowNumber; i < self.numberRow; i++) {
            [self.cellArray removeLastObject];
        }
    }
}

- (void)updateCellLayoutToFitRowNumber:(NSUInteger)rowNumber withAnimation:(BOOL)animated{
    
    if (rowNumber == self.numberRow) {
        return ;
    }
    [self.cellArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (UILabel *cell in self.cellArray) {
        [self addSubview:cell];
    }
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 * (rowNumber - self.numberRow) animations:^{
        for (int i = 0; i < rowNumber; i++) {
            UILabel *cell = [weakSelf.cellArray objectAtIndex:i];
            cell.frame = CGRectMake((rowNumber + self.signRow - 1 - i) * weakSelf.cellWidth,
                                    cell.frame.origin.y,
                                    weakSelf.cellWidth,
                                    weakSelf.numberCellHeight);
        }
        self.frame = CGRectMake(self.frame.origin.x,
                                self.frame.origin.y,
                                (rowNumber + self.signRow) * self.cellWidth,
                                self.numberCellHeight/numberCellLineCount);
    } completion:nil];
}

#pragma mark - Animation

- (void)playAnimationWithChange:(NSInteger)changeValue previousNumber:(NSNumber *)previousNumber interval:(CGFloat)interval{
    
    BOOL signChanged = (previousNumber.intValue * self.targetNumber.intValue) < 0;
    int sign = self.targetNumber.intValue >= 0 ? 1 : -1;
    if (signChanged) {
        sign = previousNumber.intValue >= 0 ? 1 : -1;
        CGFloat interval2 = (CGFloat)fabs(self.targetNumber.integerValue * interval / (CGFloat)changeValue);
        NSInteger changeValue2 = self.targetNumber.integerValue;
        DPAnimationTask *task = [[DPAnimationTask alloc] init];
        task.targetNumber = self.targetNumber.integerValue;
        task.interval = interval2;
        task.changeValue = changeValue2;
        @synchronized (self.taskQueue) {
            [self.taskQueue addObject:task];
        }
        changeValue = - previousNumber.integerValue;
        interval = interval - interval2;
        self.targetNumber = @0;
    } else if (previousNumber.intValue == 0) {
        [self makeSignChangeAnimation];
    } else if (self.targetNumber.intValue == 0) {
        sign = previousNumber.intValue >= 0 ? 1 : -1;
        [self makeSignChangeAnimation];
    }
    
    NSInteger targetRowNumber = [self calculateNumberRow:self.targetNumber.intValue];
    
    if (targetRowNumber > self.numberRow) {
        [self updateCellModelToFitRowNumber:targetRowNumber];
        [self updateCellLayoutToFitRowNumber:targetRowNumber withAnimation:YES];
        self.numberRow = targetRowNumber;
    }
    
    NSArray *repeatCountArray = [self getRepeatTimesWithChangeNumber:changeValue targetNumber:self.targetNumber.integerValue];
    NSArray *targetDisplayNums = [self getEachCellValueArrayWithTargetNumber:self.targetNumber.integerValue];
    
    if (interval == 0) {
        interval = [self getIntervalWithPreviousNumber:previousNumber.integerValue targetNumber:self.targetNumber.integerValue];
    }
    
    ScrollAnimationDirection direction = ((changeValue * sign) > 0)? ScrollAnimationDirectionIncrease : ScrollAnimationDirectionDecrease;
    
    CGFloat delay = 0.0f;
    
    if (repeatCountArray.count != 0) {
        for (NSInteger i = 0; i < repeatCountArray.count; i++) {
            NSNumber *repeat = [repeatCountArray objectAtIndex:i];
            NSInteger repeatCount = repeat.integerValue;
            NSNumber *willDisplayNum = [targetDisplayNums objectAtIndex:i];
            UILabel *cell = [self.cellArray objectAtIndex:i];
            CGFloat startDuration = 0;
            
            if (repeatCount == 0) {
                [self makeSingleAnimationWithCell:cell duration:interval delay:delay animationCount:repeatCountArray.count displayNumber:willDisplayNum.integerValue];
            }else {
                if (direction == ScrollAnimationDirectionIncrease) {
                    
                    startDuration = interval * (10 - [self getValueOfCell:cell]) / ceilf(fabs(changeValue / pow(10, i)));
                    CGFloat cycleDuration = interval * 10 / fabs(changeValue / pow(10, i));
                    if (repeatCount == 1) {
                        cycleDuration = 0;
                    }
                    CGFloat endDuration = bufferModulus * pow(willDisplayNum.integerValue, 0.3) / (i + 1);
                    DPAnimationAttribute *attribute = [[DPAnimationAttribute alloc] init];
                    attribute.startDuration = startDuration;
                    attribute.startDelay = delay;
                    attribute.cycleDuration = cycleDuration;
                    attribute.endDuration = endDuration;
                    attribute.repeatCount = repeatCount - 1;
                    attribute.targetNumber = willDisplayNum.integerValue;
                    attribute.sign = sign;
                    [self makeMultiAnimationWithCell:cell direction:direction animationCount:repeatCountArray.count attribute:attribute];
                }else if (direction == ScrollAnimationDirectionDecrease) {
                    startDuration = interval * ([self getValueOfCell:cell] - 0) / ceilf(fabs(changeValue / pow(10, i)));
                    CGFloat cycleDuration = interval * 10 / fabs(changeValue / pow(10, i));
                    if (repeatCount == 1) {
                        cycleDuration = 0;
                    }
                    CGFloat endDuration = bufferModulus * pow(10 - willDisplayNum.integerValue, 0.3) / (i + 1);
                    DPAnimationAttribute *attribute = [[DPAnimationAttribute alloc] init];
                    attribute.startDuration = startDuration;
                    attribute.startDelay = delay;
                    attribute.cycleDuration = cycleDuration;
                    attribute.endDuration = endDuration;
                    attribute.repeatCount = repeatCount - 1;
                    attribute.targetNumber = willDisplayNum.integerValue;
                    attribute.sign = sign;
                    [self makeMultiAnimationWithCell:cell direction:direction animationCount:repeatCountArray.count attribute:attribute];
                }
            }
            delay = delay + startDuration;
        }
        
    }
}

- (void)makeMultiAnimationWithCell:(UILabel *)cell
                         direction:(ScrollAnimationDirection)direction
                    animationCount:(NSInteger)count
                         attribute:(DPAnimationAttribute *)attribute{
    
    [UIView animateWithDuration:attribute.startDuration delay:attribute.startDelay options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self moveNumberCell:cell toNumber:(direction == ScrollAnimationDirectionIncrease)? 10 : 0 sign:attribute.sign];
    } completion:^(BOOL finished) {
        NSLog(@"start animation finish!");
        [self moveNumberCell:cell toNumber:(direction == ScrollAnimationDirectionIncrease)? 0 : 10 sign:attribute.sign];
        if (attribute.cycleDuration == 0) {
            [UIView animateWithDuration:attribute.endDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self moveNumberCell:cell toNumber:attribute.targetNumber sign:attribute.sign];
            } completion:^(BOOL finished) {
                [self oneAnimationDidFinishedWithTotalCount:count];
                NSLog(@"end animation finish!");
            }];
        }else {
            [UIView animateWithDuration:attribute.cycleDuration delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat animations:^{
                [UIView setAnimationRepeatCount:attribute.repeatCount];
                [self moveNumberCell:cell toNumber:(direction == ScrollAnimationDirectionIncrease) ? 10 : 0 sign:attribute.sign];
            } completion:^(BOOL finished) {
                NSLog(@"cycle animation finish!");
                [self moveNumberCell:cell toNumber:(direction == ScrollAnimationDirectionIncrease)?0 : 10 sign:attribute.sign];
                [UIView animateWithDuration:attribute.endDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self moveNumberCell:cell toNumber:attribute.targetNumber sign:attribute.sign];
                } completion:^(BOOL finished) {
                    [self oneAnimationDidFinishedWithTotalCount:count];
                    NSLog(@"end animation finish!");
                }];
            }];
        }
    }];
}

- (void)makeSingleAnimationWithCell:(UILabel *)cell duration:(CGFloat)duration delay:(CGFloat)delay animationCount:(NSInteger)count displayNumber:(NSInteger)displayNumber{
    int sign = displayNumber >= 0 ? 1 : -1;
    
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self moveNumberCell:cell toNumber:displayNumber sign:sign];
    } completion:^(BOOL finished) {
        [self oneAnimationDidFinishedWithTotalCount:count];
        NSLog(@"single animation finish!");
    }];
}

- (void)makeSignChangeAnimation {
    Sign sign;
    if (self.targetNumber.intValue > 0) {
        sign = SignPositive;
    } else if (self.targetNumber.intValue < 0) {
        sign = SignNegative;
    } else {
        sign = SignZero;
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self moveSignCellToSign:sign];
    }];
}

- (void)oneAnimationDidFinishedWithTotalCount:(NSInteger)totalCount {
    self.finishedAnimationCount++;
    if (self.finishedAnimationCount == totalCount) {
        self.finishedAnimationCount = 0;
        [self checkTaskArray];
    }
}

- (void)checkTaskArray {
    @synchronized (self.taskQueue) {
        if (self.taskQueue.count != 0) {
            DPAnimationTask *task = [self.taskQueue firstObject];
            [self.taskQueue removeObject:task];
            NSNumber *previousNumber = self.targetNumber;
            self.targetNumber = @(task.targetNumber);
            [self playAnimationWithChange:task.changeValue previousNumber:previousNumber interval:task.interval];
        } else {
            self.isAnimating = NO;
        }
    }
}

#pragma mark - Public Method

- (void)changeToNumber:(NSNumber *)number animated:(BOOL)animated {
    
    [self changeToNumber:number interval:0 animated:animated];
}

- (void)changeToNumber:(NSNumber *)number interval:(CGFloat)interval animated:(BOOL)animated {
    
    if (self.signSetting == SignSettingUnsigned && number.intValue < 0) {
        return ;
    }
    if ([self calculateNumberRow:number.integerValue] > self.maxRowNumber) {
        return ;
    }
    if (number.integerValue == self.currentNumber.integerValue) {
        return ;
    }
    if (self.isAnimating) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            DPAnimationTask *task = [[DPAnimationTask alloc] init];
            task.targetNumber = number.integerValue;
            task.changeValue = number.integerValue - self.targetNumber.integerValue;
            task.interval = interval;
            @synchronized (self.taskQueue) {
                [self.taskQueue removeAllObjects];
                [self.taskQueue addObject:task];
            }
        });
    } else {
        NSNumber *previousNumber = self.targetNumber;
        self.targetNumber = number;
        if (animated) {
            [self playAnimationWithChange:number.integerValue - previousNumber.integerValue previousNumber:previousNumber interval:interval];
            self.isAnimating = YES;
        } else {
            int sign = number.integerValue >= 0 ? 1 : -1;
            NSArray<NSNumber *> *displayNumbers = [self getEachCellValueArrayWithTargetNumber:number.integerValue];
            for (int i = 0; i < displayNumbers.count; i++) {
                [self moveNumberCell:self.cellArray[i] toNumber:displayNumbers[i].integerValue sign:sign];
            }
        }
    }
    self.currentNumber = number;
}

#pragma mark - Privite Method

- (NSInteger)calculateNumberRow:(NSInteger)number {
    NSInteger numberRow = 1;
    while ((number = number / 10) != 0) {
        numberRow++;
    }
    return numberRow;
}

- (void)moveNumberCell:(UILabel *)cell toNumber:(NSInteger)number sign:(NSInteger)sign{
    CGFloat x = cell.frame.origin.x;
    CGFloat floatNumber = abs((int)number);
    CGFloat y = - self.numberCellHeight / numberCellLineCount * 10 - sign * ((CGFloat)floatNumber / numberCellLineCount) * self.numberCellHeight;
    cell.frame = CGRectMake(x, y, self.cellWidth, self.numberCellHeight);
}

- (void)moveSignCellToSign:(Sign)sign {
    CGFloat x = self.signCell.frame.origin.x;
    CGFloat y = - ((CGFloat)sign / signCellLineCount) * self.signCellHeight;
    self.signCell.frame = CGRectMake(x, y, self.cellWidth, self.signCellHeight);
}

- (NSArray<NSNumber *> *)getRepeatTimesWithChangeNumber:(NSInteger)change targetNumber:(NSInteger)targetNumber{
    NSMutableArray *repeatTimesArray = [[NSMutableArray alloc] init];
    NSInteger originNumber = targetNumber - change;
    if (change > 0) {
        do {
            targetNumber = (targetNumber / 10) * 10;
            originNumber = (originNumber / 10) * 10;
            NSNumber *repeat = @((targetNumber - originNumber) / 10);
            [repeatTimesArray addObject:repeat];
            targetNumber = targetNumber / 10;
            originNumber = originNumber / 10;
        } while ((targetNumber - originNumber) != 0);
    }else {
        do {
            targetNumber = (targetNumber / 10) * 10;
            originNumber = (originNumber / 10) * 10;
            NSNumber *repeat = @((originNumber - targetNumber) / 10);
            [repeatTimesArray addObject:repeat];
            targetNumber = targetNumber / 10;
            originNumber = originNumber / 10;
        } while ((originNumber - targetNumber) != 0);
    }
    return repeatTimesArray;
}

- (NSArray<NSNumber *> *)getEachCellValueArrayWithTargetNumber:(NSInteger)targetNumber {
    
    NSMutableArray *cellValueArray = [[NSMutableArray alloc] init];
    NSInteger tmp;
    for (NSInteger i = 0; i < self.numberRow; i++) {
        tmp = targetNumber % 10;
        NSNumber *number = @(tmp);
        [cellValueArray addObject:number];
        targetNumber = targetNumber / 10;
    }
    
    return cellValueArray;
}

- (NSInteger)getValueOfCell:(UILabel *)cell {
    CGFloat y = cell.frame.origin.y;
    CGFloat tmpNumber = (- (y * numberCellLineCount / self.numberCellHeight)) - 10;
    NSInteger displayNumber = (NSInteger)roundf(tmpNumber);
    displayNumber = abs((int)displayNumber);
    return displayNumber;
}

- (CGFloat)getIntervalWithPreviousNumber:(NSInteger)previousNumber targetNumber:(NSInteger)targetNumber {
    
    NSArray *repeatTimesArray = [self getRepeatTimesWithChangeNumber:targetNumber - previousNumber targetNumber:targetNumber];
    NSUInteger count = repeatTimesArray.count;
    NSInteger tmp1 = targetNumber / (NSInteger)pow(10, count - 1);
    NSInteger tmp2 = previousNumber / (NSInteger)pow(10, count - 1);
    
    NSLog(@"tmp1:%ld tmp2:%ld", (long)tmp1, (long)tmp2);
    NSInteger maxChangeNum = labs(tmp1 % 10 - tmp2 % 10);
    
    return normalModulus * count * maxChangeNum;
    
}

#pragma mark - Getters

- (UILabel *)makeNumberCell {
    UILabel *cell = [[UILabel alloc] init];
    cell.font = self.font;
    cell.numberOfLines = numberCellLineCount;
    cell.textColor = self.textColor;
    cell.text = numberCellText;
    return  cell;
}

- (UILabel *)signCell {
    if (!_signCell) {
        _signCell = [[UILabel alloc] init];
        _signCell.font = self.font;
        _signCell.numberOfLines = signCellLineCount;
        switch (self.signSetting) {
            case SignSettingNormal:
                _signCell.text = @"-\n \n ";
                break;
            case SignSettingUnsigned:
                _signCell.text = @" \n \n ";
                break;
            case SignSettingSigned:
                _signCell.text = @"-\n \n+";
                break;
            default:
                break;
        }
        _signCell.textColor = self.textColor;
    }
    return _signCell;
}

- (NSMutableArray *)taskQueue {
    if (!_taskQueue) {
        _taskQueue = [NSMutableArray arrayWithCapacity:1];
    }
    return _taskQueue;
}

@end
