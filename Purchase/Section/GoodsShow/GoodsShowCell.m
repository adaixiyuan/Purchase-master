//
//  GoodsShowCell.m
//  Purchase
//
//  Created by luoheng on 16/5/13.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "GoodsShowCell.h"

@implementation GoodsShowCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initView];
    }
    return self;
}
- (void)initView
{
    _goodsImageView = [[UIImageView alloc]init];
    _goodsImageView.backgroundColor = [UIColor blackColor];
    _goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_goodsImageView];
    
    _bgView = [[UIView alloc]init];
    _bgView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.65];
    [self.contentView addSubview:_bgView];
    
    _desLabel = [[UILabel alloc]init];
    _desLabel.backgroundColor = [UIColor clearColor];
    _desLabel.textColor = NAVBARCOLOR;
    _desLabel.font = [UIFont customFontOfSize:14];
    _desLabel.numberOfLines = 0;
    [_bgView addSubview:_desLabel];
    
    _otherLabel = [[UILabel alloc]init];
    _otherLabel.backgroundColor = [UIColor clearColor];
    _otherLabel.textColor = NAVBARCOLOR;
    _otherLabel.font = [UIFont customFontOfSize:14];
    [_bgView addSubview:_otherLabel];
    
    [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(0);
        make.right.equalTo(self.contentView).with.offset(0);
        make.bottom.equalTo(self.contentView).with.offset(0);
    }];
    [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgView.mas_top).with.offset(10);
        make.left.equalTo(_bgView.mas_left).with.offset(15);
        make.right.equalTo(_bgView.mas_right).with.offset(-15);
        make.bottom.equalTo(_otherLabel.mas_top).with.offset(-10);
    }];
    [_otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_desLabel.mas_bottom).with.offset(10);
        make.left.equalTo(_bgView.mas_left).with.offset(15);
        make.right.equalTo(_bgView.mas_right).with.offset(-15);
        make.bottom.equalTo(_bgView.mas_bottom).with.offset(-10);
    }];
}
- (void)setCellContentWithInfo:(NSDictionary *)infoDic withVCType:(NSInteger)vcType
{
    /**
     *   HomePageVC = 0,   // 首页
     *   PurchaseVC = 1,   // 采购单
     *   RecordVC = 2,     // 记录
     *   GoodsInfoVC = 3,  // 商品信息
     */
    NSString *des;
    NSString *imgUrl;
    if (vcType == 1){
        des = [NSString stringWithFormat:@"%@  %@",SAFE_STRING([infoDic objectForKey:@"brand_name"]),SAFE_STRING([infoDic objectForKey:@"des"])];
        imgUrl = SAFE_STRING([infoDic objectForKey:@"img_url"]);
    }else if (vcType == 3) {
        des = [NSString stringWithFormat:@"%@  %@",SAFE_STRING([infoDic objectForKey:@"brand_name"]),SAFE_STRING([infoDic objectForKey:@"des"])];
        imgUrl = SAFE_STRING([infoDic objectForKey:@"img_url"]);
    }else if(vcType == 2){
        des = [NSString stringWithFormat:@"%@  %@",SAFE_STRING([infoDic objectForKey:@"brand_name"]),SAFE_STRING([infoDic objectForKey:@"des"])];
        imgUrl = SAFE_STRING([infoDic objectForKey:@"imgUrl"]);
    }
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
    _desLabel.text = des;
    
    float height = [des getHeightBoundingRectWithFont:[UIFont customFontOfSize:14] andWidth:ScreenWidth-30];
    [_bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(0);
        make.right.equalTo(self.contentView).with.offset(0);
        make.bottom.equalTo(self.contentView).with.offset(0);
        make.height.equalTo(@((height+20)*SizeScaleHeight+30));
    }];
    [_desLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgView.mas_top).with.offset(10);
        make.left.equalTo(_bgView.mas_left).with.offset(15);
        make.right.equalTo(_bgView.mas_right).with.offset(-15);
        make.bottom.equalTo(_otherLabel.mas_top).with.offset(-10);
        make.height.equalTo(@(height*SizeScaleHeight));
    }];
    [_otherLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_desLabel.mas_bottom).with.offset(10);
        make.left.equalTo(_bgView.mas_left).with.offset(15);
        make.right.equalTo(_bgView.mas_right).with.offset(-15);
        make.bottom.equalTo(_bgView.mas_bottom).with.offset(-10);
        make.height.equalTo(@(20*SizeScaleHeight));
    }];
}
@end
