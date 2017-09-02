//
//  DPScrollNumberLabel.m
//  DPScrollNumberLabelDemo
//
//  Created by Dai Pei on 16/5/23.
//  Copyright © 2016年 Dai Pei. All rights reserved.
//

#import "DPScrollNumberLabel.h"

//attribute key
#define keyRepeatCount              @"repeatCount"
#define keyStartDuration            @"startDuration"
#define keyCycleDuration            @"cycleDuration"
#define keyEndDuration              @"endDuration"
#define keyScrollCell               @"scrollCell"
#define keyDisplayNumber            @"displayNumber"
#define keyStartDelay               @"startDelay"

//task key
#define keyTaskDisplayNumber        @"displayNumber"
#define keyTaskChangeNumber         @"changeNumber"
#define keyTaskInterval             @"interval"

typedef NS_ENUM(NSUInteger, ScrollAnimationDirection) {
    ScrollAnimationDirectionUp,
    ScrollAnimationDirectionDown,
    ScrollAnimationDirectionNumber
};

typedef NS_ENUM(NSUInteger, Sign) {
    SignNegative = 0,
    SignZero = 1, // when the display number is zero, there is no sign
    SignPositive = 2
};

static const CGFloat normalModulus = 0.3f;
static const CGFloat bufferModulus = 0.7f;

static const NSUInteger numberCellLineCount = 11;
static const NSUInteger signCellLineCount = 3;

static NSString * const numberCellText = @"0\n1\n2\n3\n4\n5\n6\n7\n8\n9\n0";

@interface DPScrollNumberLabel()

@property (nonatomic, strong, readwrite) NSNumber           *displayedNumber;
@property (nonatomic, strong) NSMutableArray<UILabel *>     *cellArray;
@property (nonatomic, strong) UILabel                       *signCell;
@property (nonatomic, assign) CGFloat                       fontSize;
@property (nonatomic, assign) NSUInteger                    numberRow;
@property (nonatomic, strong) NSMutableArray                *taskArray;
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

- (instancetype)initWithNumber:(NSNumber *)originNumber fontSize:(CGFloat)size {
    return [self initWithNumber:originNumber fontSize:size textColor:[UIColor grayColor] rowNumber:0];
}

- (instancetype)initWithNumber:(NSNumber *)originNumber fontSize:(CGFloat)size textColor:(UIColor *)color {
    return [self initWithNumber:originNumber fontSize:size textColor:color rowNumber:0];
}

- (instancetype)initWithNumber:(NSNumber *)originNumber fontSize:(CGFloat)size signSetting:(SignSetting)signSetting {
    return [self initWithNumber:originNumber fontSize:size textColor:[UIColor grayColor] signSetting:signSetting];
}

- (instancetype)initWithNumber:(NSNumber *)originNumber fontSize:(CGFloat)size rowNumber:(NSUInteger)rowNumber {
    return [self initWithNumber:originNumber fontSize:size textColor:[UIColor grayColor] rowNumber:rowNumber];
}

- (instancetype)initWithNumber:(NSNumber *)originNumber fontSize:(CGFloat)size textColor:(UIColor *)color signSetting:(SignSetting)signSetting {
    return [self initWithNumber:originNumber fontSize:size textColor:color signSetting:signSetting rowNumber:0];
}


- (instancetype)initWithNumber:(NSNumber *)originNumber fontSize:(CGFloat)size textColor:(UIColor *)color rowNumber:(NSUInteger)rowNumber {
    return [self initWithNumber:originNumber fontSize:size textColor:color signSetting:SignSettingUnsigned rowNumber:rowNumber];
}

- (instancetype)initWithNumber:(NSNumber *)originNumber fontSize:(CGFloat)size signSetting:(SignSetting)signSetting rowNumber:(NSUInteger)rowNumber {
    return [self initWithNumber:originNumber fontSize:size textColor:[UIColor grayColor] signSetting:signSetting rowNumber:rowNumber];
}

