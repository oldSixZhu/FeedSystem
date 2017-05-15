//
//  ZKCalculateModel.m
//  FeedSystem
//
//  Created by Mac on 2017/5/12.
//  Copyright © 2017年 bigtutu. All rights reserved.
//

#import "ZKCalculateModel.h"

@implementation ZKCalculateModel
- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)provinceWithDictionary:(NSDictionary *)dict{
    return [[self alloc] initWithDictionary:dict];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
