//
//  RWNViewController.m
//  兔子的5s
//
//  Created by 张晓东 on 15/8/25.
//  Copyright (c) 2015年 张晓东. All rights reserved.
//

#import "RWNViewController.h"
#import "AppDelegate.h"
#import "ShowDataViewController.h"
#import "ReadViewController.h"
#import "WriteViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
@interface RWNViewController ()
@end

@implementation RWNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.navigationItem.title= delegate.selecedCBCharacteristic.UUID.description;
    CBCharacteristicProperties cbcProperties= delegate.selecedCBCharacteristic.properties;
    [self.mySegmentedControl removeAllSegments];

    NSMutableString * str ;
    switch (cbcProperties) {
        case 2:
            [str appendString:@"    Read"];//在字符串末尾追加字符串
            [self.mySegmentedControl insertSegmentWithTitle:@"Read" atIndex:0 animated:YES];
            break;
        case 4:
            [str appendString:@"    Write without response"];//在字符串末尾追加字符串
            
            [self.mySegmentedControl insertSegmentWithTitle:@" Write without response" atIndex:0 animated:YES];
            break;
        case 8:
            [str appendString:@"    Write"];//在字符串末尾追加字符串
            [self.mySegmentedControl insertSegmentWithTitle:@" Write " atIndex:0 animated:YES];
            
            break;
        case 10:
            [str appendString:@"    Read Write"];//在字符串末尾追加字符串
            [self.mySegmentedControl insertSegmentWithTitle:@" Read " atIndex:0 animated:YES];
            [self.mySegmentedControl insertSegmentWithTitle:@" Write " atIndex:1 animated:YES];
            
            
            break;
        case 16:
            [str appendString:@"     Notify"];//在字符串末尾追加字符串
            [self.mySegmentedControl insertSegmentWithTitle:@" Notify " atIndex:0 animated:YES];
            
            
            
            break;
            
        case 18:
            [str appendString:@"     Read Notify"];//在字符串末尾追加字符串
            
            [self.mySegmentedControl insertSegmentWithTitle:@" Read " atIndex:0 animated:YES];
            [self.mySegmentedControl insertSegmentWithTitle:@" Notify " atIndex:1 animated:YES];
            
            break;
        case 20:
            [str appendString:@"      Write"];//在字符串末尾追加字符串
            [self.mySegmentedControl insertSegmentWithTitle:@" Write" atIndex:0 animated:YES];
            
            break;
            
        case 22:
            [str appendString:@" Read Write without response Notify"];//在字符串末尾追加字符串
            
            [self.mySegmentedControl insertSegmentWithTitle:@" Read " atIndex:0 animated:YES];
            [self.mySegmentedControl insertSegmentWithTitle:@" Write " atIndex:1 animated:YES];
            [self.mySegmentedControl insertSegmentWithTitle:@" Notify " atIndex:2 animated:YES];
            
            
            break;
            
        default:
            break;
    }
    [self.mySegmentedControl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    // Do any additional setup after loading the view from its nib.
}
-(void)change:(UISegmentedControl *)segmentControl{
    
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.navigationItem.title= delegate.selecedCBCharacteristic.UUID.description;
    CBCharacteristicProperties cbcProperties= delegate.selecedCBCharacteristic.properties;
    ReadViewController *read=[[ReadViewController alloc]init];
    WriteViewController *write=[[WriteViewController alloc]init];
    ShowDataViewController *show=[[ShowDataViewController alloc]init];
    
    switch (cbcProperties) {
        case 2:
            [self.navigationController pushViewController:read animated:YES];
            
            break;
        case 4:
            
            [self.navigationController pushViewController:write animated:YES];
            break;
        case 8:
            
            [self.navigationController pushViewController:write animated:YES];
            break;
        case 10:
            if(self.mySegmentedControl.selectedSegmentIndex==0)
            {
                [self.navigationController pushViewController:read animated:YES];
            }else{
                [self.navigationController pushViewController:write animated:YES];
            }
            
            break;
        case 16:
            [self.navigationController pushViewController:show animated:YES];
            break;
            
        case 18:
            if(self.mySegmentedControl.selectedSegmentIndex==0)
            {
                [self.navigationController pushViewController:read animated:YES];
            }else{
                [self.navigationController pushViewController:show animated:YES];
            }            break;
        case 20:
            [self.navigationController pushViewController:write animated:YES];
            break;
            
        case 22:
            if(self.mySegmentedControl.selectedSegmentIndex==0)
            {
                [self.navigationController pushViewController:read animated:YES];
            }else if(self.mySegmentedControl.selectedSegmentIndex==1)
            {
                [self.navigationController pushViewController:write animated:YES];
            } else if(self.mySegmentedControl.selectedSegmentIndex==2)
            {
                [self.navigationController pushViewController:show animated:YES];
            }                  break;
            
        default:
            break;
    }
    
    NSLog(@"segmentControl %ld",(long)self.mySegmentedControl.selectedSegmentIndex);
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
