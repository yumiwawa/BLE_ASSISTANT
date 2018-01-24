//
//  SecondViewController.m
//  兔子的5s
//
//  Created by 张晓东 on 14-10-20.
//  Copyright (c) 2014年 张晓东. All rights reserved.
//

#import "SecondViewController.h"
#import "ThridViewController.h"
#import "RootViewController.h"
@interface SecondViewController ()<UITableViewDataSource,UITableViewDelegate,CBPeripheralDelegate>
@property (strong, nonatomic) CBService      *cbc;
@property (strong, nonatomic) AppDelegate *delegate ;
@end

@implementation SecondViewController

@synthesize cbserviceList=_cbserviceList;
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
-(void)goThrid:(id)sender
{
    ThridViewController *thridView = [[ThridViewController alloc] init];
    [self.navigationController pushViewController:thridView animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
  //  self.navigationItem.backBarButtonItem.title = @"fan";

  // self.navigationItem.leftBarButtonItem.title=self.type;
    self.navigationItem.title= @"service" ;

    
 
    _delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    _cbserviceList=[NSMutableArray arrayWithObjects:
                    nil];
    _delegate.connectedCBPeripheral.delegate = self;
    NSLog(@"Error discovering services: %@", _delegate.connectedCBPeripheral.description );
    [_delegate.connectedCBPeripheral discoverServices:nil];
  
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
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering services: %@", [error localizedDescription]);
        //[self cleanup];
        return;
    }
    //[_listData removeAllObjects];
    // Discover the characteristic we want...
    
    //    [_listData addObjectsFromArray:peripheral.services];
    //    [self.tableview reloadData];
    
    // Loop through the newly filled peripheral.services array, just in case there's more than one.
    for (CBService *service in _delegate.connectedCBPeripheral.services) {
        
        //[self.label2 setText:(NSString *)service.UUID];
        NSLog(@"Discovered service %@", service.UUID.description);
        [_cbserviceList addObject:service];
        [self.mySecondTableView reloadData];
    }
}


//下面都是实现UITableViewDelegate,UITableViewDataSource两个协议中定义的方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //返回行数
    return [_cbserviceList count];
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
        
    }
    //   cell.textLabel.text=[_cbserviceList objectAtIndex:row];//设置文字
    _cbc=[_cbserviceList objectAtIndex:row];
    cell.textLabel.text=_cbc.UUID.description;//设置文字
    cell.detailTextLabel.text=_cbc.UUID.UUIDString; //
    
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
  
    _cbc=[_cbserviceList objectAtIndex:row];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    delegate.selectedCBService=_cbc;

   
    ThridViewController *nv = [[ThridViewController alloc]init];
    nv.type=_cbc.UUID.UUIDString;
     
    [self.navigationController pushViewController:nv animated:NO];
   // [_delegate.discoveredPeripheral discoverCharacteristics:nil forService:_delegate.selectedCBService ];
           
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //返回每行的高度
    //CGFloat就是float
    return 70.0;
}



@end
