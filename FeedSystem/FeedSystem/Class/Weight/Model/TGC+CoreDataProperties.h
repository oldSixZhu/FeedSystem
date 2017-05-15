//
//  TGC+CoreDataProperties.h
//  FeedSystem
//
//  Created by Mac on 2017/5/13.
//  Copyright © 2017年 bigtutu. All rights reserved.
//

#import "TGC+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TGC (CoreDataProperties)

+ (NSFetchRequest<TGC *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *time;
@property (nullable, nonatomic, copy) NSString *temp;
@property (nullable, nonatomic, copy) NSString *weight;

@end

NS_ASSUME_NONNULL_END
