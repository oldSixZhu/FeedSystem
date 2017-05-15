//
//  TGC+CoreDataProperties.m
//  FeedSystem
//
//  Created by Mac on 2017/5/13.
//  Copyright © 2017年 bigtutu. All rights reserved.
//

#import "TGC+CoreDataProperties.h"

@implementation TGC (CoreDataProperties)

+ (NSFetchRequest<TGC *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"TGC"];
}

@dynamic time;
@dynamic temp;
@dynamic weight;

@end
