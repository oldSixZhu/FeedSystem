//
//  Fodder+CoreDataProperties.m
//  FeedSystem
//
//  Created by Mac on 2017/5/13.
//  Copyright © 2017年 bigtutu. All rights reserved.
//

#import "Fodder+CoreDataProperties.h"

@implementation Fodder (CoreDataProperties)

+ (NSFetchRequest<Fodder *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Fodder"];
}

@dynamic name_id;
@dynamic name;
@dynamic dm;
@dynamic cp;
@dynamic lipid;
@dynamic crude;
@dynamic p;
@dynamic ash;
@dynamic danbai;
@dynamic dpi;
@dynamic rongshi;

@end
