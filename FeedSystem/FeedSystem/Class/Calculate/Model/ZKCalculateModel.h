//
//  ZKCalculateModel.h
//  FeedSystem
//
//  Created by Mac on 2017/5/12.
//  Copyright © 2017年 bigtutu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZKCalculateModel : NSObject


@property (nonatomic, assign) CGFloat currentWeight;//当前体重
@property (nonatomic, assign) CGFloat lowestTemp;//最低温度
@property (nonatomic, assign) CGFloat averageTemp;//平均温度
@property (nonatomic, assign) NSInteger weeks;//周数
@property (nonatomic, assign) CGFloat TGC;//TGC

- (instancetype)initWithDictionary:(NSDictionary *)dict;

+ (instancetype)provinceWithDictionary:(NSDictionary *)dict;



@end
