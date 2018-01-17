//
//  WriteViewController.m
//  兔子的5s
//
//  Created by 张晓东 on 15/8/25.
//  Copyright (c) 2015年 张晓东. All rights reserved.
//

#import "WriteViewController.h"
#import "AppDelegate.h"
@interface WriteViewController ()

@end

@implementation WriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.navigationItem.title= delegate.selecedCBCharacteristic.UUID.description;
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)endEdit:(id)sender {
    [sender resignFirstResponder];
}
- (IBAction)write:(id)sender {
    NSString *str=self.myUITextField.text;
    NSData* adata = [str dataUsingEncoding:NSUTF8StringEncoding];
        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [delegate.discoveredPeripheral writeValue:  adata forCharacteristic:delegate.selecedCBCharacteristic
                                         type:CBCharacteristicWriteWithResponse];
    [self.myUITextField setText:@""];
    
}
@end
