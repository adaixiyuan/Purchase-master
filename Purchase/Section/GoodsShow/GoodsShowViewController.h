//
//  GoodsShowViewController.h
//  Purchase
//
//  Created by luoheng on 16/5/23.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import <MWPhotoBrowser/MWPhotoBrowser.h>

@interface GoodsShowViewController : MWPhotoBrowser

@property (nonatomic, copy) void (^selectGoodsIndex)(NSInteger index);

@end
