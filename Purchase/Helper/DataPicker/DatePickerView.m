//
//  HETDatePickerView.m
//  CLife
//
//  Created by HeT on 15/11/6.
//  Copyright © 2015年 HET. All rights reserved.
//

#import "DatePickerView.h"

static const float DurationTime = 0.5;
static const float BGHeight = 240;
static const float PickHeight = 200;

@interface DatePickerView ()

@property (nonatomic, strong) UIButton       *btnView;
@property (nonatomic, strong) UIView         *bgView;

@end

@implementation DatePickerView
- (id)init
{
    self = [self initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.backgroundColor = [UIColor clearColor];
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, BGHeight)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgView];
    
    UIButton *pickerCancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pickerCancleBtn setTitle:NSInternationalString(@"取消", @"取消") forState:UIControlStateNormal];
    [pickerCancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [pickerCancleBtn setFrame:CGRectMake(20, 5, 60, 30)];
    [pickerCancleBtn addTarget:self action:@selector(cancleSelectTime:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:pickerCancleBtn];
    
    UIButton *pickerSureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pickerSureBtn setTitle:NSInternationalString(@"确定", @"确定") forState:UIControlStateNormal];
    [pickerSureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [pickerSureBtn setFrame:CGRectMake(ScreenWidth - 60, 5, 60, 30)];
    [pickerSureBtn addTarget:self action:@selector(surePickDelayTime:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:pickerSureBtn];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(pickerSureBtn.frame)+5, self.frame.size.width, HalfScale)];
    line.backgroundColor = separateLineColor;
    [self.bgView addSubview:line];
    
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(pickerSureBtn.frame)+10, self.frame.size.width, PickHeight)];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.bgView addSubview:self.datePicker];
    
    self.btnView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnView.backgroundColor = [UIColor clearColor];
    [self.btnView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnView];
    
    return self;
}
- (void)showInView:(UIView *)view{
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.1 animations:^{
        weakSelf.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
        weakSelf.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [view addSubview:weakSelf];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:DurationTime animations:^{
            weakSelf.bgView.frame = CGRectMake(0, self.frame.size.height-BGHeight, self.frame.size.width, BGHeight);
        }completion:^(BOOL finished){
            weakSelf.btnView.enabled = YES;
            weakSelf.btnView.frame = CGRectMake(0, 0, weakSelf.frame.size.width, weakSelf.frame.size.height-BGHeight);
        }];
    }];
}
- (void)dismiss{
    
    self.btnView.enabled = NO;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:DurationTime animations:^{
        weakSelf.bgView.frame = CGRectMake(0, weakSelf.frame.size.height, weakSelf.frame.size.width, BGHeight);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:DurationTime animations:^{
            weakSelf.backgroundColor = [UIColor clearColor];
            weakSelf.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 0);
            [weakSelf removeFromSuperview];
        }];
    }];
}
- (void)surePickDelayTime:(UIButton *)btn
{
    NSDate * date = self.datePicker.date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    NSString * timeStr = [formatter stringFromDate:date];
  
    if ([self setTheTime]) {
        self.setTheTime(timeStr);
    }
    [self dismiss];
}
- (void)cancleSelectTime:(UIButton *)btn
{
    if ([self setTheTime]) {
        self.setTheTime(nil);
    }
    [self dismiss];
}
@end
