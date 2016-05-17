//
//  StoreMacro.h
//  Purchase
//
//  Created by luoheng on 16/5/2.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#ifndef StoreMacro_h
#define StoreMacro_h


#endif /* StoreMacro_h */



#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define SizeScaleWidth  ((ScreenHeight>480)?ScreenWidth/320:1.0)
#define SizeScaleHeight ((ScreenHeight>480)?ScreenHeight/568:1.0)
#define HalfScale (1.0f/[UIScreen mainScreen].scale)


// 用于导航栏
#define NAVBARCOLOR     [UIColor colorFromHexRGB:@"FF6699"]
// 用于主标题，TAB，列表栏目入口，车系名称，用户名
#define BLACKCOLOR      [UIColor colorFromHexRGB:@"1a1a1a"]
// 用于列表内容，重要分类信息，筛选项，搜索分类名称，底部栏
#define SHALLOWBLACK    [UIColor colorFromHexRGB:@"3d3d3d"]
// 用于信息提示，小标题，分类栏名称，搜索推荐
#define GRAYCOLOR       [UIColor colorFromHexRGB:@"8b8b8b"]
// 用于标题描述，使用提示，不可用提示，底部信息
#define SHALLOWGRAY     [UIColor colorFromHexRGB:@"a3a3a3"]
// 用于文字链接
#define BLUECOLOR       [UIColor colorFromHexRGB:@"1a7df7"]

// 红色
#define REDCOLOR     [UIColor colorFromHexRGB:@"DC181C"]
// 绿色
#define GREENCOLOR       [UIColor colorFromHexRGB:@"0DB35F"]
// 橙色
#define ORANGECOLOR       [UIColor colorFromHexRGB:@"FF5F07"]

#define separateLineColor [UIColor colorFromHexRGB:@"e5e5e5"]
#define viewBgColor       [UIColor colorFromHexRGB:@"f7f7f7"]

#define SAFE_STRING(str) (![str isKindOfClass: [NSString class]] ? @"" : str)
#define SAFE_NUMBER(value) (![value isKindOfClass: [NSNumber class]] ? @(-1) : value)

#import "RequestMacro.h"

#import "UIColor+Addition.h"
#import "NSDate+Additions.h"
#import "NSString+Addition.h"
#import "UIFont+Addition.h"
#import "AutoTableView.h"
#import "AutoScrollView.h"
#import "NetworkManager.h"
#import "NavigationController.h"
#import "BaseViewController.h"
#import "HomeBaseViewController.h"
#import "UserInfoModel.h"
#import "MyStore.h"

#import "RESideMenu.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "TTTAttributedLabel.h"
#import "AFNetworking.h"
#import "MYMBProgressHUD.h"
#import "MBProgressHUD.h"
#import "NetworkManager.h"
#import "UIAlertView+Blocks.h"
#import "UIActionSheet+Blocks.h"
#import "UITextView+Placeholder.h"









