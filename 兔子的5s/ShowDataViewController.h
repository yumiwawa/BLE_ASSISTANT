//
//  ShowDataViewController.h
//  兔子的5s
//
//  Created by 张晓东 on 15/1/21.
//  Copyright (c) 2015年 张晓东. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
@interface ShowDataViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *showdata;
@property (strong, nonatomic) IBOutlet UISwitch *myUiSwitch;
- (IBAction)change:(id)sender;
@property(nonatomic,retain)NSString *type;
@end
