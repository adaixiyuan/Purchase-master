//
//  PurchaseChildCell.h
//  Purchase
//
//  Created by luoheng on 16/6/11.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurchaseInfoModel.h"

@protocol CellDelegate <NSObject>

- (void)updateCellSelectStatus:(id)sender;
- (void)imageTapAction:(id)sender;

@end

@interface PurchaseChildCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, strong) UIButton           *selectBtn;
@property (nonatomic, strong) UIImageView        *goodsImageView;
@property (nonatomic, strong) TTTAttributedLabel *infoLabel;
@property (nonatomic, strong) TTTAttributedLabel *numLabel;
@property (nonatomic, strong) TTTAttributedLabel *priceLabel;
@property (nonatomic, strong) TTTAttributedLabel *goods_noLabel;

@property (nonatomic, strong) UIImageView        *countView;
@property (nonatomic, strong) UIButton           *numAddBtn;
@property (nonatomic, strong) UIButton           *numCutBtn;
@property (nonatomic, strong) UITextField        *numText;

@property (nonatomic, assign) NSInteger          numLimit;
@property (nonatomic, strong) id <CellDelegate>  theDelegate;

- (void)setCellContentWithPurchaseInfo:(NSDictionary *)purchaseDic;

@end
