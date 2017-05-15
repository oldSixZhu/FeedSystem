//
//  ZKCoreDataManager.m
//  FeedSystem
//
//  Created by Mac on 2017/5/12.
//  Copyright © 2017年 bigtutu. All rights reserved.
//

#import "ZKCoreDataManager.h"

@implementation ZKCoreDataManager

+ (ZKCoreDataManager *)shareInstance
{
    static ZKCoreDataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZKCoreDataManager alloc] init];
    });
    return manager;
}

//懒加载NSPersistentContainer
- (NSPersistentContainer *)persistentContainer
{
    if(_persistentContainer != nil)
    {
        return _persistentContainer;
    }
    
    //1.创建对象管理模型
    //    //根据某个模型文件路径创建模型文件
    //    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle]URLForResource:@"Person" withExtension:@"momd"]];
    
    
    //合并Bundle所有.momd文件
    //budles: 指定为nil,自动从mainBundle里找所有.momd文件
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    //2.创建NSPersistentContainer
    /**
     * name:数据库文件名称
     */
    _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"sql.db" managedObjectModel:model];
    
    //3.加载存储器
    [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * description, NSError * error) {
//        NSLog(@"--%@",description);
//        NSLog(@"++%@",error);
    }];
    
    return _persistentContainer;
}

- (void)save
{
    NSError *error = nil;
    [self.persistentContainer.viewContext save:&error];
    
    if (error == nil)
    {
        NSLog(@"保存到数据库成功");
    }
    else
    {
        NSLog(@"保存到数据库失败：%@",error);
    }
}


@end
