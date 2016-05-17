//
//  GoodsShowCell.h
//  Purchase
//
//  Created by luoheng on 16/5/13.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsShowCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UIView      *bgView;
@property (nonatomic, strong) UILabel     *desLabel;
@property (nonatomic, strong) UILabel     *otherLabel;

- (void)setCellContentWithInfo:(NSDictionary *)infoDic withVCType:(NSInteger)vcType;

@end
