//
//  ShowDataViewController.m
//  兔子的5s
//
//  Created by 张晓东 on 15/1/21.
//  Copyright (c) 2015年 张晓东. All rights reserved.
//

#import "ShowDataViewController.h"

@interface ShowDataViewController ()<CBPeripheralDelegate>
@property (weak, nonatomic) AppDelegate *delegate ;
@property (strong, nonatomic) CBPeripheral          *discoveredPeripheral;
@property (strong, nonatomic) CBService      *selectedCBService;
@property (strong, nonatomic) CBCharacteristic        *selecedCBCharacteristic;
@property (strong, nonatomic) CBCharacteristic        *writeCBCharacteristic;
@property (strong, nonatomic) NSMutableData         *data;
@property (strong, nonatomic) NSString        *receiveData;
@property (strong, nonatomic) NSCalendar        *myCalendar;
@property (strong, nonatomic) NSDateComponents        *myComponents;
@property (strong, nonatomic) NSDate      *myDate;
@end

@implementation ShowDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _myCalendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
   
    //  NSData *write=[@"3a3431310d0a" dataUsingEncoding:NSUTF8StringEncoding];
    
    _data = [[NSMutableData alloc] init];
    // self.textview.delegate = self;//设置它的委托方法
    
    _delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    _discoveredPeripheral=_delegate.discoveredPeripheral;
    _delegate.discoveredPeripheral.delegate = self;
    self.navigationItem.title= _delegate.selecedCBCharacteristic.UUID.description;
    
    _selecedCBCharacteristic=_delegate.selecedCBCharacteristic;
    
    
    
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"viewWillDisappear");
    [ _discoveredPeripheral setNotifyValue:NO forCharacteristic:_selecedCBCharacteristic];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/** centralManagerDidUpdateState is a required protocol method.
 *  Usually, you'd check for other states to make sure the current device supports LE, is powered on, etc.
 *  In this instance, we're just using it to wait for CBCentralManagerStatePoweredOn, which indicates
 *  the Central is ready to be used.
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state != CBCentralManagerStatePoweredOn) {
        // In a real app, you'd deal with all the states correctly
        return;
    }
    
    // The state must be CBCentralManagerStatePoweredOn...
    
    // ... so start scanning
    // [self scan];
    
}






/** This callback lets us know more data has arrived via notification on the characteristic
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    NSLog(@"Received: %@", characteristic.value);
    NSString *stringFromData = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    
    // Have we got everything we need?
    if ([stringFromData isEqualToString:@"EOM"]) {
        
        
    }
    self.data=characteristic.value;
    //  [self.showdata setText:stringFromData];
    //  NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[self.data bytes];
    
    unsigned long unitFlags=NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    _myDate=[NSDate date];
     _myComponents = [_myCalendar components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitNanosecond fromDate:[NSDate date]];
       //时间
    NSString *hour= [NSString stringWithFormat: @"%ld", (long)_myComponents.hour ];
    NSString *min= [NSString stringWithFormat: @"%ld", (long)_myComponents.minute ];
    NSString *sec= [NSString stringWithFormat: @"%ld", (long)_myComponents.second ];
    NSString *msec=[NSString stringWithFormat: @"%ld", (long)_myComponents.nanosecond ];
    NSString *hello=@":";
   //不可以变字符串
//    NSString *dateNow = [hour stringByAppendingString:hello];
//    dateNow= [dateNow stringByAppendingString:min];
//    dateNow= [dateNow stringByAppendingString:hello];
//    dateNow= [dateNow stringByAppendingString:sec];
//    dateNow= [dateNow stringByAppendingString:hello];
//    dateNow= [dateNow stringByAppendingString:msec];
    //可以变字符串
//    NSMutableString *dateNow=[NSMutableString  stringWithString:hour];
//    [dateNow appendString:hello];
//     [dateNow appendString:min];
//     [dateNow appendString:hello];
//     [dateNow appendString:sec];
//     [dateNow appendString:hello];
//     [dateNow appendString:hello];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    //[dateFormatter setDateFormat:@"hh:mm:ss"]
    [dateFormatter setDateFormat:@"HH:mm:ss.SSS"];
    NSString *dateNow=[dateFormatter stringFromDate:[NSDate date]];
    dateNow= [dateNow stringByAppendingString:@"\r\n"];

    //下面是Byte 转换为16进制。
    NSString *hexStr=dateNow;
    for(int i=0;i<[self.data length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    // self.receiveData=[NSString stringWithFormat:@"%@%@",self.receiveData,hexStr];
    [self.showdata setText:hexStr];
    
    
    // Log it
    NSLog(@"Received: %@", stringFromData);
}


/** The peripheral letting us know whether our subscribe/unsubscribe happened or not
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
    }
    
    // Notification has started
    if (characteristic.isNotifying) {
        NSLog(@"Notification began on %@", characteristic);
    }
    
    // Notification has stopped
    else {
        // so disconnect from the peripheral
        NSLog(@"Notification stopped on %@.  Disconnecting", characteristic);
        // [self.centralManager cancelPeripheralConnection:peripheral];
    }
}






- (IBAction)change:(id)sender {
    if([sender isOn]==YES)
    {
        [ _discoveredPeripheral setNotifyValue:YES forCharacteristic:_selecedCBCharacteristic];

    }else{
        [ _discoveredPeripheral setNotifyValue:NO forCharacteristic:_selecedCBCharacteristic];

    }
}
@end
