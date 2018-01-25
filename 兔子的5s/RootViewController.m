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
@property (strong, nonatomic) FeThreeDotGlow *threeDot;
@end

@implementation RootViewController


@synthesize cbperipheralList=_cbperipheralList;
UIAlertController    *alert ;
UIAlertAction * sureButton;
bool  connected=false;
int    count=0;
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
    if (central.state == CBManagerStatePoweredOn) {
        // In a real app, you'd deal with all the states correctly
        if(alert!=nil)
        {
              [alert dismissViewControllerAnimated:YES completion:nil];
        }
         [self scan];
        return;
    }else
    {
        if(sureButton==nil)
        {
            sureButton= [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if(alert!=nil)
                {
                    [alert dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        }
        if(alert==nil)
        {
             alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"蓝牙已经关闭,请打开蓝牙继续使用该app" preferredStyle:  UIAlertControllerStyleAlert];
          [alert addAction:sureButton];
        }
        [self presentViewController:alert animated:true completion:nil];
        
        [_cbperipheralList removeAllObjects];
        [self.myTableView reloadData];
    }
    
    // The state must be CBCentralManagerStatePoweredOn...
    // ... so start scanning
   
    
}


/** Scan for peripherals - specifically for our service's 128bit CBUUID
 */
- (void)scan
{
    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    NSLog(@"Scanning started");
}

-(void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%@",peripheral);
    int rssi = abs([peripheral.RSSI intValue]);
    CGFloat ci = (rssi - 49) / (10 * 4.);
    NSString *length = [NSString stringWithFormat:@"发现BLT4.0热点:%@,距离:%.1fm",peripheral,pow(10,ci)];
    NSLog(@"%@",length);
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
    // Ok, it's in range - have we already seen it?
     [peripheral discoverServices:nil];
    if ( ![_cbperipheralList containsObject:peripheral]) {
        //        NSString* p1 = peripheral.name;
        //        [_listData addObject:p1];
        //        [self.tableview reloadData];
        // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
        // And connect
        NSLog(@"Connecting to peripheral %@", peripheral);
        NSString *peripheralNmme=peripheral.name;
        NSLog(@"peripheralNmme %@", peripheralNmme);
        if([MyUtils isEmptyString:peripheralNmme])
        {
            peripheralNmme=@"unNamed";
             NSLog(@"Discovered %@ at %@", @"unNamed", RSSI);
        }else{
             NSLog(@"Discovered %@ at %@", peripheral.name, RSSI);
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
//    SecondViewController *nv = [[SecondViewController alloc]init];
// //  nv.type=_cbperipheral.name;
//    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
//    temporaryBarButtonItem.title = _cbperipheral.name;
//    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
//   // [temporaryBarButtonItem release];
// // self.navigationItem.backBarButtonItem.title = _cbperipheral.name;
  AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];    delegate.connectedCBPeripheral=peripheral;
//    [self.navigationController pushViewController:nv animated:NO];
    connected=true;
}


- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error
{
    
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
//    NSArray *services=_cbperipheral.services;
//    NSUInteger num=services.count ;
//    NSMutableString *str = [NSMutableString stringWithFormat:@"%lu",(unsigned long)num];
//    [str  appendString:@"services"];
    
    NSMutableString *str = [NSMutableString stringWithString:@"UUID:"];
    if(_cbperipheral!=nil)
    {
        [str  appendString:_cbperipheral.identifier.UUIDString];
    }
    NSLog(@"%@",str);
    if([MyUtils isEmptyString:_cbperipheral.name])
    {
     cell.textLabel.text=@"unNamed";//设置文字;
     cell.textLabel.textColor = [UIColor grayColor];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    }else
    {
    cell.textLabel.text=_cbperipheral.name;//设置文字
    }
    //cell.textLabel.text=[_listData objectAtIndex:row];//设置文字
    cell.detailTextLabel.text=str; //
    //   NSLog(@"rabbit%@",cbperipheral.name);
    
    UIImage *image=[UIImage imageNamed:@"ble.png"];//读取图片,无需扩展名
    cell.imageView.image=image;//文字左边的图片
    //设置箭头
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//    [cell.detailTextLabel setNumberOfLines:2];//可以显示3行
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
    //设备名字不为空才连接
    if(![MyUtils isEmptyString:_cbperipheral.name])
    {
        [self.centralManager connectPeripheral:_cbperipheral options:nil];
        NSLog(@"点击了选中");
        [self addAni];
    }
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
-(void )addAni
{
    
    if(_threeDot==nil)
    {
       _threeDot = [[FeThreeDotGlow alloc] initWithView:self.view blur:NO];
      _threeDot.fontTitleLabel = [UIFont systemFontOfSize:20];
    }
    NSMutableString *deviceName = [NSMutableString stringWithString:@"正在连接"];
    if(_cbperipheral!=nil)
    {
        [deviceName  appendString:_cbperipheral.name];
    }
    _threeDot.titleLabelText = deviceName;
  //  _threeDot = [[FeThreeDotGlow alloc] initWithView:self.view blur:NO];
    [self.view addSubview:_threeDot];
    // Start
    [_threeDot showWhileExecutingBlock:^{
        while (!connected&&count<4) {
           sleep(1);
            count++;
        }
    } completion:^{
        if(connected)
        {
            connected=false;
            [_threeDot removeFromSuperview];
            SecondViewController *nv = [[SecondViewController alloc]init];
            //  nv.type=_cbperipheral.name;
            UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
            temporaryBarButtonItem.title = _cbperipheral.name;
            self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
            [self.navigationController pushViewController:nv animated:NO];
        }else{
              [_threeDot removeFromSuperview];
        }
        count=0;
        }
       ];
}
@end
