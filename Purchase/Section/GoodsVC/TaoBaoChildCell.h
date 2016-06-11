//
//  TaoBaoChildCell.h
//  Purchase
//
//  Created by luoheng on 16/5/26.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CellDelegate <NSObject>

- (void)imageTapAction:(id)sender;
- (void)addCartToPurchase:(id)sender;

@end

@interface TaoBaoChildCell : UITableViewCell

@property (nonatomic, strong) UIImageView        *goodsImageView;
@property (nonatomic, strong) TTTAttributedLabel *goodsDesLabel;
@property (nonatomic, strong) TTTAttributedLabel *priceLabel;
@property (nonatomic, strong) TTTAttributedLabel *goods_noLabel;
@property (nonatomic, strong) TTTAttributedLabel *sellLabel;
@property (nonatomic, strong) TTTAttributedLabel *storeLabel;
@property (nonatomic, strong) TTTAttributedLabel *waitToBuyLabel;
@property (nonatomic, strong) TTTAttributedLabel *puchaseLabel;
@property (nonatomic, strong) UIButton           *cartButton;

@property (nonatomic, weak) id <CellDelegate> theDelegate;


- (void)setCellContentWithGoodsDic:(NSDictionary *)infoDic;

@end
