//
//  ZKChangeTGCVC.m
//  FeedSystem
//
//  Created by Mac on 2017/5/12.
//  Copyright © 2017年 bigtutu. All rights reserved.
//

#import "ZKChangeTGCVC.h"
#import <math.h>
#import "ZKTGCTableViewCell.h"
#import "ZKCoreDataManager.h"//数据库管理者
#import "TGC+CoreDataProperties.h"


@interface ZKChangeTGCVC ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *lowestTemp;//最低温度
@property (weak, nonatomic) IBOutlet UITableView *tgcTableView;//显示tgc

@property (nonatomic, strong) NSMutableArray *timeArr;//时间
@property (nonatomic, strong) NSMutableArray *tempArr;//温度
@property (nonatomic, strong) NSMutableArray *weightArr;//体重

@end

@implementation ZKChangeTGCVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tgcTableView.dataSource = self;
    self.tgcTableView.delegate = self;
    
    [self getTGCData];
}

//从数据库中拿数据
- (void)getTGCData
{
    //1.创建一个查询请求
    NSFetchRequest *request1 = [[NSFetchRequest alloc] initWithEntityName:@"TGC"];
    //查询数据
    NSArray<TGC*> *tgcArr = [kZKCoreDataManager.persistentContainer.viewContext executeFetchRequest:request1 error:nil];
    //排序
    NSArray *arr = [tgcArr sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES]]];
//    NSLog(@"%@",arr);
    
    self.timeArr = [[NSMutableArray alloc]init];
    self.tempArr = [[NSMutableArray alloc]init];
    self.weightArr = [[NSMutableArray alloc]init];
    //加载数据
    for (TGC* tgc in arr) {
        [self.timeArr addObject:tgc.time];
        [self.tempArr addObject:tgc.temp];
        [self.weightArr addObject:tgc.weight];
    }
   
//    NSLog(@"%@",self.timeArr);
//    NSLog(@"%@",self.tempArr);
//    NSLog(@"%@",self.weightArr);
    
}

//返回
- (IBAction)didClickBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//复杂计算
- (IBAction)calculate:(UIButton *)sender {
    if ([self.lowestTemp.text isEqualToString:@""])
    {
        [self alertWithMessage:@"请填写最低温度!"];
        return;
    }
    
    //最低温度
    NSInteger lowTemp = [self.lowestTemp.text integerValue];
    //sumDegreeDaysCumul 为 上面的和
    NSInteger sumDegreeDaysCumul = 0;
    [self.tempArr removeObjectAtIndex:0];
    for (NSString *temp in self.tempArr)
    {
        //Sum DegreeDays Period = (当前温度 - 最低温度) * 7
        NSInteger sumDegreeDaysPeriod = ([temp integerValue] - lowTemp) * 7;
        sumDegreeDaysCumul += sumDegreeDaysPeriod;
    }
//    NSLog(@"%ld",(long)sumDegreeDaysCumul);
    
    //计算tgc的值
    CGFloat currentWeight = [self.weightArr.lastObject floatValue];
    CGFloat intialWeight = [self.weightArr.firstObject floatValue];
    CGFloat TGC = 100*(powf(currentWeight, 1.0/3.0)-powf(intialWeight, 1.0/3.0))/sumDegreeDaysCumul;
//    NSLog(@"%f",TGC);
    //保存tgc与最低温度的值
    NSString *tgc = [NSString stringWithFormat:@"%f",TGC];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:tgc forKey:@"tgc"];
    [user setObject:self.lowestTemp.text forKey:@"lowestTemp"];
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - tableview

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.timeArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZKTGCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCellID"];
    
    if (!cell)
    {
        cell = [[ZKTGCTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCellID"];
    }
    //赋值
    cell.timeTF.text = self.timeArr[indexPath.item];
    cell.tempTF.text = self.tempArr[indexPath.item];
    cell.weightTF.text = self.weightArr[indexPath.item];
    
    return cell;
}


//简单的弹窗
-(void)alertWithMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action1];
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
