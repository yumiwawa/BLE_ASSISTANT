//
//  MyUtils.m
//  兔子的5s
//
//  Created by 张晓东 on 2018/1/24.
//  Copyright © 2018年 张晓东. All rights reserved.
//

#import "MyUtils.h"

@implementation MyUtils
+(BOOL) isEmptyString:(NSString *)string {
    
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
