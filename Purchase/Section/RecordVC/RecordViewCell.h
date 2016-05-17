//
//  RecordViewCell.h
//  Purchase
//
//  Created by luoheng on 16/5/10.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import <MGSwipeTableCell/MGSwipeTableCell.h>

@protocol CellDelegate <NSObject>

- (void)imageTapAction:(id)sender;

@end

@interface RecordViewCell : MGSwipeTableCell<UITextFieldDelegate>

@property (nonatomic, strong) UIButton           *selectButton;
@property (nonatomic, strong) UIImageView        *goodsImageView;
@property (nonatomic, strong) TTTAttributedLabel *goodsDetailsLabel;
@property (nonatomic, strong) UILabel            *numLabel;
@property (nonatomic, strong) UILabel            *timeLabel;
@property (nonatomic, strong) UILabel            *updateNumLabel;
@property (nonatomic, strong) UITextField        *numText;

@property (nonatomic, assign) NSInteger   isEdit;
@property (nonatomic, weak) id <CellDelegate> theDelegate;

- (void)setCellContentWithDataDic:(NSDictionary *)dic;
- (void)setCellContentConstraintsWithStatus:(BOOL)isEdit;

@end
