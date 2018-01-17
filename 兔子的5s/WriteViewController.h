//
//  WriteViewController.h
//  兔子的5s
//
//  Created by 张晓东 on 15/8/25.
//  Copyright (c) 2015年 张晓东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WriteViewController : UIViewController
- (IBAction)endEdit:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *myUITextField;
@property (strong, nonatomic) IBOutlet UIButton *writeButton;

- (IBAction)write:(id)sender;

@end
