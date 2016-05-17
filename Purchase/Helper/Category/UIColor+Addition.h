//
//  UIColor+Addition.h
//  fresh
//
//  Created by HeT on 15/11/14.
//  Copyright © 2015年 100fresh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Addition)

+ (UIColor *) colorFromHexRGB:(NSString *) inColorString;
+ (UIColor *) colorFromHexRGB:(NSString *) inColorString alpha:(CGFloat)colorAlpha;

@end
