//
//  ThridViewController.m
//  兔子的5s
//
//  Created by 张晓东 on 14-10-22.
//  Copyright (c) 2014年 张晓东. All rights reserved.
//
#import <CoreBluetooth/CoreBluetooth.h>
#import "ThridViewController.h"
#import"SecondViewController.h"
#import "RootViewController.h"
#import"ShowDataViewController.h"
#import "ReadViewController.h"
#import "RWNViewController.h"
@interface ThridViewController ()<UITableViewDataSource,UITableViewDelegate,CBPeripheralDelegate>

@property (strong, nonatomic) CBCharacteristic      *cbcCharacteristic;
@property (strong, nonatomic) AppDelegate *delegate ;
@end

@implementation ThridViewController
@synthesize cbcharacteristicList=_cbcharacteristicList;
- (void)goFirst:(id)sender {
    RootViewController *secondView = [[RootViewController alloc] init];
    [self.navigationController pushViewController:secondView animated:YES];
    secondView.title = @"兔子蓝牙调试助手";
    
    //
    //        NSURL *url=[NSURL URLWithString:@"http://www.sinaimg.cn/qc/photo_auto/chezhan/2012/50/00/15/80046_950.jpg"];
    //        UIImage *myImage=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:url]];
    //
    //        [self.go setBackgroundImage:myImage forState:UIControlStateNormal];
    
}
- (void)goSecond:(id)sender {
    SecondViewController *secondView = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:secondView animated:YES];
    secondView.title = @"兔子蓝牙调试助手";
    
    //
    //        NSURL *url=[NSURL URLWithString:@"http://www.sinaimg.cn/qc/photo_auto/chezhan/2012/50/00/15/80046_950.jpg"];
    //        UIImage *myImage=[[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:url]];
    //
    //        [self.go setBackgroundImage:myImage forState:UIControlStateNormal];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
       self.navigationItem.title = @"characteristic";
    _cbcharacteristicList=[NSMutableArray arrayWithObjects:@"fhdsa",@"ds ffs",
                           nil];
    
    
    
    
    _delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    _cbcharacteristicList=[NSMutableArray arrayWithObjects:
                           nil];
    _delegate.connectedCBPeripheral.delegate = self;
    
    [_delegate.connectedCBPeripheral discoverCharacteristics:nil forService:_delegate.selectedCBService ];
    
    
    
    NSLog(@"discoveredPeripheral %@", _delegate.connectedCBPeripheral.description );
    NSLog(@"selectedCBService %@", _delegate.selectedCBService.description );
    
    
    NSMutableString * str =  [[NSMutableString alloc]initWithString:@"hello"];//将不可变的字符串转换为可变的字符串
    
    [str appendString:@"123"];//在字符串末尾追加字符串
    
    NSLog(@"oooo %@", str );
    
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


