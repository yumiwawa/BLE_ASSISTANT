//
//  ThridViewController.h
//  兔子的5s
//
//  Created by 张晓东 on 14-10-22.
//  Copyright (c) 2014年 张晓东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThridViewController : UIViewController

@property (strong,nonatomic) NSMutableArray * cbcharacteristicList;
@property (strong, nonatomic) IBOutlet UITableView *myThridTableView;
@property(nonatomic,retain)NSString *type;
@end
