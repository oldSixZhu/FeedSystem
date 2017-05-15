//
//  AppDelegate.m
//  FeedSystem
//
//  Created by Mac on 2017/5/12.
//  Copyright © 2017年 bigtutu. All rights reserved.
//

#import "AppDelegate.h"
#import <math.h>
#import "ZKCoreDataManager.h"//数据库管理者
#import "TGC+CoreDataProperties.h"
#import "Fodder+CoreDataProperties.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    /**1.创建Storyboard,加载Storyboard的名字,这里是自己创建的Storyboard的名字*/
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ZKMain" bundle:nil];
    /**2.加载storyboard里的控制器,标识符的控制器*/
    UIViewController *vc  = [storyboard instantiateViewControllerWithIdentifier:@"ZKLoginVC"];
    /**3.设置根控制器*/
    self.window.rootViewController = vc;
    
    [self.window makeKeyAndVisible];
    
//    CGFloat x = powf(8, 1.0/3.0);
//    NSLog(@"%f",x);
//    x = powf(2, 3.0);
//    NSLog(@"%f",x);
    
    
    [self saveBeginingTGCData];
    
    [self saveBeginingFodderData];
    
    return YES;
}

//写入原始肥料数据
- (void)saveBeginingFodderData
{
    //写之前先清空一下
    //创建一个查询请求
    NSFetchRequest *request1 = [[NSFetchRequest alloc] initWithEntityName:@"Fodder"];
    //查询数据
    NSArray<Fodder*> *fodderArr = [kZKCoreDataManager.persistentContainer.viewContext executeFetchRequest:request1 error:nil];
    //删除数据
    for (Fodder* fodder in fodderArr) {
        [kZKCoreDataManager.persistentContainer.viewContext deleteObject:fodder];
    }
    //同步到数据库
    [kZKCoreDataManager save];
    
    Fodder *fodder1 = [NSEntityDescription insertNewObjectForEntityForName:@"Fodder" inManagedObjectContext:kZKCoreDataManager.persistentContainer.viewContext];
    fodder1.name_id = @"1";
    fodder1.name = @"粤海饲料Nursery";
    fodder1.dm = @"89.0";
    fodder1.cp = @"33.0";
    fodder1.lipid = @"2.0";
    fodder1.crude = @"8.0";
    fodder1.p = @"1.0";
    fodder1.ash = @"16.0";
    fodder1.danbai = @"0.77";
    fodder1.dpi = @"0.523";
    fodder1.rongshi = @"3.0";
    
    Fodder *fodder2 = [NSEntityDescription insertNewObjectForEntityForName:@"Fodder" inManagedObjectContext:kZKCoreDataManager.persistentContainer.viewContext];
    fodder2.name_id = @"2";
    fodder2.name = @"粤海饲料Pre";
    fodder2.dm = @"89.0";
    fodder2.cp = @"28.0";
    fodder2.lipid = @"2.5";
    fodder2.crude = @"8.0";
    fodder2.p = @"0.6";
    fodder2.ash = @"12.0";
    fodder2.danbai = @"0.82";
    fodder2.dpi = @"0.55";
    fodder2.rongshi = @"3.0";
    
    Fodder *fodder3 = [NSEntityDescription insertNewObjectForEntityForName:@"Fodder" inManagedObjectContext:kZKCoreDataManager.persistentContainer.viewContext];
    fodder3.name_id = @"3";
    fodder3.name = @"粤海饲料Growout";
    fodder3.dm = @"89.0";
    fodder3.cp = @"23.0";
    fodder3.lipid = @"2.5";
    fodder3.crude = @"12.0";
    fodder3.p = @"0.6";
    fodder3.ash = @"12.0";
    fodder3.danbai = @"0.78";
    fodder3.dpi = @"0.59";
    fodder3.rongshi = @"3.0";
    
    Fodder *fodder4 = [NSEntityDescription insertNewObjectForEntityForName:@"Fodder" inManagedObjectContext:kZKCoreDataManager.persistentContainer.viewContext];
    fodder4.name_id = @"4";
    fodder4.name = @"文献饲料Nursery";
    fodder4.dm = @"91.7";
    fodder4.cp = @"43.0";
    fodder4.lipid = @"7.0";
    fodder4.crude = @"8.0";
    fodder4.p = @"1.4";
    fodder4.ash = @"7.0";
    fodder4.danbai = @"0.77";
    fodder4.dpi = @"0.68";
    fodder4.rongshi = @"3.0";
    
    Fodder *fodder5 = [NSEntityDescription insertNewObjectForEntityForName:@"Fodder" inManagedObjectContext:kZKCoreDataManager.persistentContainer.viewContext];
    fodder5.name_id = @"5";
    fodder5.name = @"文献饲料Pre";
    fodder5.dm = @"90.3";
    fodder5.cp = @"37.0";
    fodder5.lipid = @"8.0";
    fodder5.crude = @"8.0";
    fodder5.p = @"1.4";
    fodder5.ash = @"9.0";
    fodder5.danbai = @"0.82";
    fodder5.dpi = @"0.68";
    fodder5.rongshi = @"3.0";
    
    Fodder *fodder6 = [NSEntityDescription insertNewObjectForEntityForName:@"Fodder" inManagedObjectContext:kZKCoreDataManager.persistentContainer.viewContext];
    fodder6.name_id = @"6";
    fodder6.name = @"文献饲料Growout";
    fodder6.dm = @"90.5";
    fodder6.cp = @"31.0";
    fodder6.lipid = @"8.0";
    fodder6.crude = @"8.0";
    fodder6.p = @"1.4";
    fodder6.ash = @"9.0";
    fodder6.danbai = @"0.78";
    fodder6.dpi = @"0.68";
    fodder6.rongshi = @"3.0";
    
    
    [kZKCoreDataManager save];
}

