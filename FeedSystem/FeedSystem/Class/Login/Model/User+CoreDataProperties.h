//
//  User+CoreDataProperties.h
//  FeedSystem
//
//  Created by Mac on 2017/5/12.
//  Copyright © 2017年 bigtutu. All rights reserved.
//

#import "User+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

+ (NSFetchRequest<User *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *user_id;
@property (nullable, nonatomic, copy) NSString *password;

@end

NS_ASSUME_NONNULL_END
