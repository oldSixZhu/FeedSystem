//
//  ZKResultVC.m
//  FeedSystem
//
//  Created by Mac on 2017/5/12.
//  Copyright © 2017年 bigtutu. All rights reserved.
//

#import "ZKResultVC.h"
#import "ZKChartView.h"
#import "UIView+Frame.h"
#import "ZKFodderConfigVC.h"
#import <math.h>


@interface ZKResultVC ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;//表格
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;//布局
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeight;//高
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionWidth;//宽
@property (weak, nonatomic) IBOutlet UIView *chartView;//表的底视图
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chartHeight;//表的底视图的高

@property (nonatomic, strong) NSMutableArray *weekArr;//星期数组

@property (nonatomic, strong) NSMutableArray *weightArr;//体重数组

@property (nonatomic, strong) NSMutableArray *feedArr;//饲料 数组
@property (nonatomic, strong) NSMutableArray *sheShiLvArr;//摄食率 数组
@property (nonatomic, strong) NSMutableArray *xiaoHuaNengArr;//消化能 数组
@property (nonatomic, strong) NSMutableArray *xiShuArr;//饲料系数 数组

@property (nonatomic, strong) NSMutableArray *NGuTaiArr;//固态氮 数组
@property (nonatomic, strong) NSMutableArray *NYeTaiArr;//液态氮 数组
@property (nonatomic, strong) NSMutableArray *NAllArr;//总氮 数组

@property (nonatomic, strong) NSMutableArray *PGuTaiArr;//固态磷 数组
@property (nonatomic, strong) NSMutableArray *PYeTaiArr;//液态磷 数组
@property (nonatomic, strong) NSMutableArray *PAllArr;//总磷 数组


@end

static NSString *cellID = @"CollectionViewCellID";

@implementation ZKResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getData];
    
    if ([self.title isEqualToString:@"体重预测结果"])
    {
        [self calcuteWeight];
    }
    else if ([self.title isEqualToString:@"饲料预测结果"])
    {
        [self calcuteFodder];
    }
    else if ([self.title isEqualToString:@"N排放预测结果"])
    {
        [self calculateN];
    }
    else if ([self.title isEqualToString:@"P排放预测结果"])
    {
        [self calculateP];
    }
    
    [self setupUI];
    
}

//取数据
- (void)getData
{
    if (self.dataDic)
    {
        self.currentWeight = [self.dataDic[@"beginningWeight"] floatValue];
        self.TGC = [self.dataDic[@"TGC"] floatValue];
        self.averageTemp = [self.dataDic[@"averageTemp"] floatValue];
        self.weeks = [self.dataDic[@"weeks"] integerValue];
        self.lowestTemp = [self.dataDic[@"lowestTemp"] integerValue];
    }
    
}