//写入原始TGC数据
- (void)saveBeginingTGCData
{
    //写之前先清空一下
    NSFetchRequest *request1 = [[NSFetchRequest alloc] initWithEntityName:@"TGC"];
    NSArray<TGC*> *tgcArr = [kZKCoreDataManager.persistentContainer.viewContext executeFetchRequest:request1 error:nil];
    for (TGC* tgc in tgcArr) {
        [kZKCoreDataManager.persistentContainer.viewContext deleteObject:tgc];
    }
    [kZKCoreDataManager save];
    
    TGC *tgc1 = [NSEntityDescription insertNewObjectForEntityForName:@"TGC" inManagedObjectContext:kZKCoreDataManager.persistentContainer.viewContext];
    tgc1.time = @"2017-05-29";
    tgc1.temp = @"21.0";
    tgc1.weight = @"0.5";
    
    TGC *tgc2 = [NSEntityDescription insertNewObjectForEntityForName:@"TGC" inManagedObjectContext:kZKCoreDataManager.persistentContainer.viewContext];
    tgc2.time = @"2017-06-05";
    tgc2.temp = @"25.0";
    tgc2.weight = @"0.8";
    
    TGC *tgc3 = [NSEntityDescription insertNewObjectForEntityForName:@"TGC" inManagedObjectContext:kZKCoreDataManager.persistentContainer.viewContext];
    tgc3.time = @"2017-06-12";
    tgc3.temp = @"25.0";
    tgc3.weight = @"1.2";
    
    
    TGC *tgc4 = [NSEntityDescription insertNewObjectForEntityForName:@"TGC" inManagedObjectContext:kZKCoreDataManager.persistentContainer.viewContext];
    tgc4.time = @"2017-06-19";
    tgc4.temp = @"25.0";
    tgc4.weight = @"1.5";
    
    TGC *tgc5 = [NSEntityDescription insertNewObjectForEntityForName:@"TGC" inManagedObjectContext:kZKCoreDataManager.persistentContainer.viewContext];
    tgc5.time = @"2017-06-26";
    tgc5.temp = @"25.0";
    tgc5.weight = @"1.8";
    
    TGC *tgc6 = [NSEntityDescription insertNewObjectForEntityForName:@"TGC" inManagedObjectContext:kZKCoreDataManager.persistentContainer.viewContext];
    tgc6.time = @"2017-07-03";
    tgc6.temp = @"27.0";
    tgc6.weight = @"2.1";
    
    TGC *tgc7 = [NSEntityDescription insertNewObjectForEntityForName:@"TGC" inManagedObjectContext:kZKCoreDataManager.persistentContainer.viewContext];
    tgc7.time = @"2017-07-10";
    tgc7.temp = @"28.0";
    tgc7.weight = @"2.4";
    
    TGC *tgc8 = [NSEntityDescription insertNewObjectForEntityForName:@"TGC" inManagedObjectContext:kZKCoreDataManager.persistentContainer.viewContext];
    tgc8.time = @"2017-07-17";
    tgc8.temp = @"29.0";
    tgc8.weight = @"2.7";
    
    TGC *tgc9 = [NSEntityDescription insertNewObjectForEntityForName:@"TGC" inManagedObjectContext:kZKCoreDataManager.persistentContainer.viewContext];
    tgc9.time = @"2017-07-24";
    tgc9.temp = @"30.0";
    tgc9.weight = @"3.2";
    
    TGC *tgc10 = [NSEntityDescription insertNewObjectForEntityForName:@"TGC" inManagedObjectContext:kZKCoreDataManager.persistentContainer.viewContext];
    tgc10.time = @"2017-07-31";
    tgc10.temp = @"30.0";
    tgc10.weight = @"4.3";
    
    TGC *tgc11 = [NSEntityDescription insertNewObjectForEntityForName:@"TGC" inManagedObjectContext:kZKCoreDataManager.persistentContainer.viewContext];
    tgc11.time = @"2017-08-07";
    tgc11.temp = @"30.0";
    tgc11.weight = @"5.4";
    
    TGC *tgc12 = [NSEntityDescription insertNewObjectForEntityForName:@"TGC" inManagedObjectContext:kZKCoreDataManager.persistentContainer.viewContext];
    tgc12.time = @"2017-08-14";
    tgc12.temp = @"30.0";
    tgc12.weight = @"6.8";
    
    TGC *tgc13= [NSEntityDescription insertNewObjectForEntityForName:@"TGC" inManagedObjectContext:kZKCoreDataManager.persistentContainer.viewContext];
    tgc13.time = @"2017-08-21";
    tgc13.temp = @"30.0";
    tgc13.weight = @"7.9";
    
    TGC *tgc14= [NSEntityDescription insertNewObjectForEntityForName:@"TGC" inManagedObjectContext:kZKCoreDataManager.persistentContainer.viewContext];
    tgc14.time = @"2017-08-28";
    tgc14.temp = @"30.0";
    tgc14.weight = @"9.2";
    
    TGC *tgc15= [NSEntityDescription insertNewObjectForEntityForName:@"TGC" inManagedObjectContext:kZKCoreDataManager.persistentContainer.viewContext];
    tgc15.time = @"2017-09-04";
    tgc15.temp = @"29.0";
    tgc15.weight = @"10.9";
    
    TGC *tgc16= [NSEntityDescription insertNewObjectForEntityForName:@"TGC" inManagedObjectContext:kZKCoreDataManager.persistentContainer.viewContext];
    tgc16.time = @"2017-09-11";
    tgc16.temp = @"28.0";
    tgc16.weight = @"13.3";
    
    TGC *tgc17= [NSEntityDescription insertNewObjectForEntityForName:@"TGC" inManagedObjectContext:kZKCoreDataManager.persistentContainer.viewContext];
    tgc17.time = @"2017-09-18";
    tgc17.temp = @"27.0";
    tgc17.weight = @"15.0";
    
    TGC *tgc18= [NSEntityDescription insertNewObjectForEntityForName:@"TGC" inManagedObjectContext:kZKCoreDataManager.persistentContainer.viewContext];
    tgc18.time = @"2017-09-25";
    tgc18.temp = @"27.0";
    tgc18.weight = @"17.4";
    
    TGC *tgc19= [NSEntityDescription insertNewObjectForEntityForName:@"TGC" inManagedObjectContext:kZKCoreDataManager.persistentContainer.viewContext];
    tgc19.time = @"2017-10-02";
    tgc19.temp = @"27.0";
    tgc19.weight = @"19.0";
    
    TGC *tgc20= [NSEntityDescription insertNewObjectForEntityForName:@"TGC" inManagedObjectContext:kZKCoreDataManager.persistentContainer.viewContext];
    tgc20.time = @"2017-10-09";
    tgc20.temp = @"26.0";
    tgc20.weight = @"20.3";
    
    TGC *tgc21= [NSEntityDescription insertNewObjectForEntityForName:@"TGC" inManagedObjectContext:kZKCoreDataManager.persistentContainer.viewContext];
    tgc21.time = @"2017-10-16";
    tgc21.temp = @"25.0";
    tgc21.weight = @"24.3";
    
    [kZKCoreDataManager save];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
//    [self saveContext];
}


//#pragma mark - Core Data stack
//
//@synthesize persistentContainer = _persistentContainer;
//
//- (NSPersistentContainer *)persistentContainer {
//    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
//    @synchronized (self) {
//        if (_persistentContainer == nil) {
//            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"FeedSystem"];
//            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
//                if (error != nil) {
//                    // Replace this implementation with code to handle the error appropriately.
//                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                    
//                    /*
//                     Typical reasons for an error here include:
//                     * The parent directory does not exist, cannot be created, or disallows writing.
//                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
//                     * The device is out of space.
//                     * The store could not be migrated to the current model version.
//                     Check the error message to determine what the actual problem was.
//                    */
//                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
//                    abort();
//                }
//            }];
//        }
//    }
//    
//    return _persistentContainer;
//}
//
//#pragma mark - Core Data Saving support
//
//- (void)saveContext {
//    NSManagedObjectContext *context = self.persistentContainer.viewContext;
//    NSError *error = nil;
//    if ([context hasChanges] && ![context save:&error]) {
//        // Replace this implementation with code to handle the error appropriately.
//        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
//        abort();
//    }
//}

@end
