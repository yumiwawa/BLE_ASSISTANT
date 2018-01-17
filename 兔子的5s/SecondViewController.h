//
//  SecondViewController.h
//  兔子的5s
//
//  Created by 张晓东 on 14-10-20.
//  Copyright (c) 2014年 张晓东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController

@property (strong,nonatomic) NSMutableArray * cbserviceList;
@property (strong, nonatomic) IBOutlet UITableView *mySecondTableView;
@property(nonatomic,retain)NSString *type;

@end
