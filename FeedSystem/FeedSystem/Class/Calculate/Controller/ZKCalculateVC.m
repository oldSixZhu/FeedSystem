//
//  ZKCalculateVC.m
//  FeedSystem
//
//  Created by Mac on 2017/5/12.
//  Copyright © 2017年 bigtutu. All rights reserved.
//

#import "ZKCalculateVC.h"
#import "ZKResultVC.h"
#import "ZKFodderConfigVC.h"

@interface ZKCalculateVC ()
@property (weak, nonatomic) IBOutlet UITextField *fishTF;//鱼
@property (weak, nonatomic) IBOutlet UITextField *beginningWeightTF;//初始体重
@property (weak, nonatomic) IBOutlet UITextField *lowestTempTF;//最低温度
@property (weak, nonatomic) IBOutlet UITextField *averageTempTF;//平均温度
@property (weak, nonatomic) IBOutlet UITextField *weeksTF;//预测周数
@property (weak, nonatomic) IBOutlet UITextView *TGCTextView;//TGC


@end

@implementation ZKCalculateVC

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)didClickBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//刷新TGC
- (IBAction)updateTGC:(UIButton *)sender {
    //取出最低温度与TGC
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *tgc = [ user objectForKey:@"tgc"];
    NSString *lowestTemp = [ user objectForKey:@"lowestTemp"];
    self.lowestTempTF.text = lowestTemp;
    self.TGCTextView.text = tgc;
}

- (IBAction)didClickCalculate:(UIButton *)sender {
    
    //配置TGC
    CGFloat TGC = 0.0;
    CGFloat currentWeight = [self.beginningWeightTF.text floatValue] ;
    //如果使用默认TGC
    if ([self.TGCTextView.text containsString:@"默认"])
    {
        //根据鱼体重划分
        if ((currentWeight> 0) && (currentWeight < 30))
        {
            TGC = 0.0836658;
        }
        else if ((currentWeight> 30) && (currentWeight < 261))
        {
            TGC = 0.0001485;
        }
        else if ((currentWeight> 261) && (currentWeight < 750))
        {
            TGC = 1.3819988;
        }
        else if ((currentWeight> 750) && (currentWeight < 99999))
        {
            TGC = 61.8829683;
        }
    }
    else
    {
        TGC = [self.TGCTextView.text floatValue];
    }
    
    NSString *TGCStr = [NSString stringWithFormat:@"%f",TGC];
    
    //检查一下
    if (![self checkAllTF])
    {
        [self alertWithMessage:@"请全部输入再进行计算!"];
        return;
    }
    
    if ([self.title isEqualToString:@"体重预测"])
    {
        //计算出结果
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ZKMain" bundle:nil];
        ZKResultVC *vc  = [storyboard instantiateViewControllerWithIdentifier:@"ZKResultVC"];
        //传值
//        vc.currentWeight = [self.beginningWeightTF.text floatValue];
//        vc.TGC = TGC;
//        vc.averageTemp = [self.averageTempTF.text floatValue];
//        vc.days = [self.weeksTF.text floatValue] * 7;
        
        NSDictionary *dataDic = @{@"beginningWeight":self.beginningWeightTF.text,
                                  @"lowestTemp":self.lowestTempTF.text,
                                  @"averageTemp":self.averageTempTF.text,
                                  @"weeks":self.weeksTF.text,
                                  @"TGC":TGCStr,
                                  };
        vc.dataDic = dataDic;
        vc.title = @"体重预测结果";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([self.title isEqualToString:@"饲料预测"])
    {
        //传数据
        NSDictionary *dataDic = @{@"beginningWeight":self.beginningWeightTF.text,
                         @"lowestTemp":self.lowestTempTF.text,
                         @"averageTemp":self.averageTempTF.text,
                         @"weeks":self.weeksTF.text,
                         @"TGC":TGCStr,
                         };
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ZKMain" bundle:nil];
        ZKFodderConfigVC *vc  = [storyboard instantiateViewControllerWithIdentifier:@"ZKFodderConfigVC"];
        vc.dataDic = dataDic;
        vc.title = @"饲料预测";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([self.title isEqualToString:@"N预测"])
    {
        //传数据
        NSDictionary *dataDic = @{@"beginningWeight":self.beginningWeightTF.text,
                                  @"lowestTemp":self.lowestTempTF.text,
                                  @"averageTemp":self.averageTempTF.text,
                                  @"weeks":self.weeksTF.text,
                                  @"TGC":TGCStr,
                                  };
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ZKMain" bundle:nil];
        ZKFodderConfigVC *vc  = [storyboard instantiateViewControllerWithIdentifier:@"ZKFodderConfigVC"];
        vc.dataDic = dataDic;
        vc.title = @"N预测";
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if ([self.title isEqualToString:@"P预测"])
    {
        //传数据
        NSDictionary *dataDic = @{@"beginningWeight":self.beginningWeightTF.text,
                                  @"lowestTemp":self.lowestTempTF.text,
                                  @"averageTemp":self.averageTempTF.text,
                                  @"weeks":self.weeksTF.text,
                                  @"TGC":TGCStr,
                                  };
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ZKMain" bundle:nil];
        ZKFodderConfigVC *vc  = [storyboard instantiateViewControllerWithIdentifier:@"ZKFodderConfigVC"];
        vc.dataDic = dataDic;
        vc.title = @"P预测";
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (BOOL)checkAllTF
{
    if ([self.fishTF.text isEqualToString:@""]
        ||[self.beginningWeightTF.text isEqualToString:@""]
        ||[self.lowestTempTF.text isEqualToString:@""]
        ||[self.averageTempTF.text isEqualToString:@""]
        ||[self.weeksTF.text isEqualToString:@""]
        ||[self.TGCTextView.text isEqualToString:@""])
    {
        return NO;
    }
    else
    {
        return YES;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
