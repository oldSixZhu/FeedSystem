//
//  ZKHomeVC.m
//  FeedSystem
//
//  Created by Mac on 2017/5/12.
//  Copyright © 2017年 bigtutu. All rights reserved.
//

#import "ZKHomeVC.h"

@interface ZKHomeVC ()

@end

@implementation ZKHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)didClickDismiss:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    UIViewController *secondVC = (UIViewController *)segue.destinationViewController;//要跳转的vc
    
    if ([segue.identifier isEqualToString:@"weight"])
    {
        secondVC.title = @"体重预测";
    }
    else if ([segue.identifier isEqualToString:@"fodder"])
    {
        secondVC.title = @"饲料预测";
    }
    else if ([segue.identifier isEqualToString:@"N"])
    {
        secondVC.title = @"N预测";
    }
    else if ([segue.identifier isEqualToString:@"P"])
    {
        secondVC.title = @"P预测";
    }
    
}


@end
