//
//  AppDelegate.h
//  兔子的5s
//
//  Created by 张晓东 on 14-10-10.
//  Copyright (c) 2014年 张晓东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController* viewController;
@property (strong, nonatomic) UINavigationController *navController;
@property (weak, nonatomic) CBCentralManager      *centralManager;
@property (strong, nonatomic) CBPeripheral          *discoveredPeripheral;
@property (strong, nonatomic) CBService      *selectedCBService;
@property (strong, nonatomic) CBCharacteristic        *selecedCBCharacteristic;
@property (strong, nonatomic) CBCharacteristic        *writeCBCharacteristic;

@property (strong, nonatomic) UITabBarController *tabBarController;


@end

