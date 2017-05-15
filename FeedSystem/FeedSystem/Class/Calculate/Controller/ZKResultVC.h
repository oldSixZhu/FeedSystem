//
//  ZKResultVC.h
//  FeedSystem
//
//  Created by Mac on 2017/5/12.
//  Copyright © 2017年 bigtutu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZKResultVC : UIViewController


@property (nonatomic, assign) CGFloat currentWeight;//当前体重
@property (nonatomic, assign) CGFloat lowestTemp;//最低温度
@property (nonatomic, assign) CGFloat averageTemp;//平均温度
@property (nonatomic, assign) NSInteger weeks;//周数
@property (nonatomic, assign) CGFloat TGC;//TGC

@property (nonatomic, copy) NSString *fodder;//肥

@property (nonatomic, strong) NSDictionary *dataDic;//5个页面数据

@end
