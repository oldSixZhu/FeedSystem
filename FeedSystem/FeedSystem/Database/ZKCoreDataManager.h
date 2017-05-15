//
//  ZKCoreDataManager.h
//  FeedSystem
//
//  Created by Mac on 2017/5/12.
//  Copyright © 2017年 bigtutu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define kZKCoreDataManager [ZKCoreDataManager shareInstance]

@interface ZKCoreDataManager : NSObject

//单例类
+ (ZKCoreDataManager*)shareInstance;

/**
 CoreData Stack容器
 内部包含：
 管理对象上下文：NSManagedObjectContext *viewContext;
 对象管理模型：NSManagedObjectModel *managedObjectModel
 存储调度器：NSPersistentStoreCoordinator *persistentStoreCoordinator;
 */
@property(nonatomic,strong)NSPersistentContainer *persistentContainer;

//保存到数据库
- (void)save;


@end
