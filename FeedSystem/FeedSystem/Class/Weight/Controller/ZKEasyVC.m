//
//  ZKEasyVC.m
//  FeedSystem
//
//  Created by Mac on 2017/5/12.
//  Copyright © 2017年 bigtutu. All rights reserved.
//

#import "ZKEasyVC.h"
#import "ZKCalculateVC.h"

@interface ZKEasyVC ()

@property (weak, nonatomic) IBOutlet UITextField *fishTF;//鱼
@property (weak, nonatomic) IBOutlet UITextField *beginningWeightTF;//初始体重
@property (weak, nonatomic) IBOutlet UITextField *currentWeightTF;//当前体重
@property (weak, nonatomic) IBOutlet UITextField *averageTempTF;//平均温度
@property (weak, nonatomic) IBOutlet UITextField *weeksTF;//周数


@end

@implementation ZKEasyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didClickBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didClickHard:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)calcute:(UIButton *)sender {
    
    //改成算出TGC并跳转到calculateVC
    
    //简单计算公式
    // (G3)^(1÷3)−(G2)^(1÷3) = tcg*(L2*L3)/100
    // (G3)^(1÷3) = (G2)^(1÷3) + tcg*(L2*L3)/100
    // G3 = powf(((G2)^(1÷3) + tcg*(L2*L3)/100), 3.0);
    
    CGFloat currentWeight = [self.currentWeightTF.text floatValue];
    CGFloat beginningWeight = [self.beginningWeightTF.text floatValue];
    CGFloat days = [self.weeksTF.text floatValue] * 7;
    CGFloat averageTemp = [self.averageTempTF.text floatValue];
    
    //算TGC
    CGFloat TGC = 100*(powf(currentWeight, 1.0/3.0)-powf(beginningWeight, 1.0/3.0))/(days * averageTemp);
    
    //写入
    NSString *tgc = [NSString stringWithFormat:@"%f",TGC];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:tgc forKey:@"tgc"];
    
    //返回原始界面
//    [self.navigationController popToRootViewControllerAnimated:YES];
    //返回指定界面
    NSArray *temArray = self.navigationController.viewControllers;
    for(UIViewController *temVC in temArray)
    {
        if ([temVC isKindOfClass:[ZKCalculateVC class]])
        {
            [self.navigationController popToViewController:temVC animated:YES];
        }
    }
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
