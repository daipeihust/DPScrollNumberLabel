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

static const CGFloat normalModulus = 0.3f;
static const CGFloat bufferModulus = 0.7f;

@interface DPScrollNumberLabel()

@property (nonatomic, strong)NSMutableArray<UILabel *>  *cellArray;
@property (nonatomic, assign)CGFloat                    fontSize;
@property (nonatomic, assign)NSUInteger                 rowNumber;
@property (nonatomic, strong)NSMutableArray             *taskArray;
@property (nonatomic, assign)BOOL                       isAnimation;
@property (nonatomic, assign)CGFloat                    cellWidth;
@property (nonatomic, assign)CGFloat                    cellHeight;
@property (nonatomic, assign)NSInteger                  finishedAnimationCount;
@property (nonatomic, assign)NSUInteger                 maxRowNumber;
@property (nonatomic, strong)UIColor                    *textColor;
@property (nonatomic, strong)UIFont                     *font;

@end

@implementation DPScrollNumberLabel

#pragma mark - Init

- (instancetype)initWithNumber:(NSNumber *)originNumber fontSize:(CGFloat)size {
    return [self initWithNumber:originNumber fontSize:size textColor:[UIColor grayColor] rowNumber:0];
}

- (instancetype)initWithNumber:(NSNumber *)originNumber fontSize:(CGFloat)size textColor:(UIColor *)color {
    return [self initWithNumber:originNumber fontSize:size textColor:color rowNumber:0];
}

- (instancetype)initWithNumber:(NSNumber *)originNumber fontSize:(CGFloat)size rowNumber:(NSUInteger)rowNumber {
    return [self initWithNumber:originNumber fontSize:size textColor:[UIColor grayColor] rowNumber:rowNumber];
}

- (instancetype)initWithNumber:(NSNumber *)originNumber fontSize:(CGFloat)size textColor:(UIColor *)color rowNumber:(NSUInteger)rowNumber {
    self = [super init];
    if (self) {
        self.displayedNumber = originNumber;
        self.font = [UIFont systemFontOfSize:size];
        self.textColor = color;
        self.isAnimation = NO;
        self.finishedAnimationCount = 0;
        self.rowNumber = (rowNumber > 0 && rowNumber <= 8) ? rowNumber : 0;
        self.maxRowNumber = (self.rowNumber == 0) ? 8 : rowNumber;
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

- (instancetype)initWithNumber:(NSNumber *)originNumber font:(UIFont *)font textColor:(UIColor *)color rowNumber:(NSUInteger)rowNumber {
    self = [super init];
    if (self) {
        self.displayedNumber = originNumber;
        self.font = font;
        self.textColor = color;
        self.isAnimation = NO;
        self.finishedAnimationCount = 0;
        self.rowNumber = (rowNumber > 0 && rowNumber <= 8) ? rowNumber : 0;
        self.maxRowNumber = (self.rowNumber == 0) ? 8 : rowNumber;
        [self commonInit];
    }
    return self;
}

#pragma mark - ConfigViews

- (void)initParent{
    
    self.bounds = CGRectMake(0, 0, self.rowNumber * self.cellWidth, self.cellHeight / 11);
    self.backgroundColor = [UIColor clearColor];
    self.layer.masksToBounds = YES;
    
    [self layoutCell:self.rowNumber withAnimation:YES];
    
}

- (void)initCell {
    int originNumber = self.displayedNumber.intValue;
    
    if (self.rowNumber == 0) {
        self.rowNumber = [self calculateRowNumber:originNumber];
    }
    
    self.cellArray = [[NSMutableArray alloc] init];
    
    NSString *text = @"0\n1\n2\n3\n4\n5\n6\n7\n8\n9\n0";
    CGRect rect = [text boundingRectWithSize:CGSizeZero
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:self.font}
                                     context:nil];
    self.cellWidth = rect.size.width;
    self.cellHeight = rect.size.height;
    
    NSArray *displayNumberArray = [self getCellDisplayNumberWithNumber:self.displayedNumber.integerValue];
    
    for (NSInteger i = 0; i < self.rowNumber; i++) {
        UILabel *scrollCell = [self makeScrollCell];
        scrollCell.frame = CGRectMake((self.rowNumber - 1 - i) * self.cellWidth, 0, self.cellWidth, self.cellHeight);
        scrollCell.text = text;
        NSNumber *displayNum = [displayNumberArray objectAtIndex:i];
        [self setScrollCell:scrollCell toNumber:displayNum.integerValue];
        [self.cellArray addObject:scrollCell];
    }
}

- (void)reInitCell:(NSInteger)rowNumber {
    NSString *text = @"0\n1\n2\n3\n4\n5\n6\n7\n8\n9\n0";
    
    if (rowNumber > self.rowNumber) {
        for (NSInteger i = self.rowNumber; i < rowNumber; i++) {
            UILabel *scrollCell = [self makeScrollCell];
            scrollCell.frame = CGRectMake((self.rowNumber - 1 - i) * self.cellWidth, 0, self.cellWidth, self.cellHeight);
            scrollCell.text = text;
            [self.cellArray addObject:scrollCell];
        }
    }else {
        for (NSInteger i = rowNumber; i < self.rowNumber; i++) {
            [self.cellArray removeLastObject];
        }
    }
}

- (void)layoutCell:(NSUInteger)rowNumber withAnimation:(BOOL)animated{
    
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    for (UILabel *cell in self.cellArray) {
        [self addSubview:cell];
    }
    
    if (rowNumber == self.rowNumber) {
        return ;
    }
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.2 * (rowNumber - self.rowNumber) animations:^{
        for (int i = 0; i < rowNumber; i++) {
            UILabel *cell = [weakSelf.cellArray objectAtIndex:i];
            cell.frame = CGRectMake((rowNumber - 1 - i) * weakSelf.cellWidth,
                                    cell.frame.origin.y,
                                    weakSelf.cellWidth,
                                    weakSelf.cellHeight);
        }
        self.frame = CGRectMake(self.frame.origin.x,
                                self.frame.origin.y,
                                rowNumber * self.cellWidth,
                                self.cellHeight/11);
    } completion:nil];
}

