//
//  ReadViewController.h
//  兔子的5s
//
//  Created by 张晓东 on 15/8/24.
//  Copyright (c) 2015年 张晓东. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

@interface ReadViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextView *showValue;

@property(nonatomic,retain)NSString *type;

@end