- (void)setupUI
{
    //右部加个跳转按钮
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"跳转" style:UIBarButtonItemStylePlain target:self action:@selector(turnOtherVC)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
    
    //上部表格
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    self.collectionView.bounces = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.scrollEnabled = NO;
    self.automaticallyAdjustsScrollViewInsets = false;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
    self.collectionView.contentInset = UIEdgeInsetsMake(1, 1, 1, 1);
    
    //cell的宽高
    CGFloat cellW = 0;
    CGFloat cellH = 0;
    
    if ([self.title isEqualToString:@"体重预测结果"])
    {
        //右部按钮
        self.navigationItem.rightBarButtonItem.title = @"饲料预测结果";
        
        //上部表
        cellW = (self.collectionWidth.constant - self.weeks - 3)/(self.weeks + 2);
        cellH = (self.collectionHeight.constant - 3) / 2;
        //下部体重预测线图
        self.chartHeight.constant = kScreenHeight - 64 - self.collectionView.bottom - 12;
        CGRect chartRect = CGRectMake(8, 12, kScreenWidth - 16, 300);
        
        NSMutableArray *xArr =  [self.weekArr mutableCopy];
        [xArr removeObjectAtIndex:0];
        NSMutableArray *yArr =  [self.weightArr mutableCopy];
        [yArr removeObjectAtIndex:0];
        ZKChartView *chart = [[ZKChartView alloc]initWithFrame:chartRect chartViewHeight:280 xTitleArray:xArr yValueArray:yArr yMax:[yArr.lastObject floatValue] yMin:0 yName:@"体重"];
        [self.chartView addSubview:chart];
    }
    else if ([self.title isEqualToString:@"饲料预测结果"])
    {
        //右部按钮
        self.navigationItem.rightBarButtonItem.title = @"N预测结果";
        //上部表
        cellW = (self.collectionWidth.constant - self.weeks - 3)/(self.weeks + 2);
        self.collectionHeight.constant = 236;
        cellH = (self.collectionHeight.constant - 6) / 5;
        //下部预测线图
        self.chartHeight.constant = 1300;
        CGRect chartRect = CGRectMake(8, 12, kScreenWidth - 16, 300);
        //x轴
        NSMutableArray *xArr =  [self.weekArr mutableCopy];
        [xArr removeObjectAtIndex:0];
        //y轴
        //饲料
        NSMutableArray *yFeedArr =  [self.feedArr mutableCopy];
        [yFeedArr removeObjectAtIndex:0];
        ZKChartView *feedChart = [[ZKChartView alloc]initWithFrame:chartRect chartViewHeight:280 xTitleArray:xArr yValueArray:yFeedArr yMax:[yFeedArr.lastObject floatValue] yMin:0 yName:@"饲料"];
        [self.chartView addSubview:feedChart];
        
        //摄食率
        chartRect = CGRectMake(8, feedChart.bottom + 8, kScreenWidth - 16, 300);
        NSMutableArray *ySheShiLvArr =  [self.sheShiLvArr mutableCopy];
        [ySheShiLvArr removeObjectAtIndex:0];
        ZKChartView *sheShiLvChart = [[ZKChartView alloc]initWithFrame:chartRect chartViewHeight:280 xTitleArray:xArr yValueArray:ySheShiLvArr yMax:[ySheShiLvArr.lastObject floatValue] yMin:0 yName:@"摄食率"];
        [self.chartView addSubview:sheShiLvChart];

        //消化能
        chartRect = CGRectMake(8, sheShiLvChart.bottom + 8, kScreenWidth - 16, 300);
        NSMutableArray *yXiaoHuaNengArr =  [self.xiaoHuaNengArr mutableCopy];
        [yXiaoHuaNengArr removeObjectAtIndex:0];
        ZKChartView *xiaoHuaNengChart = [[ZKChartView alloc]initWithFrame:chartRect chartViewHeight:280 xTitleArray:xArr yValueArray:yXiaoHuaNengArr yMax:[yXiaoHuaNengArr.lastObject floatValue] yMin:0 yName:@"消化能"];
        [self.chartView addSubview:xiaoHuaNengChart];
        
        //饲料系数
        chartRect = CGRectMake(8, xiaoHuaNengChart.bottom + 8, kScreenWidth - 16, 300);
        NSMutableArray *yXiShuArr =  [self.xiShuArr mutableCopy];
        [yXiShuArr removeObjectAtIndex:0];
        ZKChartView *xiShuChart = [[ZKChartView alloc]initWithFrame:chartRect chartViewHeight:280 xTitleArray:xArr yValueArray:yXiShuArr yMax:[yXiShuArr.lastObject floatValue] yMin:0 yName:@"系数"];
        [self.chartView addSubview:xiShuChart];

    }
    else if ([self.title isEqualToString:@"N排放预测结果"])
    {
        //右部按钮
        self.navigationItem.rightBarButtonItem.title = @"P预测结果";
        //上部表
        cellW = (self.collectionWidth.constant - self.weeks - 3)/(self.weeks + 2);
        self.collectionHeight.constant = 236;
        cellH = (self.collectionHeight.constant - 5) / 4;
        //下部预测线图
        self.chartHeight.constant = 1000;
        CGRect chartRect = CGRectMake(8, 12, kScreenWidth - 16, 300);
        //x轴
        NSMutableArray *xArr =  [self.weekArr mutableCopy];
        [xArr removeObjectAtIndex:0];
        //y轴
        //固态N
        NSMutableArray *yNGuTaiArr =  [self.NGuTaiArr mutableCopy];
        [yNGuTaiArr removeObjectAtIndex:0];
        ZKChartView *NGuTaiChart = [[ZKChartView alloc]initWithFrame:chartRect chartViewHeight:280 xTitleArray:xArr yValueArray:yNGuTaiArr yMax:[yNGuTaiArr.lastObject floatValue] yMin:0 yName:@"固态N"];
        [self.chartView addSubview:NGuTaiChart];
        //液态N
        chartRect = CGRectMake(8, NGuTaiChart.bottom + 8, kScreenWidth - 16, 300);
        NSMutableArray *yNYeTaiArr =  [self.NYeTaiArr mutableCopy];
        [yNYeTaiArr removeObjectAtIndex:0];
        ZKChartView *NYeTaiChart = [[ZKChartView alloc]initWithFrame:chartRect chartViewHeight:280 xTitleArray:xArr yValueArray:yNYeTaiArr yMax:[yNYeTaiArr.lastObject floatValue] yMin:0 yName:@"液态N"];
        [self.chartView addSubview:NYeTaiChart];
        //总N
        chartRect = CGRectMake(8, NYeTaiChart.bottom + 8, kScreenWidth - 16, 300);
        NSMutableArray *yNAllArr =  [self.NAllArr mutableCopy];
        [yNAllArr removeObjectAtIndex:0];
        ZKChartView *NNAllChart = [[ZKChartView alloc]initWithFrame:chartRect chartViewHeight:280 xTitleArray:xArr yValueArray:yNAllArr yMax:[yNAllArr.lastObject floatValue] yMin:0 yName:@"总N"];
        [self.chartView addSubview:NNAllChart];
        
    }
    else if ([self.title isEqualToString:@"P排放预测结果"])
    {
        //右部按钮
        self.navigationItem.rightBarButtonItem.title = @"";
        //上部表
        cellW = (self.collectionWidth.constant - self.weeks - 3)/(self.weeks + 2);
        self.collectionHeight.constant = 236;
        cellH = (self.collectionHeight.constant - 5) / 4;
        //下部预测线图
        self.chartHeight.constant = 1000;
        CGRect chartRect = CGRectMake(8, 12, kScreenWidth - 16, 300);
        //x轴
        NSMutableArray *xArr =  [self.weekArr mutableCopy];
        [xArr removeObjectAtIndex:0];
        //y轴
        //固态P
        NSMutableArray *yPGuTaiArr =  [self.PGuTaiArr mutableCopy];
        [yPGuTaiArr removeObjectAtIndex:0];
        ZKChartView *PGuTaiChart = [[ZKChartView alloc]initWithFrame:chartRect chartViewHeight:280 xTitleArray:xArr yValueArray:yPGuTaiArr yMax:[yPGuTaiArr.lastObject floatValue] yMin:0 yName:@"固态P"];
        [self.chartView addSubview:PGuTaiChart];
        //液态P
        chartRect = CGRectMake(8, PGuTaiChart.bottom + 8, kScreenWidth - 16, 300);
        NSMutableArray *yPYeTaiArr =  [self.PYeTaiArr mutableCopy];
        [yPYeTaiArr removeObjectAtIndex:0];
        ZKChartView *PYeTaiChart = [[ZKChartView alloc]initWithFrame:chartRect chartViewHeight:280 xTitleArray:xArr yValueArray:yPYeTaiArr yMax:[yPYeTaiArr.lastObject floatValue] yMin:0 yName:@"液态P"];
        [self.chartView addSubview:PYeTaiChart];
        //总N
        chartRect = CGRectMake(8, PYeTaiChart.bottom + 8, kScreenWidth - 16, 300);
        NSMutableArray *yPAllArr =  [self.PAllArr mutableCopy];
        [yPAllArr removeObjectAtIndex:0];
        ZKChartView *PAllChart = [[ZKChartView alloc]initWithFrame:chartRect chartViewHeight:280 xTitleArray:xArr yValueArray:yPAllArr yMax:[yPAllArr.lastObject floatValue] yMin:0 yName:@"总P"];
        [self.chartView addSubview:PAllChart];
    }
    
    //上部表布局
    self.flowLayout.itemSize = CGSizeMake(cellW, cellH);
    self.flowLayout.minimumLineSpacing = 1;
    self.flowLayout.minimumInteritemSpacing = 1;
}

