//
//  ZKSigninVC.m
//  FeedSystem
//
//  Created by Mac on 2017/5/12.
//  Copyright © 2017年 bigtutu. All rights reserved.
//
//注册控制器

#import "ZKSigninVC.h"
#import "User+CoreDataProperties.h"//数据模型
#import "ZKCoreDataManager.h"//数据库管理者

@interface ZKSigninVC ()

@property (weak, nonatomic) IBOutlet UITextField *nameTF;//姓名
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;//密码
@property (weak, nonatomic) IBOutlet UITextField *passwordTF2;//确认

@end

@implementation ZKSigninVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//注册
- (IBAction)didCLickSignin:(UIButton *)sender {
    
    if ([self.passwordTF.text isEqualToString:self.passwordTF2.text])
    {
        //保存新数据
        User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:kZKCoreDataManager.persistentContainer.viewContext];
        
        user.user_id = self.nameTF.text;
        user.password = self.passwordTF.text;
        
        [kZKCoreDataManager save];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self alertWithMessage:@"两次密码输入不同"];
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

//自定义返回按钮
- (IBAction)back:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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
