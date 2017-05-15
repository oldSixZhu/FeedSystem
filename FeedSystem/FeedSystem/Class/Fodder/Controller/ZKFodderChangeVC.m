//
//  ZKFodderChangeVC.m
//  FeedSystem
//
//  Created by Mac on 2017/5/12.
//  Copyright © 2017年 bigtutu. All rights reserved.
//

#import "ZKFodderChangeVC.h"
#import "ZKCoreDataManager.h"//数据库管理者
#import "Fodder+CoreDataProperties.h"

@interface ZKFodderChangeVC ()

@property (weak, nonatomic) IBOutlet UITextField *nameTF;//名字
@property (weak, nonatomic) IBOutlet UITextField *dmTF;//干物质
@property (weak, nonatomic) IBOutlet UITextField *cpTF;//粗蛋白
@property (weak, nonatomic) IBOutlet UITextField *lipidTF;//脂肪
@property (weak, nonatomic) IBOutlet UITextField *crudeTF;//粗纤维
@property (weak, nonatomic) IBOutlet UITextField *pTF;//磷
@property (weak, nonatomic) IBOutlet UITextField *ashTF;//灰分
@property (weak, nonatomic) IBOutlet UITextField *danbaiTF;//蛋白质消化率
@property (weak, nonatomic) IBOutlet UITextField *dpiTF;//磷消化率
@property (weak, nonatomic) IBOutlet UITextField *rongshiTF;//溶失率


@end

@implementation ZKFodderChangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getFodderData];
}

//从数据库中拿数据
- (void)getFodderData
{
    //1.创建一个查询请求
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Fodder"];
    //2.创建查询谓词（查询条件）
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@",self.name];
    //3.给查询请求设置谓词
    request.predicate = predicate;
    //4.查询数据
    NSArray<Fodder*> *arr = [kZKCoreDataManager.persistentContainer.viewContext executeFetchRequest:request error:nil];
    
//    NSLog(@"%@<-->%@",arr1.firstObject.user_id,arr1.firstObject.password);

    self.nameTF.text = arr.firstObject.name;
    self.dmTF.text = arr.firstObject.dm;
    self.cpTF.text = arr.firstObject.cp;
    self.lipidTF.text = arr.firstObject.lipid;
    self.crudeTF.text = arr.firstObject.crude;
    self.pTF.text = arr.firstObject.p;
    self.ashTF.text = arr.firstObject.ash;
    self.danbaiTF.text = arr.firstObject.danbai;
    self.dpiTF.text = arr.firstObject.dpi;
    self.rongshiTF.text = arr.firstObject.rongshi;
    
}


- (IBAction)didClickBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//更新数据
- (IBAction)save:(UIButton *)sender {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Fodder"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@",self.name];
    request.predicate = predicate;
    NSArray<Fodder*> *arr = [kZKCoreDataManager.persistentContainer.viewContext executeFetchRequest:request error:nil];
    
    arr.firstObject.name = self.nameTF.text;
    arr.firstObject.dm = self.dmTF.text;
    arr.firstObject.cp = self.cpTF.text;
    arr.firstObject.lipid = self.lipidTF.text;
    arr.firstObject.crude = self.crudeTF.text;
    arr.firstObject.p = self.pTF.text;
    arr.firstObject.ash = self.ashTF.text;
    arr.firstObject.danbai = self.danbaiTF.text;
    arr.firstObject.dpi = self.dpiTF.text;
    arr.firstObject.rongshi = self.rongshiTF.text;
    
    [kZKCoreDataManager save];
    [self.navigationController popViewControllerAnimated:YES];
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
