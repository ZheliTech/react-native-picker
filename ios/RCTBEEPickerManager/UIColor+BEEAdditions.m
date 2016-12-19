//
//  UIColor+BEEAdditions.m
//  RCTBEEPickerManager
//
//  Created by wangjianfei on 2016/12/19.
//  Copyright © 2016年 MFHJ-DZ-001-417. All rights reserved.
//

#import "UIColor+BEEAdditions.h"

@implementation UIColor (BEEAdditions)

+ (UIColor *)bee_colorWith:(NSArray *)colorArry
{
    NSString *ColorA=[NSString stringWithFormat:@"%@",colorArry[0]];
    NSString *ColorB=[NSString stringWithFormat:@"%@",colorArry[1]];
    NSString *ColorC=[NSString stringWithFormat:@"%@",colorArry[2]];
    NSString *ColorD=[NSString stringWithFormat:@"%@",colorArry[3]];
    
    UIColor *color=[[UIColor alloc]initWithRed:[ColorA integerValue]/255.0 green:[ColorB integerValue]/255.0 blue:[ColorC integerValue]/255.0 alpha:[ColorD floatValue]];
    return color;
}

@end