/** The Transfer characteristic was discovered.
 *  Once this has been found, we want to subscribe to it, which lets the peripheral know we want the data it contains
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    // Deal with errors (if any)
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        // [self cleanup];
        return;
    }
    
    // Again, we loop through the array, just in case.
    for (CBCharacteristic *characteristic in service.characteristics) {
        
        NSLog(@"discovered characteristics: %@", characteristic);
        
        [_cbcharacteristicList addObject:characteristic];
        
//        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE9"]]) {
//            //[self.label3 setText:(NSString *)characteristic.UUID];
//            _delegate.writeCBCharacteristic=characteristic;
//            
//            
//        }
//        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE1"]]) {
//            //[self.label3 setText:(NSString *)characteristic.UUID];
//            _delegate.selecedCBCharacteristic=characteristic;
//            
//        }
        


        //
        [self.myThridTableView reloadData];
        
        //     if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A29"]]) {
        //        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"8667556C-9A37-4C91-84ED-54EE27D90049"]]) {
        //            //[self.label3 setText:(NSString *)characteristic.UUID];
        //
        //            //
        //            //            NSLog(@"discovered characteristics: %@", characteristic);
        //            NSLog(@"Reading value for characteristic %@", characteristic);
        //            //[peripheral readValueForCharacteristic:characteristic];
        //            // If it is, subscribe to it
        //            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        //        }
    }
    
    // Once this is complete, we just need to wait for the data to come in.
}


//下面都是实现UITableViewDelegate,UITableViewDataSource两个协议中定义的方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //返回行数
    return [_cbcharacteristicList count];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation

{
    
    // Return YES for supported orientations
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{//返回一行的视图
    NSUInteger row=[indexPath row];
    NSString * tableIdentifier=@"Simple table";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    //当一行上滚在屏幕消失时，另一行从屏幕底部滚到屏幕上，如果新行可以直接使用已经滚出屏幕的那行，系统可以避免重新创建和释放视图，同一个TableView,所有的行都是可以复用的，tableIdentifier是用来区别是否属于同一TableView
    
    if(cell==nil)
    {
        //当没有可复用的空闲的cell资源时(第一次载入,没翻页)
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tableIdentifier];
        //UITableViewCellStyleDefault 只能显示一张图片，一个字符串，即本例样式
        //UITableViewCellStyleSubtitle 可以显示一张图片，两个字符串，上面黑色，下面的灰色
        //UITableViewCellStyleValue1 可以显示一张图片，两个字符串，左边的黑色，右边的灰色
        //UITableViewCellStyleValue2 可以显示两个字符串，左边的灰色，右边的黑色
        
    }
    _cbcCharacteristic=[_cbcharacteristicList objectAtIndex:row];
    NSMutableString * str =  [[NSMutableString alloc]initWithString:_cbcCharacteristic.UUID.UUIDString];
    //将不可变的字符串转换为可变的字符串
    CBCharacteristicProperties cbcProperties= _cbcCharacteristic.properties;
   
    switch (cbcProperties) {
        case 2:
            [str appendString:@"    Read"];//在字符串末尾追加字符串
            break;
        case 4:
            [str appendString:@"    Write without response"];//在字符串末尾追加字符串
            break;
        case 8:
            [str appendString:@"    Write"];//在字符串末尾追加字符串
            break;
        case 10:
            [str appendString:@"    Read Write"];//在字符串末尾追加字符串
            break;
        case 16:
            [str appendString:@"     Notify"];//在字符串末尾追加字符串
            break;

        case 18:
            [str appendString:@"     Read Notify"];//在字符串末尾追加字符串
            break;
        case 20:
            [str appendString:@"      Write"];//在字符串末尾追加字符串
            break;
       
        case 22:
            [str appendString:@"     Read Write without response Notify"];//在字符串末尾追加字符串
            break;

        default:
            break;
    }
    
    
    cell.textLabel.text=_cbcCharacteristic.UUID.description;//设置文字
    cell.detailTextLabel.text=str;
    
    
    
   
    
    //    _cbcCharacteristic=[_cbcharacteristicList objectAtIndex:row];
    //    cell.textLabel.text=[_cbcharacteristicList objectAtIndex:row];//设置文字
    //
    //    _cbperipheral=[_cbperipheralList objectAtIndex:row];
    //    cell.textLabel.text=_cbperipheral.name;//设置文字
    //    //cell.textLabel.text=[_listData objectAtIndex:row];//设置文字
    //    cell.detailTextLabel.text=_cbperipheral.identifier.UUIDString; //
    //   NSLog(@"rabbit%@",cbperipheral.name);
    
    //    UIImage *image=[UIImage imageNamed:@"qq"];//读取图片,无需扩展名
    //    cell.imageView.image=image;//文字左边的图片
    
    
    
    //适用于Subtitle，Value1，Value2样式
    //    cell.imageView.highlightedImage=image; 可以定义被选中后显示的图片
    return cell;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{//被选中前执行
    //    if ([indexPath row]==0) {
    //        //第一项不可选
    //        return nil;
    //    }
    return indexPath;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row=[indexPath row];
    _cbcCharacteristic=[_cbcharacteristicList  objectAtIndex:[indexPath row]];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    delegate.selecedCBCharacteristic=_cbcCharacteristic;

//    ShowDataViewController *nv = [[ShowDataViewController alloc]init];
//    nv.type=_cbcCharacteristic.UUID.UUIDString;
    RWNViewController *nv = [[RWNViewController alloc]init];
  
    [self.navigationController pushViewController:nv animated:NO];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //返回每行的高度
    //CGFloat就是float
    return 70.0;
}



@end
