//
//  RootViewController.m
//  兔子的5s
//
//  Created by 张晓东 on 14-10-10.
//  Copyright (c) 2014年 张晓东. All rights reserved.
//

#import "RootViewController.h"

#import "SecondViewController.h"
#import "ThridViewController.h"
@interface RootViewController () <CBCentralManagerDelegate, CBPeripheralDelegate,UITableViewDataSource,UITableViewDelegate>
@end

@implementation RootViewController


@synthesize cbperipheralList=_cbperipheralList;



-(id)initWithNibName:(NSString *)nibNameOrNil
              bundle:(NSBundle *)nibBundleOrNil
{
    if ([super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] != nil)
    {
        // 为该控制器设置标签项
        self.tabBarItem = [[UITabBarItem alloc]
                           initWithTitle:@"BLE助手"
                           image:[UIImage imageNamed:@"ble.png"] tag:2];
        //      UITabBarItem* item = [[UITabBarItem alloc]
        //                              initWithTabBarSystemItem:UITabBarSystemItemTopRated tag:1];
        ////        // 为标签项设置徽标
       // self.tabBarItem.badgeValue = @"牛";
        //          item.title = @"蓝牙助手";
        // 为该控制器设置标签项
        //   self.tabBarItem = item;
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //自定义title
    UIButton *button = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    [button setTitle: @"BLE调试助手" forState: UIControlStateNormal];
    [button sizeToFit];
    //标题view
    self.navigationItem.titleView = button;
    //返回view
    //  self.navigationItem.title = @"CBPeripheral";
    
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    delegate.centralManager=_centralManager;
    
    _listData=[[NSMutableArray alloc]initWithObjects: nil];
    _cbperipheralList=[NSMutableArray arrayWithObjects:nil];
    [self.myTableView reloadData];
    
}
- (void)viewWillAppea:(BOOL)animated
{
    [self scan];
}
- (void)viewWillDisappear:(BOOL)animated
{
    // Don't keep it going while we're not showing.
    [self.centralManager stopScan];
    NSLog(@"Scanning stopped");
    [super viewWillDisappear:animated];
}

#pragma mark - Central Methods

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state != CBCentralManagerStatePoweredOn) {
        // In a real app, you'd deal with all the states correctly
        return;
    }else
    {
//        [_cbperipheralList removeAllObjects];
//        [self.myTableView reloadData];
    }
    
    // The state must be CBCentralManagerStatePoweredOn...
    // ... so start scanning
    [self scan];
    
}


/** Scan for peripherals - specifically for our service's 128bit CBUUID
 */
- (void)scan
{
    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    NSLog(@"Scanning started");
}
/** This callback comes whenever a peripheral that is advertising the TRANSFER_SERVICE_UUID is discovered.
 *  We check the RSSI, to make sure it's close enough that we're interested in it, and if it is,
 *  we start the connection process
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    // Reject any where the value is above reasonable range
    //    if (RSSI.integerValue > -15) {
    //        return;
    //    }
    //
    //    // Reject if the signal strength is too low to be close enough (Close is around -22dB)
    //    if (RSSI.integerValue < -35) {
    //        return;
    //    }
    
    NSLog(@"Discovered %@ at %@", peripheral.name, RSSI);
   
    // Ok, it's in range - have we already seen it?
    if ( ![_cbperipheralList containsObject:peripheral]) {
        //        NSString* p1 = peripheral.name;
        //        [_listData addObject:p1];
        //        [self.tableview reloadData];
        
        // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
        
        
        // And connect
        NSLog(@"Connecting to peripheral %@", peripheral);
        NSString *peripheralNmme=peripheral.name;
        NSLog(@"peripheralNmme %@", peripheralNmme);
        if([self isBlankString:peripheralNmme])
        {
            peripheralNmme=@"unNamed device";
        }
        [_listData addObject:peripheralNmme];
        [_cbperipheralList addObject:peripheral];
        [self.myTableView reloadData];
        //  [self.centralManager connectPeripheral:peripheral options:nil];
    }
}


/** If the connection fails for whatever reason, we need to deal with it.
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Failed to connect to %@. (%@)", peripheral, [error localizedDescription]);
    // [self cleanup];
}


/** We've connected to the peripheral, now we need to discover the services and characteristics to find the 'transfer' characteristic.
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Peripheral Connected");
    // Stop scanning
    [self.centralManager stopScan];
    NSLog(@"Scanning stopped");
    
    // Clear the data that we may already have
    //  [self.data setLength:0];
    
    // Make sure we get the discovery callbacks
    peripheral.delegate = self;
    
    // Search only for services that match our UUID
    //    [peripheral discoverServices:@[[CBUUID UUIDWithString:@"D0611E78-BBB4-4591-A5F8-487910AE4366"]]];
    //[peripheral discoverServices:nil];
    SecondViewController *nv = [[SecondViewController alloc]init];
 //  nv.type=_cbperipheral.name;
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = _cbperipheral.name;
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
   // [temporaryBarButtonItem release];
 // self.navigationItem.backBarButtonItem.title = _cbperipheral.name;
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    delegate.discoveredPeripheral=_cbperipheral;
    [self.navigationController pushViewController:nv animated:NO];
    
}




//下面都是实现UITableViewDelegate,UITableViewDataSource两个协议中定义的方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //返回行数
    return [_cbperipheralList count];
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
    
    
    _cbperipheral=[_cbperipheralList objectAtIndex:row];
    NSMutableString *str=[[NSMutableString alloc]initWithString:@"UUID:"];
    if(_cbperipheral!=nil)
    {
        
        [str  appendString:_cbperipheral.identifier.UUIDString];
    }
    
    NSLog(@"%@",str);
    cell.textLabel.text=_cbperipheral.name;//设置文字
    //cell.textLabel.text=[_listData objectAtIndex:row];//设置文字
    cell.detailTextLabel.text=str; //
    //   NSLog(@"rabbit%@",cbperipheral.name);
    
    UIImage *image=[UIImage imageNamed:@"qq"];//读取图片,无需扩展名
    cell.imageView.image=image;//文字左边的图片
    
    
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
    _cbperipheral=[_cbperipheralList objectAtIndex:row];
    
    [self.centralManager connectPeripheral:_cbperipheral options:nil];
    // NSString *rowString = [_listData objectAtIndex:[indexPath row]];
    //    UIAlertView * alter = [[UIAlertView alloc] initWithTitle:@"选中的行信息" message:rowString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //    [alter show];
    //    NSLog(@"count %lu", (unsigned long)_cb.count);
    // NSLog(@"count %ld", (long)[indexPath row]);
    //
    //  CBService *cbc=[_cb objectAtIndex:[indexPath row]];
    //   [_discoveredPeripheral discoverCharacteristics:@[[CBUUID UUIDWithString:@"2A29"
    //                                                     ]] forService:cbc];
    //    NSLog(@"count %@", cbc);
    //   [_discoveredPeripheral discoverCharacteristics:nil
    
    //                                       forService:cbc];
    
    //   [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:@"2A29"]] forService:service];
    //    UIAlertView * alter = [[UIAlertView alloc] initWithTitle:@"选中的行信息" message:@"hello world" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //    [alter show];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //返回每行的高度
    //CGFloat就是float
    return 70.0;
}
-(BOOL) isBlankString:(NSString *)string {
    
       if (string == nil || string == NULL) {
    
               return YES;
    
            }
    
       if ([string isKindOfClass:[NSNull class]]) {
        
               return YES;
        
           }
    
        if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        
                return YES;
        
             }
         return NO;
    }
@end
