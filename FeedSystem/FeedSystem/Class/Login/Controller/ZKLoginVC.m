//
//  ZKLoginVC.m
//  FeedSystem
//
//  Created by Mac on 2017/5/12.
//  Copyright © 2017年 bigtutu. All rights reserved.
//
//登录控制器

#import "ZKLoginVC.h"
#import "User+CoreDataProperties.h"//数据模型
#import "ZKCoreDataManager.h"//数据库管理者

@interface ZKLoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;//姓名
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;//密码

@end

@implementation ZKLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];

}
//登录
- (IBAction)didClickLogin:(UIButton *)sender {
    
    
    //1.创建一个查询请求
    NSFetchRequest *request1 = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    //2.创建查询谓词（查询条件）
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"user_id == %@",self.nameTF.text];
    //3.给查询请求设置谓词
    request1.predicate = predicate1;
    //4.查询数据
    NSArray<User*> *arr1 = [kZKCoreDataManager.persistentContainer.viewContext executeFetchRequest:request1 error:nil];
    
    NSLog(@"%@<-->%@",arr1.firstObject.user_id,arr1.firstObject.password);
    
    if ([self.nameTF.text isEqualToString:arr1.firstObject.user_id]
        &&[self.passwordTF.text isEqualToString:arr1.firstObject.password])
    {
        /**1.创建Storyboard,加载Storyboard的名字,这里是自己创建的Storyboard的名字*/
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ZKMain" bundle:nil];
        /**2.加载storyboard里的控制器,标识符的控制器*/
        UINavigationController *vc  = [storyboard instantiateViewControllerWithIdentifier:@"HomeVC"];
        
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    }
    else
    {
        [self alertWithMessage:@"用户名或密码不正确,请注册!"];
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
