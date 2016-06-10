//
//  TaoBaoChildCell.m
//  Purchase
//
//  Created by luoheng on 16/5/26.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "TaoBaoChildCell.h"
#import "GoodsInfoModel.h"

static const float ImageWidth = 110;
static const float ImageHeight = 90;

@implementation TaoBaoChildCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            [self setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        
        _goodsImageView = [[UIImageView alloc]init];
        _goodsImageView.backgroundColor = viewBgColor;
        _goodsImageView.userInteractionEnabled = YES;
        _goodsImageView.layer.borderColor = separateLineColor.CGColor;
        _goodsImageView.layer.borderWidth = HalfScale;
        [self.contentView addSubview:_goodsImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [_goodsImageView addGestureRecognizer:tap];
        
        _goodsDesLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
        _goodsDesLabel.backgroundColor = [UIColor clearColor];
        _goodsDesLabel.font = [UIFont customFontOfSize:14];
        _goodsDesLabel.textColor = SHALLOWBLACK;
        _goodsDesLabel.numberOfLines = 2;
        [self.contentView addSubview:_goodsDesLabel];
        
        _priceLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
        _priceLabel.backgroundColor = [UIColor clearColor];
        _priceLabel.font = [UIFont customFontOfSize:12];
        _priceLabel.textColor = SHALLOWBLACK;
        [self.contentView addSubview:_priceLabel];
        
        _sellLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
        _sellLabel.backgroundColor = [UIColor clearColor];
        _sellLabel.font = [UIFont customFontOfSize:12];
        _sellLabel.textColor = SHALLOWBLACK;
        [self.contentView addSubview:_sellLabel];
        
        _storeLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
        _storeLabel.backgroundColor = [UIColor clearColor];
        _storeLabel.font = [UIFont customFontOfSize:12];
        _storeLabel.textColor = SHALLOWBLACK;
        [self.contentView addSubview:_storeLabel];
        
        _waitToBuyLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
        _waitToBuyLabel.backgroundColor = [UIColor clearColor];
        _waitToBuyLabel.font = [UIFont customFontOfSize:12];
        _waitToBuyLabel.textColor = SHALLOWBLACK;
        [self.contentView addSubview:_waitToBuyLabel];
        
        _puchaseLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectZero];
        _puchaseLabel.backgroundColor = [UIColor clearColor];
        _puchaseLabel.font = [UIFont customFontOfSize:12];
        _puchaseLabel.textColor = SHALLOWBLACK;
        [self.contentView addSubview:_puchaseLabel];
        
        _cartButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cartButton.backgroundColor = [UIColor clearColor];
        [_cartButton setImage:[UIImage imageNamed:@"icon_cart"] forState:UIControlStateNormal];
        [_cartButton addTarget:self action:@selector(cartBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_cartButton];
        
        [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView).with.offset(0);
            make.left.equalTo(self.contentView).with.offset(15);
            make.width.equalTo(@(ImageWidth*SizeScaleWidth));
            make.height.equalTo(@(ImageHeight*SizeScaleWidth));
        }];
        [_goodsDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_goodsImageView.mas_top).with.offset(0);
            make.left.equalTo(_goodsImageView.mas_right).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(0);
        }];
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_goodsDesLabel.mas_bottom).with.offset(8);
            make.left.equalTo(_goodsImageView.mas_right).with.offset(10);
            make.right.equalTo(self.contentView).with.offset(-10);
        }];
        [_sellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_priceLabel.mas_bottom).with.offset(5);
            make.left.equalTo(_priceLabel.mas_left).with.offset(0);
            make.right.equalTo(_storeLabel.mas_left).with.offset(-5);
            make.bottom.equalTo(_waitToBuyLabel.mas_top).with.offset(-5);
        }];
        [_storeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_sellLabel.mas_top).with.offset(0);
            make.left.equalTo(_sellLabel.mas_right).with.offset(5);
            make.right.equalTo(_puchaseLabel.mas_right).with.offset(0);
            make.bottom.equalTo(_waitToBuyLabel.mas_top).with.offset(-5);
        }];
        [_waitToBuyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_sellLabel.mas_bottom).with.offset(5);
            make.left.equalTo(_priceLabel.mas_left).with.offset(0);
            make.right.equalTo(_puchaseLabel.mas_left).with.offset(-5);
        }];
        [_puchaseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_sellLabel.mas_bottom).with.offset(5);
            make.left.equalTo(_sellLabel.mas_right).with.offset(5);
            make.right.equalTo(_cartButton.mas_left).with.offset(-5);
            
            make.width.equalTo(_sellLabel.mas_width);
            make.width.equalTo(_storeLabel.mas_width);
            make.width.equalTo(_waitToBuyLabel.mas_width);
            make.height.equalTo(_sellLabel.mas_height);
            make.height.equalTo(_storeLabel.mas_height);
            make.height.equalTo(_waitToBuyLabel.mas_height);
        }];
        [_cartButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).with.offset(-10);
            make.centerY.equalTo(_puchaseLabel.mas_top).with.offset(0);
            make.width.and.height.equalTo(@25);
        }];
    }
    return self;
}
- (void)setCellContentWithGoodsDic:(NSDictionary *)infoDic
{
    GoodsInfoModel *goodsModel = [GoodsInfoModel mj_objectWithKeyValues:infoDic];
    NSString *detailStr;
    NSRange range = NSMakeRange(0, 0);
    if (goodsModel.brand_name == nil || goodsModel.brand_name.length == 0) {
        detailStr = SAFE_STRING(goodsModel.des);
    }else{
        range = NSMakeRange(0, goodsModel.brand_name.length);
        detailStr = [NSString stringWithFormat:@"%@  %@",SAFE_STRING(goodsModel.brand_name),SAFE_STRING(goodsModel.des)];
    }
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:SAFE_STRING(goodsModel.img_url)]];
    [_goodsDesLabel setText:detailStr afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        //设定可点击文字的的大小
        UIFont *systemFont = [UIFont customFontOfSize:14];
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)systemFont.fontName, systemFont.pointSize, NULL);
        if (font) {
            //设置可点击文本的颜色
            [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[NAVBARCOLOR CGColor] range:range];
            CFRelease(font);
        }
        return mutableAttributedString;
    }];
    
    NSString *str1 = NSInternationalString(@"最近购入价", @"最近购入价");
    NSString *str2 = NSInternationalString(@"销量", @"销量");
    NSString *str3 = NSInternationalString(@"库存", @"库存");
    NSString *str4 = NSInternationalString(@"待采购", @"待采购");
    NSString *str5 = NSInternationalString(@"收购量", @"收购量");
    
    NSString *priceStr;
    if (goodsModel.recent_price > 0.000000) {
        priceStr = [NSString stringWithFormat:@"%@：¥%.2f",str1,(float)goodsModel.recent_price];
    }else{
        priceStr = NSInternationalString(@"最近购入价：--", @"最近购入价：--");
    }
    NSString *sellStr = [NSString stringWithFormat:@"%@：%d",str2,(int)goodsModel.sell_qty];
    NSString *storeStr = [NSString stringWithFormat:@"%@：%d",str3,(int)goodsModel.stock_qty];
    NSString *buyStr = [NSString stringWithFormat:@"%@：%d",str4,(int)goodsModel.wait_to_buy];
    NSString *purchaseStr = [NSString stringWithFormat:@"%@：%d",str5,(int)goodsModel.publish_qty];
    
    [_priceLabel setText:priceStr afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange range = NSMakeRange(str1.length+1, priceStr.length-str1.length-1);
        //设定可点击文字的的大小
        UIFont *systemFont = [UIFont customFontOfSize:13];
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)systemFont.fontName, systemFont.pointSize, NULL);
        if (font) {
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:range];
            [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[NAVBARCOLOR CGColor] range:range];
            CFRelease(font);
        }
        return mutableAttributedString;
    }];
    [_sellLabel setText:sellStr afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange range = NSMakeRange(str2.length+1, sellStr.length-str2.length-1);
        //设定可点击文字的的大小
        UIFont *systemFont = [UIFont customFontOfSize:13];
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)systemFont.fontName, systemFont.pointSize, NULL);
        if (font) {
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:range];
            CFRelease(font);
        }
        return mutableAttributedString;
    }];
    [_storeLabel setText:storeStr afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange range = NSMakeRange(str3.length+1, storeStr.length-str3.length-1);
        //设定可点击文字的的大小
        UIFont *systemFont = [UIFont customFontOfSize:13];
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)systemFont.fontName, systemFont.pointSize, NULL);
        if (font) {
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:range];
            CFRelease(font);
        }
        return mutableAttributedString;
    }];
    [_waitToBuyLabel setText:buyStr afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange range = NSMakeRange(str4.length+1, buyStr.length-str4.length-1);
        //设定可点击文字的的大小
        UIFont *systemFont = [UIFont customFontOfSize:13];
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)systemFont.fontName, systemFont.pointSize, NULL);
        if (font) {
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:range];
            CFRelease(font);
        }
        return mutableAttributedString;
    }];
    [_puchaseLabel setText:purchaseStr afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange range = NSMakeRange(str5.length+1, purchaseStr.length-str5.length-1);
        //设定可点击文字的的大小
        UIFont *systemFont = [UIFont customFontOfSize:13];
        CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)systemFont.fontName, systemFont.pointSize, NULL);
        if (font) {
            [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:range];
            CFRelease(font);
        }
        return mutableAttributedString;
    }];
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if(self.theDelegate && [self.theDelegate respondsToSelector:@selector(imageTapAction:)]){
        [self.theDelegate imageTapAction:self];
    }
}
- (void)cartBtnAction:(UIButton *)btn
{
    if (self.theDelegate && [self.theDelegate respondsToSelector:@selector(addCartToPurchase:)]) {
        [self.theDelegate addCartToPurchase:self];
    }
}

@end