//跳转其他控制器
- (void)turnOtherVC
{
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"饲料预测结果"])
    {
        //传数据
        NSDictionary *dataDic = @{@"beginningWeight":[NSString stringWithFormat:@"%f",self.currentWeight],
                                  @"lowestTemp":[NSString stringWithFormat:@"%f",self.lowestTemp],
                                  @"averageTemp":[NSString stringWithFormat:@"%f",self.averageTemp],
                                  @"weeks":[NSString stringWithFormat:@"%ld",(long)self.weeks],
                                  @"TGC":[NSString stringWithFormat:@"%f",self.TGC],
                                  };
        //计算出结果
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ZKMain" bundle:nil];
        ZKFodderConfigVC *vc  = [storyboard instantiateViewControllerWithIdentifier:@"ZKFodderConfigVC"];
        vc.title = @"饲料预测";
        vc.dataDic = dataDic;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"N预测结果"])
    {
        //传数据
        NSDictionary *dataDic = @{@"beginningWeight":[NSString stringWithFormat:@"%f",self.currentWeight],
                                  @"lowestTemp":[NSString stringWithFormat:@"%f",self.lowestTemp],
                                  @"averageTemp":[NSString stringWithFormat:@"%f",self.averageTemp],
                                  @"weeks":[NSString stringWithFormat:@"%ld",(long)self.weeks],
                                  @"TGC":[NSString stringWithFormat:@"%f",self.TGC],
                                  };
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ZKMain" bundle:nil];
        ZKResultVC *vc  = [storyboard instantiateViewControllerWithIdentifier:@"ZKResultVC"];
        vc.title = @"N排放预测结果";
        vc.dataDic = dataDic;
        vc.fodder = self.fodder;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"P预测结果"])
    {
        //传数据
        NSDictionary *dataDic = @{@"beginningWeight":[NSString stringWithFormat:@"%f",self.currentWeight],
                                  @"lowestTemp":[NSString stringWithFormat:@"%f",self.lowestTemp],
                                  @"averageTemp":[NSString stringWithFormat:@"%f",self.averageTemp],
                                  @"weeks":[NSString stringWithFormat:@"%ld",(long)self.weeks],
                                  @"TGC":[NSString stringWithFormat:@"%f",self.TGC],
                                  };
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ZKMain" bundle:nil];
        ZKResultVC *vc  = [storyboard instantiateViewControllerWithIdentifier:@"ZKResultVC"];
        vc.title = @"P排放预测结果";
        vc.dataDic = dataDic;
        vc.fodder = self.fodder;
        [self.navigationController pushViewController:vc animated:YES];
    }
}



