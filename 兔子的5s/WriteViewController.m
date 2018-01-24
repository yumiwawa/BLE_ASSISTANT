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
UIAlertAction        *disConnectSureButton;
UIAlertController  *disConnectAlert ;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.navigationItem.title= delegate.selecedCBCharacteristic.UUID.description;
    // Do any additional setup after loading the view from its nib.
     _myUITextField.delegate=self;
     [_myUITextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
      
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
    NSData* adata;
    if([str length]==0)
    {
        return;
    }
    else if([str length]==1)
    {
        NSString *stZero=@"0";
       stZero= [stZero stringByAppendingString:str];
         adata = [self hexString:stZero];
    }
    else if([str length]==2)
    {
        adata = [self hexString:str];
    }
    
//    int i = 1;
//    NSData *data = [NSData dataWithBytes: &i length: sizeof(i)];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    CBPeripheral          *peripheral=delegate.connectedCBPeripheral;
    
   CBCharacteristic        *selecedCBCharacteristic=delegate.selecedCBCharacteristic;
    
    if(peripheral.state==CBPeripheralStateConnected)
    {
        [peripheral writeValue:  adata forCharacteristic:selecedCBCharacteristic
                          type:CBCharacteristicWriteWithoutResponse];
        [self.myUITextField setText:@""];
        [self.writeButton setEnabled:false];
    }else{
        if(disConnectSureButton==nil)
        {
            disConnectSureButton= [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if(disConnectAlert!=nil)
                {
                    [disConnectAlert dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        }
        if(disConnectAlert==nil)
        {
            disConnectAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"与该BLE设备连接已经断开,请重新连接后再操作" preferredStyle:  UIAlertControllerStyleAlert];
            [disConnectAlert addAction:disConnectSureButton];
        }
        [self presentViewController:disConnectAlert animated:true completion:nil];
    }
}

-(NSData *)hexString:(NSString *)hexString {
    int j=0;
    Byte bytes[[hexString length]];
    ///3ds key的Byte 数组， 128位
    for(int i=0; i<[hexString length]; i++)
    {
        int int_ch;  /// 两位16进制数转化后的10进制数
        
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        NSLog(@"int_ch=%d",int_ch);
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        j++;
    }
    
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:[hexString length]];
    
    return newData;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"%@ %@",NSStringFromRange(range),string);
    NSLog(@"hello%@",string);
    Boolean isHex= [ValidateUtil isHexStringFormat:string];
     NSString *writeData=self.myUITextField.text;
    if([MyUtils isEmptyString:string] )
    {
        return YES;
        
    }else{
        if(isHex&&[writeData length]<=1)
        {
            return YES;
            
        }else
        {
            return NO;
        }
    }
}
- (void)textFieldChanged:(UITextField *)textField {
    [self isRightFormat];
}
- (void)isRightFormat
{
    NSString *writeData=self.myUITextField.text;
    if([writeData length]>2)
    {
        return ;
    }
    Boolean isHex= [ValidateUtil isHexStringFormat:writeData];
    NSLog(@"*****%@ ",writeData);
    if(isHex)
    {
            [self.writeButton setEnabled:true];
        
    }else
    {
        NSLog(@"不是十六jin'zhi");
        [self.writeButton setEnabled:false];
    }
}
@end
