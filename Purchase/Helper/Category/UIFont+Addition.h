//
//  UIFont+Addition.h
//  carShow
//
//  Created by Cars on 15/12/17.
//  Copyright © 2015年 张继忠. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Addition)

+ (UIFont *)customFontOfSize:(CGFloat)fontSize;

+ (UIFont *)boldCustomFontOfSize:(CGFloat)fontSize;

+ (UIFont *)customFontWithName:(NSString *)fontName size:(CGFloat)fontSize;

@end
