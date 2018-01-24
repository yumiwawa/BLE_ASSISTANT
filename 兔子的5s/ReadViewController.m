//
//  ReadViewController.m
//  兔子的5s
//
//  Created by 张晓东 on 15/8/24.
//  Copyright (c) 2015年 张晓东. All rights reserved.
//

#import "ReadViewController.h"


@interface ReadViewController ()< CBPeripheralDelegate>


@end

@implementation ReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    delegate.connectedCBPeripheral.delegate = self;
    [delegate.connectedCBPeripheral readValueForCharacteristic:delegate.selecedCBCharacteristic  ];
    
    self.navigationItem.title= delegate.selecedCBCharacteristic.UUID.description;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)peripheral:(CBPeripheral *)peripheral
didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    
    NSData *data=characteristic.value;
    Byte *bytes = (Byte *)[data bytes];
   
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"0x";
    for(int i=0;i<[data length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    // self.receiveData=[NSString stringWithFormat:@"%@%@",self.receiveData,hexStr];
  //  [self.showdata setText:hexStr];

    
    [self.showValue setText:hexStr];
    // parse the data as needed
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
