//
//  UIView+Frame.h
//  StringDemo
//
//  Created by Mac on 2017/5/12.
//  Copyright © 2017年 bigtutu. All rights reserved.
//

#import <UIKit/UIKit.h>

//尺寸
#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height
#define kScreenBounds     [UIScreen mainScreen].bounds

@interface UIView (Frame)

/**
 *  返回UIView及其子类的位置和尺寸。分别为左、右边界在X轴方向上的距离，上、下边界在Y轴上的距离，View的宽和高。
 */

@property(nonatomic) CGFloat left;
@property(nonatomic) CGFloat right;
@property(nonatomic) CGFloat top;
@property(nonatomic) CGFloat bottom;
@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGPoint origin;

@end
