//
//  ZKFodderConfigVC.m
//  FeedSystem
//
//  Created by Mac on 2017/5/12.
//  Copyright © 2017年 bigtutu. All rights reserved.
//
//饲料配置控制器

#import "ZKFodderConfigVC.h"
#import "ZKFodderManageVC.h"
#import "ZKResultVC.h"
#import "UIResponder+FirstResponder.h"
#import "ZKCoreDataManager.h"//数据库管理者
#import "Fodder+CoreDataProperties.h"

@interface ZKFodderConfigVC ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *fishNumTF;//鱼数量
@property (weak, nonatomic) IBOutlet UITextField *fodderTF1;//肥料1级
@property (weak, nonatomic) IBOutlet UITextField *fodderTF2;//肥料2级
@property (weak, nonatomic) IBOutlet UITextField *fodderTF3;//肥料3级
@property (weak, nonatomic) IBOutlet UITextField *fodderTF4;//肥料4级

@property (nonatomic,strong)NSMutableArray * fodderArr;//肥料

@end

@implementation ZKFodderConfigVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initPickerView];
    
    [self getFodderData];
}

//配置pickerView
- (void)initPickerView
{
    UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 180)];
    pickerView.backgroundColor = [UIColor whiteColor];
    
    //指定数据源和委托
    pickerView.delegate = self;
    pickerView.dataSource = self;
    
    self.fodderTF1.inputView = pickerView;
    self.fodderTF2.inputView = pickerView;
    self.fodderTF3.inputView = pickerView;
    self.fodderTF4.inputView = pickerView;
}


//从数据库中拿数据
- (void)getFodderData
{
    //1.创建一个查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Fodder"];
    //查询数据
    NSArray<Fodder*> *fodderArr = [kZKCoreDataManager.persistentContainer.viewContext executeFetchRequest:request error:nil];
    //排序
    NSArray *arr = [fodderArr sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name_id" ascending:YES]]];

    self.fodderArr = [[NSMutableArray alloc]init];
    //加载数据
    for (Fodder* fodder in arr) {
        [self.fodderArr addObject:fodder.name];
    }
//        NSLog(@"%@",self.fodderArr);
}



- (IBAction)didClickBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//计算
- (IBAction)calculate:(UIButton *)sender {
    
    if ([self.fishNumTF.text isEqualToString:@""])
    {
        [self alertWithMessage:@"请输入养殖数量!"];
        return;
    }
    
    
    
    //计算出结果
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ZKMain" bundle:nil];
    ZKResultVC *vc  = [storyboard instantiateViewControllerWithIdentifier:@"ZKResultVC"];
    //传值
    vc.currentWeight = [self.dataDic[@"beginningWeight"] floatValue];
    vc.TGC = [self.dataDic[@"TGC"] floatValue];
    vc.averageTemp = [self.dataDic[@"averageTemp"] floatValue];
    vc.weeks = [self.dataDic[@"weeks"] integerValue];
    vc.lowestTemp = [self.dataDic[@"lowestTemp"] integerValue];
    vc.fodder = self.fodderTF1.text;
    
    if ([self.title isEqualToString:@"饲料预测"])
    {
        vc.title = @"饲料预测结果";
    }
    else if ([self.title isEqualToString:@"N预测"])
    {
        vc.title = @"N排放预测结果";
    }
    else if ([self.title isEqualToString:@"P预测"])
    {
        vc.title = @"P排放预测结果";
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - pickerview

//指定pickerview有几个表盘
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//指定每个表盘上有几行数据
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.fodderArr.count;
}

//指定每行几个数据
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return self.fodderArr[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //获取对应列，对应行的数据
//    NSString *name=self.foods[component][row];
    if ([[UIResponder currentFirstResponder] isKindOfClass:[UITextField class]])
    {
        UITextField *tf = [UIResponder currentFirstResponder];
        tf.text = self.fodderArr[row];
    }
   
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


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    ZKFodderManageVC *secondVC = (ZKFodderManageVC *)segue.destinationViewController;//要跳转的vc
    //fodderManage
    if ([segue.identifier isEqualToString:@"fodderManage"])
    {
        secondVC.fodderArr = self.fodderArr;
    }

}


@end
