//
//  UIFont+Addition.m
//  carShow
//
//  Created by Cars on 15/12/17.
//  Copyright © 2015年 张继忠. All rights reserved.
//

#import "UIFont+Addition.h"

@implementation UIFont (Addition)

+ (UIFont *)customFontOfSize:(CGFloat)fontSize
{
    UIFont *font;
    if ([UIScreen mainScreen].scale == 2) {
        font = [UIFont systemFontOfSize:fontSize*SizeScaleWidth];
    }else if ([UIScreen mainScreen].scale == 3){
        font = [UIFont systemFontOfSize:fontSize*SizeScaleWidth];
    }
    return font;
}
+ (UIFont *)boldCustomFontOfSize:(CGFloat)fontSize
{
    UIFont *font;
    if ([UIScreen mainScreen].scale == 2) {
        font = [UIFont boldSystemFontOfSize:fontSize*SizeScaleWidth];
    }else if ([UIScreen mainScreen].scale == 3){
        font = [UIFont boldSystemFontOfSize:fontSize*SizeScaleWidth];
    }
    return font;
}
+ (UIFont *)customFontWithName:(NSString *)fontName size:(CGFloat)fontSize
{
    UIFont *font;
    if ([UIScreen mainScreen].scale == 2) {
        font = [UIFont fontWithName:fontName size:fontSize*SizeScaleWidth];
    }else if ([UIScreen mainScreen].scale == 3){
        font = [UIFont fontWithName:fontName size:fontSize*SizeScaleWidth];
    }
    return font;
}

@end
