//
//  GoodsInfoCell.h
//  Purchase
//
//  Created by luoheng on 16/5/7.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CellDelegate <NSObject>

- (void)imageTapAction:(id)sender;
- (void)goodsCountAdd:(id)sender;
- (void)goodsCountCut:(id)sender;
- (void)addCartToPurchase:(id)sender;

@end

@interface GoodsInfoCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView        *goodsImageView;
@property (nonatomic, strong) TTTAttributedLabel *goodsDesLabel;
@property (nonatomic, strong) TTTAttributedLabel *sellLabel;
@property (nonatomic, strong) TTTAttributedLabel *storeLabel;
@property (nonatomic, strong) TTTAttributedLabel *waitToBuyLabel;
@property (nonatomic, strong) TTTAttributedLabel *puchaseLabel;

@property (nonatomic, strong) UIImageView        *countView;
@property (nonatomic, strong) UIButton           *numAddBtn;
@property (nonatomic, strong) UIButton           *numCutBtn;
@property (nonatomic, strong) UITextField        *numText;
@property (nonatomic, strong) UIButton           *cartButton;

@property (nonatomic, weak) id <CellDelegate> theDelegate;


- (void)setCellContentWithGoodsDic:(NSDictionary *)infoDic;

@end
