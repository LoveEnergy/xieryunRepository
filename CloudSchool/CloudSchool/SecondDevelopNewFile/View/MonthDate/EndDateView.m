//
//  BirthDayView.m
//  WideHelp
//
//  Created by ENERGY on 2018/8/22.
//  Copyright © 2018年 ENERGY. All rights reserved.
//

#define Is_Iphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define Is_Iphone_X (Is_Iphone && SCREEN_HEIGHT >= 812.0)
#define NAVI_HEIGHT (Is_Iphone_X ? 88 : 64)
#define BOTTOM_HEIGHT (Is_Iphone_X ? 34 : 0)
#define WIDTH_6_SCALE 375.0 * [UIScreen mainScreen].bounds.size.width
#define HEIGHT_6_SCALE 667.0 * [UIScreen mainScreen].bounds.size.height
//屏幕宽高
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#import "EndDateView.h"

@interface EndDateView()
@property (nonatomic, strong)UIDatePicker * datePicker;
@property (nonatomic, strong)NSString * dateString;
@end

@implementation EndDateView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        self.alpha = 0;
        UIButton * bgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        bgBtn.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.75];
        //        [bgBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgBtn];
        [self setUpViews];
    }return self;
}
#pragma mark - init
- (void)setUpViews{
    int datePickerH = 100/WIDTH_6_SCALE;
    UIView * whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - BOTTOM_HEIGHT - NAVI_HEIGHT - datePickerH, SCREEN_WIDTH, datePickerH + NAVI_HEIGHT)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    //日期选择器
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, datePickerH + NAVI_HEIGHT)];
    [whiteView addSubview:self.datePicker];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    //设置显示格式
    //默认根据手机本地设置显示为中文还是其他语言
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文显示
    self.datePicker.locale = locale;
    // 设置当前显示时间
    [self.datePicker setDate:[NSDate date] animated:YES];
    // 设置显示最大时间（此处为当前时间）
    [self.datePicker setMaximumDate:[NSDate date]];
    
    //当前时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM"];
    NSString * nowDateStr = [formatter stringFromDate:date];
    NSLog(@"当前时间：%@", nowDateStr);
    self.dateString = nowDateStr;
    //取消确定按钮栏
    UIView * btnBarView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - BOTTOM_HEIGHT - NAVI_HEIGHT - datePickerH - 30/WIDTH_6_SCALE, SCREEN_WIDTH, 30/WIDTH_6_SCALE)];
    btnBarView.backgroundColor = [UIColor whiteColor];
    [self addSubview:btnBarView];
    //取消
    UIButton * cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10/WIDTH_6_SCALE, 56/WIDTH_6_SCALE, 30/WIDTH_6_SCALE)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRed:3/255 green:120/255 blue:253/255 alpha:1.0f]
                    forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    cancelBtn.layer.cornerRadius = 5;
    cancelBtn.layer.masksToBounds = YES;
    [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [btnBarView addSubview:cancelBtn];
    //确定
    UIButton * sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10/WIDTH_6_SCALE - 56/WIDTH_6_SCALE, CGRectGetMinY(cancelBtn.frame), cancelBtn.frame.size.width, cancelBtn.frame.size.height)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithRed:3/255 green:120/255 blue:253/255 alpha:1.0f] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    sureBtn.layer.cornerRadius = 5;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [btnBarView addSubview:sureBtn];
}
-(void)dateChanged:(id)sender{
    UIDatePicker *control = (UIDatePicker*)sender;
    NSDate* date = control.date;
    //添加你自己响应代码
    NSLog(@"dateChanged响应事件：%@",date);
    //NSDate格式转换为NSString格式
    NSDate *pickerDate = [self.datePicker date];// 获取用户通过UIDatePicker设置的日期和时间
    NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc] init];// 创建一个日期格式器
    [pickerFormatter setDateStyle:NSDateFormatterMediumStyle];
    [pickerFormatter setTimeStyle:NSDateFormatterShortStyle];
    [pickerFormatter setDateFormat:@"yyyy-MM"];
    self.dateString = [pickerFormatter stringFromDate:pickerDate];//滚动到的日期
}
- (void)show{
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    [UIView animateWithDuration:.15 animations:^{
        self.alpha = 1;
    }];
}
- (void)dismiss{
    [UIView animateWithDuration:.15 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)sureBtnClick{
    if (self.getDateBlock) {
        self.getDateBlock(self.dateString);
    }
    [self dismiss];
}
@end
