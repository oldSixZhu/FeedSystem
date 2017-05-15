//
//  Fodder+CoreDataProperties.h
//  FeedSystem
//
//  Created by Mac on 2017/5/13.
//  Copyright © 2017年 bigtutu. All rights reserved.
//

#import "Fodder+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Fodder (CoreDataProperties)

+ (NSFetchRequest<Fodder *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name_id;//排序用
@property (nullable, nonatomic, copy) NSString *name;//肥料名
@property (nullable, nonatomic, copy) NSString *dm;//干物质
@property (nullable, nonatomic, copy) NSString *cp;//粗蛋白
@property (nullable, nonatomic, copy) NSString *lipid;//脂肪
@property (nullable, nonatomic, copy) NSString *crude;//粗纤维
@property (nullable, nonatomic, copy) NSString *p;//磷
@property (nullable, nonatomic, copy) NSString *ash;//灰分
@property (nullable, nonatomic, copy) NSString *danbai;//蛋白质消化率
@property (nullable, nonatomic, copy) NSString *dpi;//磷消化率
@property (nullable, nonatomic, copy) NSString *rongshi;//溶失率

@end

NS_ASSUME_NONNULL_END