#pragma mark - Animation

- (void)playAnimationWithChange:(NSInteger)changeNumber displayNumber:(NSNumber *)displayNumber interval:(CGFloat)interval{
    
    NSInteger nextRowNumber = [self calculateRowNumber:displayNumber.intValue];
    
    if (nextRowNumber > self.rowNumber) {
        [self reInitCell:nextRowNumber];
        [self layoutCell:nextRowNumber withAnimation:YES];
        self.rowNumber = nextRowNumber;
    }
    
    NSArray *repeatCountArray = [self getRepeatTimesWithChangeNumber:changeNumber displayNumber:displayNumber.integerValue];
    NSArray *willDisplayNums = [self getCellDisplayNumberWithNumber:displayNumber.integerValue];
    
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
                    
                    startDuration = interval * (10 - [self getDisplayNumberOfCell:cell]) / ceilf(fabs(changeNumber / pow(10, i)));
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
                    startDuration = interval * ([self getDisplayNumberOfCell:cell] - 0) / ceilf(fabs(changeNumber / pow(10, i)));
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
        [self setScrollCell:cell toNumber:(direction == ScrollAnimationDirectionUp)?10 : 0];
    } completion:^(BOOL finished) {
        NSLog(@"start animation finish!");
        [self setScrollCell:cell toNumber:(direction == ScrollAnimationDirectionUp)?0 : 10];
        
        if (cycleDuration.floatValue == 0) {
            [UIView animateWithDuration:endDuration.floatValue delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self setScrollCell:cell toNumber:willDisplayNum.integerValue];
            } completion:^(BOOL finished) {
                [self checkTaskArrayWithAnimationCount:count];
                NSLog(@"end animation finish!");
            }];
        }else {
            [UIView animateWithDuration:cycleDuration.floatValue delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat animations:^{
                [UIView setAnimationRepeatCount:repeatCount.integerValue];
                switch (direction) {
                    case ScrollAnimationDirectionUp:
                        [self setScrollCell:cell toNumber:10];
                        break;
                    case ScrollAnimationDirectionDown:
                        [self setScrollCell:cell toNumber:0];
                        break;
                    default:
                        break;
                }
            } completion:^(BOOL finished) {
                NSLog(@"cycle animation finish!");
                [self setScrollCell:cell toNumber:(direction == ScrollAnimationDirectionUp)?0 : 10];
                [UIView animateWithDuration:endDuration.floatValue delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self setScrollCell:cell toNumber:willDisplayNum.integerValue];
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
        [self setScrollCell:cell toNumber:displayNumber];
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
            self.isAnimation = NO;
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
    
    if ([self calculateRowNumber:number.integerValue] > self.maxRowNumber) {
        return ;
    }
    
    if (number.integerValue == self.displayedNumber.integerValue) {
        return ;
    }
    if (self.isAnimation) {
        if (!self.taskArray) {
            self.taskArray = [NSMutableArray array];
        }
        [self.taskArray addObject:@{keyTaskDisplayNumber:number, keyTaskChangeNumber:@(number.integerValue - self.displayedNumber.integerValue),keyTaskInterval:@(interval)}];
    }else {
        if (animated) {
            [self playAnimationWithChange:number.integerValue - self.displayedNumber.integerValue displayNumber:number interval:interval];
            self.isAnimation = YES;
        }else {
            if (animated) {
                [self playAnimationWithChange:number.integerValue - self.displayedNumber.integerValue displayNumber:number interval:interval];
                self.isAnimation = YES;
            }else {
                NSArray<NSNumber *> *displayNumbers = [self getCellDisplayNumberWithNumber:number.integerValue];
                for (int i = 0; i < displayNumbers.count; i++) {
                    [self setScrollCell:self.cellArray[i] toNumber:displayNumbers[i].integerValue];
                }
            }
        }
    }
    self.displayedNumber = number;
}

#pragma mark - Privite Method

- (void)commonInit {
    [self initCell];
    [self initParent];
}

- (NSInteger)calculateRowNumber:(NSInteger)number {
    NSInteger rowNumber = 1;
    while ((number = number / 10) != 0) {
        rowNumber++;
    }
    return rowNumber;
}

- (void)setScrollCell:(UILabel *)cell toNumber:(NSInteger)number {
    CGFloat originX = cell.frame.origin.x;
    CGFloat floatNumber = number;
    CGFloat y = - ((CGFloat)floatNumber / 11) * self.cellHeight;
    cell.frame = CGRectMake(originX, y, self.cellWidth, self.cellHeight);
}

- (void)setScrollCell:(UILabel *)cell scrollDirection:(ScrollAnimationDirection)direction {
    cell.tag = direction;
}

- (ScrollAnimationDirection)getDirectionOfScrollCell:(UILabel *)cell {
    return cell.tag;
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

- (NSArray<NSNumber *> *)getCellDisplayNumberWithNumber:(NSInteger)displayNumber {
    
    NSMutableArray *displayCellNumbers = [[NSMutableArray alloc] init];
    NSInteger tmpNumber;
    for (NSInteger i = 0; i < self.rowNumber; i++) {
        tmpNumber = displayNumber % 10;
        NSNumber *number = @(tmpNumber);
        [displayCellNumbers addObject:number];
        displayNumber = displayNumber / 10;
    }
    
    return displayCellNumbers;
}

- (NSInteger)getDisplayNumberOfCell:(UILabel *)cell {
    CGFloat y = cell.frame.origin.y;
    CGFloat tmpNumber = (- (y * 11 / self.cellHeight));
    NSInteger displayNumber = (NSInteger)roundf(tmpNumber);
    return displayNumber;
}

- (CGFloat)calculateIntervalWithChangeNumber:(NSInteger)change {
    NSInteger changeRow = [self calculateRowNumber:change];
    return fabs(normalModulus * (change / pow(10, changeRow - 1)));
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

- (UILabel *)makeScrollCell {
    UILabel *cell = [[UILabel alloc] init];
    cell.font = self.font;
    cell.numberOfLines = 11;
    cell.textColor = self.textColor;
    return  cell;
}

@end