//体重计算
- (void)calcuteWeight
{
   
    self.weightArr = [[NSMutableArray alloc]initWithObjects:@"0", nil];
    self.weekArr = [[NSMutableArray alloc]initWithObjects:@"0", nil];
    
    for (int i = 0; i <= self.weeks; i++)
    {
        //7天计算一次体重
        CGFloat finallyWeight = powf((powf(self.currentWeight, 1.0/3.0) + self.TGC * (i * 7 * self.averageTemp)/100) , 3.0);
        //保存到体重数组中
        [self.weightArr addObject:[NSString stringWithFormat:@"%.3f",finallyWeight]];
        [self.weekArr addObject:[NSString stringWithFormat:@"%d",i]];
    }
}


//肥料计算数据
- (void)calcuteFodder
{
//    vc.currentWeight --
//    vc.TGC
//    vc.averageTemp --
//    vc.days --
//    vc.weeks  --
//    vc.lowestTemp --
    
    // 1克  6度  21温度  3周   10只
    //时间               0      1
    //饲料 kg          0.01    0.01
    //摄食率 %BW/天     9.57    8.64
    //消化能 百万焦/千克  8.14   11.64
    //饲料系数  F:G     1.15    1.15
     //----------------------华丽分割线--------------------------

    //x轴
    self.weekArr = [[NSMutableArray alloc]initWithObjects:@"0", nil];
    //y轴
    //饲料
    CGFloat feed = 0.0;
    self.feedArr = [[NSMutableArray alloc]initWithObjects:@"0", nil];
    //摄食率 %BW/天
    CGFloat sheShiLv = 0.0;
    self.sheShiLvArr = [[NSMutableArray alloc]initWithObjects:@"0", nil];
    //消化能 百万焦/千克
    CGFloat xiaoHuaNeng = 0.0;
    self.xiaoHuaNengArr = [[NSMutableArray alloc]initWithObjects:@"0", nil];
    //饲料系数  F:G
    CGFloat xiShu = 0.0;
    self.xiShuArr = [[NSMutableArray alloc]initWithObjects:@"0", nil];
    
    
    NSInteger sumDegreeDaysCumul = 0;
    CGFloat weight = self.currentWeight;
    NSMutableArray *weightArr = [[NSMutableArray alloc]init];
    
    CGFloat REChuJiNeng = 0.0;
    CGFloat HeEJiChuDaiXieNeng = 0.0;
    CGFloat HiEReZengZhongNeng = 0.0;
    CGFloat UEZEPaiXieNeng = 0.0;
    CGFloat DEXiaoHuaNeng = 0.0;
    CGFloat feedEF = 0.0;
    
    for (int i = 0; i <= self.weeks; i++)
    {
        //x轴
         [self.weekArr addObject:[NSString stringWithFormat:@"%d",i]];
        //Sum DegreeDays Period
        //Sum DegreeDays Period = (平均温度 − 最低温度) × 7
        //SumDegreeDaysCumul
        //Sum DegreeDays Period 的和
        NSInteger sumDegreeDaysPeriod = (self.averageTemp  - self.lowestTemp) * 7;
        sumDegreeDaysCumul += sumDegreeDaysPeriod;
        
        //保存当前weight
        [weightArr addObject:[NSString stringWithFormat:@"%f",weight]];
        
        //Weight
        if (weight < 30.0)
        {
            //Weight = ((前一天Weight)^(0.193252514500678)+((0.03777÷100)×SumDegreeDaysCumul))^(1÷0.193252514500678)
            weight = powf(powf(weight, 0.193252514500678)+((0.03777/100)*sumDegreeDaysCumul),(1/0.193252514500678));
        }
        else
        {
            //Weight = ((前一天Weight)^(0.001)+((0.00015÷100)×SumDegreeDaysCumul))^(1÷0.001)
            weight = powf(powf(weight, 0.001)+((0.00015/100)*sumDegreeDaysCumul),(1/0.001));
        }
        
        //RE（储积能）= (7.8635 × 后一天Weight − 249.77) − (7.8035 × 当前Weight − 249.77)
        CGFloat currentWeight = [[weightArr lastObject] floatValue];
        REChuJiNeng = ((7.8635*weight)-249.77)-(7.8035*currentWeight-249.77);
        
        //HeE（基础代谢能）= 7×(2.39 × 平均温度 −30.33)×(当前Weight ÷ 1000)^(0.8)
        HeEJiChuDaiXieNeng = 7*(2.39 * self.averageTemp-30.33) * powf(currentWeight/1000, 0.8);
        
        //HiE（热增重能）= (RE（储积能）+ HeE（基础代谢能）)×0.45
        HiEReZengZhongNeng =(REChuJiNeng+ HeEJiChuDaiXieNeng)*0.45;
        
        //UEZE（排泄能）= (RE（储积能）+HeE（基础代谢能）+HiE（热增重能）)×0.043
        UEZEPaiXieNeng = (REChuJiNeng + HeEJiChuDaiXieNeng + HiEReZengZhongNeng)*0.043;
        
        //DE消化能kj = RE（储积能）+HeE（基础代谢能）+HiE（热增重能）+UEZE（排泄能）
        DEXiaoHuaNeng = REChuJiNeng + HiEReZengZhongNeng + HiEReZengZhongNeng + UEZEPaiXieNeng;
        
        
        //饲料Feed
        if (currentWeight < 30)
        {
            //饲料 = DE消化能kj÷饲料的可消化能1,
            feed = DEXiaoHuaNeng / 12.2;
            //保存到饲料数组
            [self.feedArr addObject:[NSString stringWithFormat:@"%.3f",feed]];
        }
        else
        {
            //饲料 = DE消化能kj÷饲料的可消化能2
            feed = DEXiaoHuaNeng / 11.3;
            [self.feedArr addObject:[NSString stringWithFormat:@"%.3f",feed]];
        }
        
        //摄食率 %BW/天
        //摄食率  = 100 × (饲料Feed ÷ 7) ÷ Weight
        sheShiLv = 100 * (feed / 7) / currentWeight;
        [self.sheShiLvArr addObject:[NSString stringWithFormat:@"%.3f",sheShiLv]];
        
        //消化能 百万焦/千克
        //消化能 = DE消化能kj ÷ (后一天Weight − 当前Weight)
        xiaoHuaNeng = DEXiaoHuaNeng / ( weight - currentWeight);
        [self.xiaoHuaNengArr addObject:[NSString stringWithFormat:@"%.3f",xiaoHuaNeng]];
        
        //Feed eff. = (后一天Weight − 当前Weight)÷饲料Feed
        feedEF = (weight - currentWeight)/feed;
        
        //饲料系数  F:G
        //饲料系数  = 1÷ Feed eff.
        xiShu = 1 / feedEF;
        [self.xiShuArr addObject:[NSString stringWithFormat:@"%.3f",xiShu]];
    }
    
}

