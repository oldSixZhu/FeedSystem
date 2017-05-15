//
//  WSLineChartView.h
//  WSLineChart
//
//  Created by Mac on 2017/5/12.
//  Copyright © 2017年 bigtutu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKChartView : UIView


- (id)initWithFrame:(CGRect)frame
    chartViewHeight:(CGFloat)chartViewHeight
        xTitleArray:(NSArray*)xTitleArray
        yValueArray:(NSArray*)yValueArray
               yMax:(CGFloat)yMax
               yMin:(CGFloat)yMin
              yName:(NSString *)yName;


@end