- (instancetype)initWithNumber:(NSNumber *)originNumber fontSize:(CGFloat)size textColor:(UIColor *)color signSetting:(SignSetting)signSetting rowNumber:(NSUInteger)rowNumber {
    self = [super init];
    if (self) {
        self.displayedNumber = originNumber;
        self.font = [UIFont systemFontOfSize:size];
        self.textColor = color;
        self.isAnimating = NO;
        self.finishedAnimationCount = 0;
        self.numberRow = (rowNumber > 0 && rowNumber <= 8) ? rowNumber : 0;
        self.maxRowNumber = (self.numberRow == 0) ? 8 : rowNumber;
        self.signSetting = signSetting;
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithNumber:(NSNumber *)originNumber font:(UIFont *)font {
    return [self initWithNumber:originNumber font:font textColor:[UIColor grayColor] rowNumber:0];
}

- (instancetype)initWithNumber:(NSNumber *)originNumber font:(UIFont *)font textColor:(UIColor *)color {
    return [self initWithNumber:originNumber font:font textColor:[UIColor grayColor] rowNumber:0];
}

- (instancetype)initWithNumber:(NSNumber *)originNumber font:(UIFont *)font signSetting:(SignSetting)signSetting {
    return [self initWithNumber:originNumber font:font textColor:[UIColor grayColor] signSetting:signSetting rowNumber:0];
}

- (instancetype)initWithNumber:(NSNumber *)originNumber font:(UIFont *)font textColor:(UIColor *)color signSetting:(SignSetting)signSetting {
    return [self initWithNumber:originNumber font:font textColor:color signSetting:signSetting rowNumber:0];
}

- (instancetype)initWithNumber:(NSNumber *)originNumber font:(UIFont *)font textColor:(UIColor *)color rowNumber:(NSUInteger)rowNumber {
    return [self initWithNumber:originNumber font:font textColor:color signSetting:SignSettingUnsigned rowNumber:rowNumber];
}

- (instancetype)initWithNumber:(NSNumber *)originNumber font:(UIFont *)font signSetting:(SignSetting)signSetting rowNumber:(NSUInteger)rowNumber {
    return [self initWithNumber:originNumber font:font textColor:[UIColor grayColor] signSetting:signSetting rowNumber:rowNumber];
}

- (instancetype)initWithNumber:(NSNumber *)originNumber font:(UIFont *)font textColor:(UIColor *)color signSetting:(SignSetting)signSetting rowNumber:(NSUInteger)rowNumber {
    self = [super init];
    if (self) {
        self.displayedNumber = originNumber;
        self.font = font;
        self.textColor = color;
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
            int displayedNumber = self.displayedNumber.intValue;
            if (displayedNumber < 0) {
                self.displayedNumber = @(abs(displayedNumber));
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
    
//    [self layoutCell:self.numberRow withAnimation:YES];
    
}

- (void)initCells {
    int originNumber = self.displayedNumber.intValue;
    
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
    
    NSArray *displayNumberArray = [self getEachCellNumberArrayWithDisplayedNumber:self.displayedNumber.integerValue];
    
    for (NSInteger i = 0; i < self.numberRow; i++) {
        UILabel *numberCell = [self makeNumberCell];
        numberCell.frame = CGRectMake((self.numberRow + self.signRow - 1 - i) * self.cellWidth, 0, self.cellWidth, self.numberCellHeight);
        NSNumber *displayNum = [displayNumberArray objectAtIndex:i];
        [self setNumberCell:numberCell toNumber:displayNum.integerValue];
        [self addSubview:numberCell];
        [self.cellArray addObject:numberCell];
    }
    
    self.signCell.frame = CGRectMake(0, 0, self.cellWidth, self.signCellHeight);
    [self addSubview:self.signCell];
    int displayedNumber = self.displayedNumber.intValue;
    if (displayedNumber > 0) {
        [self setSignCellToSign:SignPositive];
    } else if (displayedNumber < 0) {
        [self setSignCellToSign:SignNegative];
    } else {
        [self setSignCellToSign:SignZero];
    }
    
}

- (void)updateCellModelToFitRowNumber:(NSInteger)rowNumber {
    
    if (rowNumber > self.numberRow) {
        for (NSInteger i = self.numberRow; i < rowNumber; i++) {
            UILabel *scrollCell = [self makeNumberCell];
            scrollCell.frame = CGRectMake((self.numberRow + self.signRow - 1 - i) * self.cellWidth, 0, self.cellWidth, self.numberCellHeight);
            [self.cellArray addObject:scrollCell];
        }
    }else {
        for (NSInteger i = rowNumber; i < self.numberRow; i++) {
            [self.cellArray removeLastObject];
        }
    }
}

- (void)updateCellLayoutToFitRowNumber:(NSUInteger)rowNumber withAnimation:(BOOL)animated{
    
//    for (UIView *subView in self.subviews) {
//        [subView removeFromSuperview];
//    }
    
    if (rowNumber == self.numberRow) {
        return ;
    }
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
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

- (void)playAnimationWithChange:(NSInteger)changeNumber displayNumber:(NSNumber *)displayNumber interval:(CGFloat)interval{
    
    NSInteger nextRowNumber = [self calculateNumberRow:displayNumber.intValue];
    
    if (nextRowNumber > self.numberRow) {
        [self updateCellModelToFitRowNumber:nextRowNumber];
        [self updateCellLayoutToFitRowNumber:nextRowNumber withAnimation:YES];
        self.numberRow = nextRowNumber;
    }
    
    NSArray *repeatCountArray = [self getRepeatTimesWithChangeNumber:changeNumber displayNumber:displayNumber.integerValue];
    NSArray *willDisplayNums = [self getEachCellNumberArrayWithDisplayedNumber:displayNumber.integerValue];
    
    if (interval == 0) {
        interval = [self getIntervalWithOriginalNumber:displayNumber.integerValue - changeNumber displayNumber:displayNumber.integerValue];
    }
    
    ScrollAnimationDirection direction = (changeNumber > 0)? ScrollAnimationDirectionUp : ScrollAnimationDirectionDown;
    
    CGFloat delay = 0.0f;
    
    if (repeatCountArray.count != 0) {
        for (NSInteger i = 0; i < repeatCountArray.count; i++) {
            NSNumber *repeat = [repeatCountArray objectAtIndex:i];
            NSInteger repeatCount = repeat.integerValue;
            NSNumber *willDisplayNum = [willDisplayNums objectAtIndex:i];
            UILabel *cell = [self.cellArray objectAtIndex:i];
            CGFloat startDuration = 0;
            
            if (repeatCount == 0) {
                [self makeSingleAnimationWithCell:cell duration:interval delay:delay animationCount:repeatCountArray.count displayNumber:willDisplayNum.integerValue];
            }else {
                if (direction == ScrollAnimationDirectionUp) {
                    
                    startDuration = interval * (10 - [self getDisplayedNumberOfCell:cell]) / ceilf(fabs(changeNumber / pow(10, i)));
                    CGFloat cycleDuration = interval * 10 / fabs(changeNumber / pow(10, i));
                    if (repeatCount == 1) {
                        cycleDuration = 0;
                    }
                    CGFloat endDuration = bufferModulus * pow(willDisplayNum.integerValue, 0.3) / (i + 1);
                    NSDictionary *attribute = @{keyStartDuration:   @(startDuration),
                                                keyStartDelay:      @(delay),
                                                keyCycleDuration:   @(cycleDuration),
                                                keyEndDuration:     @(endDuration),
                                                keyRepeatCount:     @(repeatCount - 1),
                                                keyDisplayNumber:   willDisplayNum};
                    [self makeMultiAnimationWithCell:cell direction:direction animationCount:repeatCountArray.count attribute:attribute];
                }else if (direction == ScrollAnimationDirectionDown) {
                    startDuration = interval * ([self getDisplayedNumberOfCell:cell] - 0) / ceilf(fabs(changeNumber / pow(10, i)));
                    CGFloat cycleDuration = interval * 10 / fabs(changeNumber / pow(10, i));
                    if (repeatCount == 1) {
                        cycleDuration = 0;
                    }
                    CGFloat endDuration = bufferModulus * pow(10 - willDisplayNum.integerValue, 0.3) / (i + 1);
                    NSDictionary *attribute = @{keyStartDuration:   @(startDuration),
                                                keyStartDelay:      @(delay),
                                                keyCycleDuration:   @(cycleDuration),
                                                keyEndDuration:     @(endDuration),
                                                keyRepeatCount:     @(repeatCount - 1),
                                                keyDisplayNumber:   willDisplayNum};
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
                         attribute:(NSDictionary *)attribute{
    NSNumber *startDuration = [attribute objectForKey:keyStartDuration];
    NSNumber *cycleDuration = [attribute objectForKey:keyCycleDuration];
    NSNumber *endDuration = [attribute objectForKey:keyEndDuration];
    NSNumber *repeatCount = [attribute objectForKey:keyRepeatCount];
    NSNumber *willDisplayNum = [attribute objectForKey:keyDisplayNumber];
    NSNumber *startDelay = [attribute objectForKey:keyStartDelay];
    
    [UIView animateWithDuration:startDuration.floatValue delay:startDelay.floatValue options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self setNumberCell:cell toNumber:(direction == ScrollAnimationDirectionUp)?10 : 0];
    } completion:^(BOOL finished) {
        NSLog(@"start animation finish!");
        [self setNumberCell:cell toNumber:(direction == ScrollAnimationDirectionUp)?0 : 10];
        
        if (cycleDuration.floatValue == 0) {
            [UIView animateWithDuration:endDuration.floatValue delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self setNumberCell:cell toNumber:willDisplayNum.integerValue];
            } completion:^(BOOL finished) {
                [self checkTaskArrayWithAnimationCount:count];
                NSLog(@"end animation finish!");
            }];
        }else {
            [UIView animateWithDuration:cycleDuration.floatValue delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat animations:^{
                [UIView setAnimationRepeatCount:repeatCount.integerValue];
                switch (direction) {
                    case ScrollAnimationDirectionUp:
                        [self setNumberCell:cell toNumber:10];
                        break;
                    case ScrollAnimationDirectionDown:
                        [self setNumberCell:cell toNumber:0];
                        break;
                    default:
                        break;
                }
            } completion:^(BOOL finished) {
                NSLog(@"cycle animation finish!");
                [self setNumberCell:cell toNumber:(direction == ScrollAnimationDirectionUp)?0 : 10];
                [UIView animateWithDuration:endDuration.floatValue delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self setNumberCell:cell toNumber:willDisplayNum.integerValue];
                } completion:^(BOOL finished) {
                    [self checkTaskArrayWithAnimationCount:count];
                    NSLog(@"end animation finish!");
                }];
            }];
        }
    }];
}

- (void)makeSingleAnimationWithCell:(UILabel *)cell duration:(CGFloat)duration delay:(CGFloat)delay animationCount:(NSInteger)count displayNumber:(NSInteger)displayNumber{
    
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self setNumberCell:cell toNumber:displayNumber];
    } completion:^(BOOL finished) {
        [self checkTaskArrayWithAnimationCount:count];
        NSLog(@"single animation finish!");
    }];
}

- (void)checkTaskArrayWithAnimationCount:(NSInteger)count {
    self.finishedAnimationCount++;
    if (self.finishedAnimationCount == count) {
        self.finishedAnimationCount = 0;
        if (self.taskArray.count != 0) {
            NSDictionary *task = [self.taskArray objectAtIndex:0];
            [self.taskArray removeObject:task];
            NSNumber *displayNumber = [task objectForKey:keyTaskDisplayNumber];
            NSNumber *changeNumber = [task objectForKey:keyTaskChangeNumber];
            NSNumber *interval = [task objectForKey:keyTaskInterval];
            [self playAnimationWithChange:changeNumber.integerValue displayNumber:displayNumber interval:interval.floatValue];
        }else {
            self.isAnimating = NO;
        }
    }
}

#pragma mark - Public Method

- (void)changeToNumber:(NSNumber *)number animated:(BOOL)animated {
    
    [self changeToNumber:number interval:0 animated:animated];
}

- (void)changeToNumber:(NSNumber *)number interval:(CGFloat)interval animated:(BOOL)animated {
    
    if (number.integerValue < 0) {
        return ;
    }
    
    if ([self calculateNumberRow:number.integerValue] > self.maxRowNumber) {
        return ;
    }
    
    if (number.integerValue == self.displayedNumber.integerValue) {
        return ;
    }
    if (self.isAnimating) {
        if (!self.taskArray) {
            self.taskArray = [NSMutableArray array];
        }
        [self.taskArray addObject:@{keyTaskDisplayNumber:number, keyTaskChangeNumber:@(number.integerValue - self.displayedNumber.integerValue),keyTaskInterval:@(interval)}];
    }else {
        if (animated) {
            [self playAnimationWithChange:number.integerValue - self.displayedNumber.integerValue displayNumber:number interval:interval];
            self.isAnimating = YES;
        } else {
            if (animated) {
                [self playAnimationWithChange:number.integerValue - self.displayedNumber.integerValue displayNumber:number interval:interval];
                self.isAnimating = YES;
            } else {
                NSArray<NSNumber *> *displayNumbers = [self getEachCellNumberArrayWithDisplayedNumber:number.integerValue];
                for (int i = 0; i < displayNumbers.count; i++) {
                    [self setNumberCell:self.cellArray[i] toNumber:displayNumbers[i].integerValue];
                }
            }
        }
    }
    self.displayedNumber = number;
}

#pragma mark - Privite Method



- (NSInteger)calculateNumberRow:(NSInteger)number {
    NSInteger numberRow = 1;
    while ((number = number / 10) != 0) {
        numberRow++;
    }
    return numberRow;
}

- (void)setNumberCell:(UILabel *)cell toNumber:(NSInteger)number {
    CGFloat x = cell.frame.origin.x;
    CGFloat floatNumber = abs((int)number);
    CGFloat y = - ((CGFloat)floatNumber / numberCellLineCount) * self.numberCellHeight;
    cell.frame = CGRectMake(x, y, self.cellWidth, self.numberCellHeight);
}

- (void)setSignCellToSign:(Sign)sign {
    CGFloat x = self.signCell.frame.origin.x;
    CGFloat y = - ((CGFloat)sign / signCellLineCount) * self.signCellHeight;
    self.signCell.frame = CGRectMake(x, y, self.cellWidth, self.signCellHeight);
}

- (NSArray<NSNumber *> *)getRepeatTimesWithChangeNumber:(NSInteger)change displayNumber:(NSInteger)number{
    NSMutableArray *repeatTimesArray = [[NSMutableArray alloc] init];
    NSInteger originNumber = number - change;
    if (change > 0) {
        do {
            number = (number / 10) * 10;
            originNumber = (originNumber / 10) * 10;
            NSNumber *repeat = @((number - originNumber) / 10);
            [repeatTimesArray addObject:repeat];
            number = number / 10;
            originNumber = originNumber / 10;
        } while ((number - originNumber) != 0);
    }else {
        do {
            number = (number / 10) * 10;
            originNumber = (originNumber / 10) * 10;
            NSNumber *repeat = @((originNumber - number) / 10);
            [repeatTimesArray addObject:repeat];
            number = number / 10;
            originNumber = originNumber / 10;
        } while ((originNumber - number) != 0);
    }
    return repeatTimesArray;
}

- (NSArray<NSNumber *> *)getEachCellNumberArrayWithDisplayedNumber:(NSInteger)displayedNumber {
    
    NSMutableArray *cellDisplayedNumbers = [[NSMutableArray alloc] init];
    NSInteger tmpNumber;
    for (NSInteger i = 0; i < self.numberRow; i++) {
        tmpNumber = displayedNumber % 10;
        NSNumber *number = @(tmpNumber);
        [cellDisplayedNumbers addObject:number];
        displayedNumber = displayedNumber / 10;
    }
    
    return cellDisplayedNumbers;
}

- (NSInteger)getDisplayedNumberOfCell:(UILabel *)cell {
    CGFloat y = cell.frame.origin.y;
    CGFloat tmpNumber = (- (y * numberCellLineCount / self.numberCellHeight));
    NSInteger displayNumber = (NSInteger)roundf(tmpNumber);
    return displayNumber;
}

- (CGFloat)getIntervalWithOriginalNumber:(NSInteger)number displayNumber:(NSInteger)displayNumber {
    
    NSArray *repeatTimesArray = [self getRepeatTimesWithChangeNumber:displayNumber - number displayNumber:displayNumber];
    NSUInteger count = repeatTimesArray.count;
    NSInteger tmp1 = displayNumber / (NSInteger)pow(10, count - 1);
    NSInteger tmp2 = number / (NSInteger)pow(10, count - 1);
    
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

@end