//N排放量预测
- (void)calculateN
{
    // 1克  6度  21温度  3周   1只
    //时间         0         1
    //固态氮g      0.0087    0.0122
    //液态氮g      0.0083    0.0118
    //总氮排放     0.017     0.0239
    
    //x轴
    self.weekArr = [[NSMutableArray alloc]initWithObjects:@"0", nil];
    //y轴
    //固态N
    CGFloat guTaiN = 0.0;
    self.NGuTaiArr = [[NSMutableArray alloc]initWithObjects:@"0", nil];
    //液态N
    CGFloat yeTaiN = 0.0;
    self.NYeTaiArr = [[NSMutableArray alloc]initWithObjects:@"0", nil];
    //总N
    CGFloat allN = 0.0;
    self.NAllArr = [[NSMutableArray alloc]initWithObjects:@"0", nil];
    
    //肥的CP = Nursery时为33 其他为 28
    //肥的DP = Nursery时为25.41  其他为22.96
    CGFloat CP = 0.0;
    CGFloat DP = 0.0;
    
    if ([self.fodder containsString:@"Nursery"])
    {
        CP = 33.0;
        DP = 25.41;
    }
    else
    {
        CP = 28.0;
        DP = 22.96;
    }

    NSInteger sumDegreeDaysCumul = 0;
    CGFloat weight = self.currentWeight;
    NSMutableArray *weightArr = [[NSMutableArray alloc]init];
    
    CGFloat REChuJiNeng = 0.0;
    CGFloat HeEJiChuDaiXieNeng = 0.0;
    CGFloat HiEReZengZhongNeng = 0.0;
    CGFloat UEZEPaiXieNeng = 0.0;
    CGFloat DEXiaoHuaNeng = 0.0;
    CGFloat feed = 0.0;
    
    CGFloat sheruAllN = 0.00;
    CGFloat xiaohuaN = 0.00;
    CGFloat fenN = 0.00;
    CGFloat chujiN = 0.00;
    
    for (int i = 0; i <= self.weeks; i++)
    {
        //x轴
        [self.weekArr addObject:[NSString stringWithFormat:@"%d",i]];
        //Sum DegreeDays Period
        //Sum DegreeDays Period = (平均温度 − 最低温度) × 7
        //SumDegreeDaysCumul
        //Sum DegreeDays Period 的和
        NSInteger sumDegreeDaysPeriod = (self.averageTemp  - self.lowestTemp) * 7;
        sumDegreeDaysCumul += sumDegreeDaysPeriod;
        
        //保存当前weight
        [weightArr addObject:[NSString stringWithFormat:@"%f",weight]];
        
        //Weight
        if (weight < 30.0)
        {
            //Weight = ((前一天Weight)^(0.193252514500678)+((0.03777÷100)×SumDegreeDaysCumul))^(1÷0.193252514500678)
            weight = powf(powf(weight, 0.193252514500678)+((0.03777/100)*sumDegreeDaysCumul),(1/0.193252514500678));
        }
        else
        {
            //Weight = ((前一天Weight)^(0.001)+((0.00015÷100)×SumDegreeDaysCumul))^(1÷0.001)
            weight = powf(powf(weight, 0.001)+((0.00015/100)*sumDegreeDaysCumul),(1/0.001));
        }
        //RE（储积能）= (7.8635 × 后一天Weight − 249.77) − (7.8035 × 当前Weight − 249.77)
        CGFloat currentWeight = [[weightArr lastObject] floatValue];
        REChuJiNeng = ((7.8635*weight)-249.77)-(7.8035*currentWeight-249.77);
        
        //HeE（基础代谢能）= 7×(2.39 × 平均温度 −30.33)×(当前Weight ÷ 1000)^(0.8)
        HeEJiChuDaiXieNeng = 7*(2.39 * self.averageTemp-30.33) * powf(currentWeight/1000, 0.8);
        
        //HiE（热增重能）= (RE（储积能）+ HeE（基础代谢能）)×0.45
        HiEReZengZhongNeng =(REChuJiNeng+ HeEJiChuDaiXieNeng)*0.45;
        
        //UEZE（排泄能）= (RE（储积能）+HeE（基础代谢能）+HiE（热增重能）)×0.043
        UEZEPaiXieNeng = (REChuJiNeng + HeEJiChuDaiXieNeng + HiEReZengZhongNeng)*0.043;
        
        //DE消化能kj = RE（储积能）+HeE（基础代谢能）+HiE（热增重能）+UEZE（排泄能）
        DEXiaoHuaNeng = REChuJiNeng + HiEReZengZhongNeng + HiEReZengZhongNeng + UEZEPaiXieNeng;
        
        //饲料Feed
        if (currentWeight < 30)
        {
            //饲料 = DE消化能kj÷饲料的可消化能1,
            feed = DEXiaoHuaNeng / 12.2;
            //保存到饲料数组
            [self.feedArr addObject:[NSString stringWithFormat:@"%.3f",feed]];
        }
        else
        {
            //饲料 = DE消化能kj÷饲料的可消化能2
            feed = DEXiaoHuaNeng / 11.3;
            [self.feedArr addObject:[NSString stringWithFormat:@"%.3f",feed]];
        }
        
        //摄入的总N = 饲料Feed × 肥的CP ÷ (6.25×100)
        sheruAllN = feed * CP / (6.25 * 100);
        
        //消化的N = 饲料Feed×(肥的DP÷100)÷6.25
        xiaohuaN = feed * (DP / 100) / 6.25;
     
        //粪N = 摄入的总N − 消化的N
        fenN = sheruAllN - xiaohuaN;
        
        // //固态氮g = 饲料Feed × (3÷100) × (肥的CP÷100) ÷ 6.25 + 粪N
        guTaiN = feed * (3/100) * (CP/100) / 6.25 + fenN;
        [self.NGuTaiArr addObject:[NSString stringWithFormat:@"%.4f",guTaiN]];
        
        //储积N = (((0.1985×第二天weight)−2.9405)÷6.25)−(((0.1985×当前weight)−2.9405)÷6.25)
        chujiN = (((0.1985*weight)-2.9405)/6.25)-(((0.1985*currentWeight)-2.9405)/6.25);
        
        //  //液态氮g = 消化的N − 储积N
        yeTaiN = xiaohuaN - chujiN;
        [self.NYeTaiArr addObject:[NSString stringWithFormat:@"%.4f",yeTaiN]];
        
        //总氮排放 = 固态氮g + 液态氮g
        allN = guTaiN + yeTaiN;
        [self.NAllArr addObject:[NSString stringWithFormat:@"%.4f",allN]];
    }
}


