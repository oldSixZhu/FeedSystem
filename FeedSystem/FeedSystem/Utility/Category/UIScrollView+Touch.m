//
//  UIScrollView+Touch.m
//  SurOCR
//
//  Created by Mac on 2017/5/5.
//  Copyright © 2017年 SuperCohesionTechnology. All rights reserved.
//

#import "UIScrollView+Touch.h"

@implementation UIScrollView (Touch)

//解决UIScrollView 或 UIImageView 截获touch事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 选其一即可
    [super touchesBegan:touches withEvent:event];
    //  [[self nextResponder] touchesBegan:touches withEvent:event];
}

@end
