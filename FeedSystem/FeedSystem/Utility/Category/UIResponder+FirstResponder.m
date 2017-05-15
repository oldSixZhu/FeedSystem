//
//  UIResponder+FirstResponder.m
//  FeedSystem
//
//  Created by Mac on 2017/5/13.
//  Copyright © 2017年 bigtutu. All rights reserved.
//

#import "UIResponder+FirstResponder.h"

static __weak id currentFirstResponder; 

@implementation UIResponder (FirstResponder)

+ (id)currentFirstResponder {
    currentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}

- (void)findFirstResponder:(id)sender {
    currentFirstResponder = self;
}

@end
