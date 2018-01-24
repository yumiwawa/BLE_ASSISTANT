
//
//  RootViewController.h
//  兔子的5s
//
//  Created by 张晓东 on 14-10-10.
//  Copyright (c) 2014年 张晓东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "MyUtils.h"
#import "AppDelegate.h"
#import "FeThreeDotGlow.h"
@interface RootViewController : UIViewController

 
@property (strong, nonatomic) CBCentralManager      *centralManager;
 @property (strong, nonatomic) NSMutableData         *data;
@property (strong, nonatomic) NSArray         *cb;
@property (strong, nonatomic) CBPeripheral *cbperipheral;
@property (strong,nonatomic) NSMutableArray * listData;
@property (strong,nonatomic) NSMutableArray * cbperipheralList;

@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end
