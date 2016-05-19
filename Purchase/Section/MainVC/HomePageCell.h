//
//  HomePageCell.h
//  Purchase
//
//  Created by luoheng on 16/5/7.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CellDelegate <NSObject>

- (void)imageTapAction:(id)sender;

@end

@interface HomePageCell : UITableViewCell

@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *contentLabel;
@property (nonatomic, strong) UILabel     *tagLabel;

@property (nonatomic, strong) id <CellDelegate> theDelegate;

- (void)setCellContentWithDic:(NSDictionary *)dic;

@end