//P排放量预测
- (void)calculateP
{
    // 1克  6度  21温度  3周   1只
    //时间         0         1
    //固态磷g      0.0032    0.0045
    //液态磷g      0.0008    0.0012
    //总磷排放     0.004     0.0057
    
    //x轴
    self.weekArr = [[NSMutableArray alloc]initWithObjects:@"0", nil];
    //y轴
    //固态N
    CGFloat guTaiP = 0.0;
    self.PGuTaiArr = [[NSMutableArray alloc]initWithObjects:@"0", nil];
    //液态N
    CGFloat yeTaiP = 0.0;
    self.PYeTaiArr = [[NSMutableArray alloc]initWithObjects:@"0", nil];
    //总N
    CGFloat allP = 0.0;
    self.PAllArr = [[NSMutableArray alloc]initWithObjects:@"0", nil];

    //肥的Pi = Nursery时为1 其他为 0.6
    //肥的TPi = Nursery时为1.0 其他为 0.6
    //肥的DPi = Nursery时为0.52 其他为 0.33
    CGFloat Pi = 0.0;
    CGFloat TPi = 0.0;
    CGFloat DPi = 0.0;
    
    if ([self.fodder containsString:@"Nursery"])
    {
        Pi = 1.0;
        TPi = 1.0;
        DPi = 0.52;
    }
    else
    {
        Pi = 0.6;
        TPi = 0.6;
        DPi = 0.33;
    }
    
    NSInteger sumDegreeDaysCumul = 0;
    CGFloat weight = self.currentWeight;
    NSMutableArray *weightArr = [[NSMutableArray alloc]init];
    
    CGFloat REChuJiNeng = 0.0;
    CGFloat HeEJiChuDaiXieNeng = 0.0;
    CGFloat HiEReZengZhongNeng = 0.0;
    CGFloat UEZEPaiXieNeng = 0.0;
    CGFloat DEXiaoHuaNeng = 0.0;
    CGFloat feed = 0.0;
    
    CGFloat sheruAllP = 0.00;
    CGFloat xiaohuaP = 0.00;
    CGFloat fenP = 0.00;
    CGFloat chujiP = 0.00;
    
    for (int i = 0; i <= self.weeks; i++)
    {
        //x轴
        [self.weekArr addObject:[NSString stringWithFormat:@"%d",i]];
        //Sum DegreeDays Period
        //Sum DegreeDays Period = (平均温度 − 最低温度) × 7
        //SumDegreeDaysCumul
        //Sum DegreeDays Period 的和
        NSInteger sumDegreeDaysPeriod = (self.averageTemp  - self.lowestTemp) * 7;
        sumDegreeDaysCumul += sumDegreeDaysPeriod;
        
        //保存当前weight
        [weightArr addObject:[NSString stringWithFormat:@"%f",weight]];
        
        //Weight
        if (weight < 30.0)
        {
            //Weight = ((前一天Weight)^(0.193252514500678)+((0.03777÷100)×SumDegreeDaysCumul))^(1÷0.193252514500678)
            weight = powf(powf(weight, 0.193252514500678)+((0.03777/100)*sumDegreeDaysCumul),(1/0.193252514500678));
        }
        else
        {
            //Weight = ((前一天Weight)^(0.001)+((0.00015÷100)×SumDegreeDaysCumul))^(1÷0.001)
            weight = powf(powf(weight, 0.001)+((0.00015/100)*sumDegreeDaysCumul),(1/0.001));
        }
        //RE（储积能）= (7.8635 × 后一天Weight − 249.77) − (7.8035 × 当前Weight − 249.77)
        CGFloat currentWeight = [[weightArr lastObject] floatValue];
        REChuJiNeng = ((7.8635*weight)-249.77)-(7.8035*currentWeight-249.77);
        
        //HeE（基础代谢能）= 7×(2.39 × 平均温度 −30.33)×(当前Weight ÷ 1000)^(0.8)
        HeEJiChuDaiXieNeng = 7*(2.39 * self.averageTemp-30.33) * powf(currentWeight/1000, 0.8);
        
        //HiE（热增重能）= (RE（储积能）+ HeE（基础代谢能）)×0.45
        HiEReZengZhongNeng =(REChuJiNeng+ HeEJiChuDaiXieNeng)*0.45;
        
        //UEZE（排泄能）= (RE（储积能）+HeE（基础代谢能）+HiE（热增重能）)×0.043
        UEZEPaiXieNeng = (REChuJiNeng + HeEJiChuDaiXieNeng + HiEReZengZhongNeng)*0.043;
        
        //DE消化能kj = RE（储积能）+HeE（基础代谢能）+HiE（热增重能）+UEZE（排泄能）
        DEXiaoHuaNeng = REChuJiNeng + HiEReZengZhongNeng + HiEReZengZhongNeng + UEZEPaiXieNeng;
        
        //饲料Feed
        if (currentWeight < 30)
        {
            //饲料 = DE消化能kj÷饲料的可消化能1,
            feed = DEXiaoHuaNeng / 12.2;
            //保存到饲料数组
            [self.feedArr addObject:[NSString stringWithFormat:@"%.3f",feed]];
        }
        else
        {
            //饲料 = DE消化能kj÷饲料的可消化能2
            feed = DEXiaoHuaNeng / 11.3;
            [self.feedArr addObject:[NSString stringWithFormat:@"%.3f",feed]];
        }

        //摄入的总P =饲料Feed×肥的TPi÷(100), IF(L13="Nursery",$G13×$O$8÷(100),$G13×$O$9÷(100))
        sheruAllP = feed * TPi / 100;
        
        //可消化的P = 饲料Feed×肥的DPi÷(100)  IF(L13="Nursery",$G13×$P$8÷(100),$G13×($P$9÷100))
        if ([self.fodder containsString:@"Nursery"]) {
            xiaohuaP = feed * DPi / 100;
        }
        else
        {
            xiaohuaP = feed * (DPi / 100);
        }
        
        //粪P = 摄入的总P - 可消化的P
        fenP = sheruAllP - xiaohuaP;
        
        //    固态磷g
        // 固态p = 饲料Feed×(3÷100)×(肥的Pi÷100)+粪P
        guTaiP = feed * (3/100) *(Pi/100) + fenP;
        [self.PGuTaiArr addObject:[NSString stringWithFormat:@"%.4f",guTaiP]];
        
        //储积磷RPi = (((0.0045×第二天weight)+0.0063))−(((0.0045×weight)+0.0063))
        chujiP = (((0.0045*weight)+0.0063))-(((0.0045*currentWeight)+0.0063));
        
        //    液态磷g
        //液态p = 可消化的磷−储积磷RPi
        yeTaiP = xiaohuaP - chujiP;
        [self.PYeTaiArr addObject:[NSString stringWithFormat:@"%.4f",yeTaiP]];
        
        //    总磷 =  固态p + 液态p
        allP = guTaiP + yeTaiP;
        [self.PAllArr addObject:[NSString stringWithFormat:@"%.4f",allP]];
    }
    
}

