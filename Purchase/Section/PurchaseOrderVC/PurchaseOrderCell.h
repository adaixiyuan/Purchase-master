//
//  PurchaseOrderCell.h
//  Purchase
//
//  Created by luoheng on 16/5/7.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurchaseInfoModel.h"

@protocol CellDelegate <NSObject>

- (void)updateCellSelectStatus:(id)sender;
- (void)imageTapAction:(id)sender;

@end

@interface PurchaseOrderCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, strong) UIButton           *selectBtn;
@property (nonatomic, strong) UIImageView        *goodsImageView;
@property (nonatomic, strong) TTTAttributedLabel *infoLabel;
@property (nonatomic, strong) TTTAttributedLabel *numLabel;
@property (nonatomic, strong) TTTAttributedLabel *goods_noLabel;

@property (nonatomic, strong) UIImageView        *countView;
@property (nonatomic, strong) UIButton           *numAddBtn;
@property (nonatomic, strong) UIButton           *numCutBtn;
@property (nonatomic, strong) UITextField        *numText;

@property (nonatomic, assign) NSInteger          numLimit;
@property (nonatomic, assign) NSInteger          isEdit;
@property (nonatomic, strong) id <CellDelegate> theDelegate;

- (void)setCellContentConstraintsWithEditStatus:(BOOL)isEdit;
- (void)setCellContentWithPurchaseInfo:(NSDictionary *)purchaseDic;

@end
