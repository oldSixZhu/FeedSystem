//
//  ZKTGCTableViewCell.m
//  FeedSystem
//
//  Created by Mac on 2017/5/13.
//  Copyright © 2017年 bigtutu. All rights reserved.
//

#import "ZKTGCTableViewCell.h"

@implementation ZKTGCTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initWithBirthView];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        [self initWithBirthView];
    }
    return self;
}

//创建滚轮时间视图
-(void)initWithBirthView
{
    UIDatePicker *date = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    date.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    date.datePickerMode = UIDatePickerModeDate;
    [date addTarget:self action:@selector(changeData:) forControlEvents:UIControlEventValueChanged];
    
    self.timeTF.inputView = date;
}

-(void)changeData:(UIDatePicker *)datePicker
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *data = [fmt stringFromDate:datePicker.date];
    self.timeTF.text = data;
}

//点击页面滚轮视图消失
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