- (IBAction)didClickBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - collectionView

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if ([self.title isEqualToString:@"体重预测结果"])
    {
        return 2;
    }
    else if ([self.title isEqualToString:@"饲料预测结果"])
    {
        return 5;
    }
    else
    {
        return 4;
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.weeks + 2;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont: [UIFont systemFontOfSize:15]];
    cell.backgroundView = label;
    
    
    if ([self.title isEqualToString:@"体重预测结果"])
    {
        if (indexPath.section == 0)
        {
            label.text =[NSString stringWithFormat:@"%@",self.weekArr[indexPath.item]];
            if (indexPath.item == 0)
            {
                label.text = @"时间(周)";
            }
        }
        else if (indexPath.section == 1)
        {
            label.text =[NSString stringWithFormat:@"%@",self.weightArr[indexPath.item]];
            
            if (indexPath.item == 0)
            {
                label.text = @"体重(克)";
            }
        }
    }
    else if ([self.title isEqualToString:@"饲料预测结果"])
    {
        if (indexPath.section == 0)
        {
            label.text =[NSString stringWithFormat:@"%@",self.weekArr[indexPath.item]];
            if (indexPath.item == 0)
            {
                label.text = @"时间(周)";
            }
        }
        else if (indexPath.section == 1)
        {
            label.text =[NSString stringWithFormat:@"%@",self.feedArr[indexPath.item]];
            if (indexPath.item == 0)
            {
                label.text = @"饲料(g)";
            }
        }
        else if (indexPath.section == 2)
        {
            label.text =[NSString stringWithFormat:@"%@",self.sheShiLvArr[indexPath.item]];
            if (indexPath.item == 0)
            {
                label.text = @"摄食率(%BW)";
            }
        }
        else if (indexPath.section == 3)
        {
            label.text =[NSString stringWithFormat:@"%@",self.xiaoHuaNengArr[indexPath.item]];
            if (indexPath.item == 0)
            {
                label.text = @"消化能(MJ)";
            }
        }
        else if (indexPath.section == 4)
        {
            label.text =[NSString stringWithFormat:@"%@",self.xiShuArr[indexPath.item]];
            if (indexPath.item == 0)
            {
                label.text = @"系数F:G";
            }
        }
    }
    else if ([self.title isEqualToString:@"N排放预测结果"])
    {
        if (indexPath.section == 0)
        {
            label.text =[NSString stringWithFormat:@"%@",self.weekArr[indexPath.item]];
            if (indexPath.item == 0)
            {
                label.text = @"时间(周)";
            }
        }
        else if (indexPath.section == 1)
        {
            label.text =[NSString stringWithFormat:@"%@",self.NGuTaiArr[indexPath.item]];
            if (indexPath.item == 0)
            {
                label.text = @"固态N(g)";
            }
        }
        else if (indexPath.section == 2)
        {
            label.text =[NSString stringWithFormat:@"%@",self.NYeTaiArr[indexPath.item]];
            if (indexPath.item == 0)
            {
                label.text = @"液态N(g)";
            }
        }
        else if (indexPath.section == 3)
        {
            label.text =[NSString stringWithFormat:@"%@",self.NAllArr[indexPath.item]];
            if (indexPath.item == 0)
            {
                label.text = @"总N(g)";
            }
        }
    }
    else if ([self.title isEqualToString:@"P排放预测结果"])
    {
        if (indexPath.section == 0)
        {
            label.text =[NSString stringWithFormat:@"%@",self.weekArr[indexPath.item]];
            if (indexPath.item == 0)
            {
                label.text = @"时间(周)";
            }
        }
        else if (indexPath.section == 1)
        {
            label.text =[NSString stringWithFormat:@"%@",self.PGuTaiArr[indexPath.item]];
            if (indexPath.item == 0)
            {
                label.text = @"固态P(g)";
            }
        }
        else if (indexPath.section == 2)
        {
            label.text =[NSString stringWithFormat:@"%@",self.PYeTaiArr[indexPath.item]];
            if (indexPath.item == 0)
            {
                label.text = @"液态P(g)";
            }
        }
        else if (indexPath.section == 3)
        {
            label.text =[NSString stringWithFormat:@"%@",self.PAllArr[indexPath.item]];
            if (indexPath.item == 0)
            {
                label.text = @"总P(g)";
            }
        }
    }

    
    return cell;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
