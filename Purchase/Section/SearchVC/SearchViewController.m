//
//  SearchViewController.m
//  Purchase
//
//  Created by luoheng on 16/5/7.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchInfoModel.h"
#import "GoodsInfoEditViewController.h"
#import "BrandListViewController.h"
#import "TypeListViewController.h"
#import "LocationListViewController.h"
#import "DatePickerView.h"
#import "CodeScanViewController.h"

static const float RowHeight = 42;
static const float FootHeight = 80;

@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView     *theTableView;
@property (nonatomic, strong) NSArray         *baseArray;
@property (nonatomic, assign) BOOL            isClean;

@end

@implementation SearchViewController
- (void)dealloc
{
    if (self.isClean == YES) {
        [[SearchInfoModel shareInstance] clean];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSInternationalString(@"搜索", @"搜索");
    self.isClean = YES;
    [self.view addSubview:self.theTableView];
}
- (void)backAction:(id)sender
{
    [super backAction:sender];
    [[SearchInfoModel shareInstance] clean];
}
- (void)searchAction:(UIButton *)btn
{
    self.isClean = NO;
    if ([[SearchInfoModel shareInstance].brandName isEqualToString:NSInternationalString(@"默认", @"默认")]) {
        [SearchInfoModel shareInstance].brandName = nil;
    }
    if (self.beginSearchWithTheKey) {
        self.beginSearchWithTheKey(SAFE_STRING([SearchInfoModel shareInstance].keyStr),SAFE_STRING([SearchInfoModel shareInstance].brandName),SAFE_STRING([SearchInfoModel shareInstance].typeID),SAFE_STRING([SearchInfoModel shareInstance].dateStr),SAFE_STRING([SearchInfoModel shareInstance].locationStr));
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return FootHeight*SizeScaleHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    static NSString *sectionIdentifier = @"sectionIdentifier";
    UITableViewHeaderFooterView *footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionIdentifier];
    if (!footView) {
        footView = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:sectionIdentifier];
        footView.contentView.backgroundColor = [UIColor clearColor];
        
        UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        searchBtn.backgroundColor = [UIColor clearColor];
        [searchBtn setBackgroundImage:[UIImage imageNamed:@"button_inEffect"] forState:UIControlStateNormal];
        [searchBtn setTitle:NSInternationalString(@"搜索", @"搜索") forState:UIControlStateNormal];
        [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        searchBtn.titleLabel.font = [UIFont customFontOfSize:15];
        [searchBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:searchBtn];
        [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(footView).with.offset(0);
            make.left.equalTo(footView).with.offset(15);
            make.height.equalTo(@(40*SizeScaleHeight));
        }];
    }
    return footView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.baseArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return RowHeight*SizeScaleHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.font = [UIFont customFontOfSize:14];
        cell.textLabel.textColor = SHALLOWBLACK;
        cell.detailTextLabel.font = [UIFont customFontOfSize:14];
        cell.detailTextLabel.textColor = SHALLOWBLACK;
    }
    cell.textLabel.text = self.baseArray[indexPath.row];
    
    NSArray *detailsStrs;
    if([SearchInfoModel shareInstance].fromType != FromPurchaseVC){
        detailsStrs = @[SAFE_STRING([SearchInfoModel shareInstance].keyStr),SAFE_STRING([SearchInfoModel shareInstance].brandName),SAFE_STRING([SearchInfoModel shareInstance].typeName),SAFE_STRING([SearchInfoModel shareInstance].goods_no),SAFE_STRING([SearchInfoModel shareInstance].dateStr)];
    }else{
        NSString *groupStatusStr;
        if ([SearchInfoModel shareInstance].groupStatus == YES) {
            groupStatusStr = NSInternationalString(@"是", @"是");
        }else{
            groupStatusStr = NSInternationalString(@"否", @"否");
        }
        detailsStrs = @[SAFE_STRING([SearchInfoModel shareInstance].keyStr),SAFE_STRING([SearchInfoModel shareInstance].brandName),SAFE_STRING([SearchInfoModel shareInstance].typeName),SAFE_STRING([SearchInfoModel shareInstance].goods_no),SAFE_STRING([SearchInfoModel shareInstance].locationStr),groupStatusStr];
    }
    cell.detailTextLabel.text = detailsStrs[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __weak typeof(self) weakSelf = self;
    switch (indexPath.row) {
        case 0:{
            GoodsInfoEditViewController *goodsInfoVC = [[GoodsInfoEditViewController alloc]init];
            goodsInfoVC.titleStr = NSInternationalString(@"关键字", @"关键字");
            [self.navigationController pushViewController:goodsInfoVC animated:YES];
            goodsInfoVC.updateTheGoodsInfo = ^(NSString *keyStr){
                [SearchInfoModel shareInstance].keyStr = SAFE_STRING(keyStr);
                [weakSelf.theTableView reloadData];
            };
        }
            break;
        case 1:{
            BrandListViewController *brandListVC = [[BrandListViewController alloc]init];
            [self.navigationController pushViewController:brandListVC animated:YES];
            brandListVC.selectTheBrand = ^(NSString *brandStr){
                [SearchInfoModel shareInstance].brandName = SAFE_STRING(brandStr);
                [weakSelf.theTableView reloadData];
            };
        }
            break;
        case 2:{
            TypeListViewController *typeVC = [[TypeListViewController alloc]init];
            [self.navigationController pushViewController:typeVC animated:YES];
            typeVC.selectTheType = ^(NSString *typeStr,NSString *typeID, NSArray *typeIDs){
                [SearchInfoModel shareInstance].typeName = SAFE_STRING(typeStr);
                if ([SearchInfoModel shareInstance].fromType == FromPurchaseVC) {
                    [SearchInfoModel shareInstance].typeID = [typeIDs componentsJoinedByString:@","];
                }else{
                    [SearchInfoModel shareInstance].typeID = typeID;
                }
                [weakSelf.theTableView reloadData];
            };
        }
            break;
        case 3:{
            __weak typeof(self) weakSelf = self;
            [UIActionSheet showInView:self.view
                            withTitle:nil
                    cancelButtonTitle:NSInternationalString(@"取消", @"取消")
               destructiveButtonTitle:nil
                    otherButtonTitles:@[NSInternationalString(@"手动输入", @"手动输入"),NSInternationalString(@"相机扫描", @"相机扫描")]
                             tapBlock:^(UIActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                                 if (buttonIndex == 0) {
                                     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                                                    message:NSInternationalString(@"请输入商品条码", @"请输入商品条码")
                                                                                   delegate:self
                                                                          cancelButtonTitle:NSInternationalString(@"取消", @"取消")
                                                                          otherButtonTitles:NSInternationalString(@"确定", @"确定"), nil];
                                     alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                                     alert.tapBlock = ^(UIAlertView *alertView, NSInteger buttonIndex) {
                                         [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
                                         if (buttonIndex == 1) {
                                             [SearchInfoModel shareInstance].goods_no = SAFE_STRING([[alertView textFieldAtIndex:0] text]);
                                             [weakSelf.theTableView reloadData];
                                         }
                                     };
                                     [alert show];
                                 }else if (buttonIndex == 1){
                                     CodeScanViewController *codeScanVC = [[CodeScanViewController alloc]init];
                                     [weakSelf.navigationController pushViewController:codeScanVC animated:YES];
                                     codeScanVC.sendTheCode = ^(NSString *goods_no){
                                         [SearchInfoModel shareInstance].goods_no = SAFE_STRING(goods_no);
                                         [weakSelf.theTableView reloadData];
                                     };
                                 }
                             }];
        }
            break;
        case 4:{
            if([SearchInfoModel shareInstance].fromType != FromPurchaseVC){
                DatePickerView *dateView = [[DatePickerView alloc]init];
                [dateView showInView:self.view];
                dateView.setTheTime = ^(NSString *dateStr){
                    [SearchInfoModel shareInstance].dateStr = SAFE_STRING(dateStr);
                    [weakSelf.theTableView reloadData];
                };
            }else{
                LocationListViewController *locationVC = [[LocationListViewController alloc]init];
                [self.navigationController pushViewController:locationVC animated:YES];
                locationVC.saveTheAddress = ^(NSString *locationStr){
                    [SearchInfoModel shareInstance].locationStr = SAFE_STRING(locationStr);
                    [weakSelf.theTableView reloadData];
                };
            }
        }
            break;
        case 5:{
            [UIActionSheet showInView:self.view
                            withTitle:nil
                    cancelButtonTitle:NSInternationalString(@"取消", @"取消")
               destructiveButtonTitle:nil
                    otherButtonTitles:@[NSInternationalString(@"是", "是"),NSInternationalString(@"否", @"否")]
                             tapBlock:^(UIActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                                 if(buttonIndex == 0){
                                     [SearchInfoModel shareInstance].groupStatus = YES;
                                 }else if (buttonIndex == 1){
                                     [SearchInfoModel shareInstance].groupStatus = NO;
                                 }
                                 [tableView reloadData];
                             }];
        }
            break;
        default:
            break;
    }
}
#pragma mark - Set && Get
- (UITableView *)theTableView
{
    if (_theTableView == nil) {
        _theTableView = [[AutoTableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStyleGrouped];
        _theTableView.backgroundColor = [UIColor clearColor];
        _theTableView.delegate = self;
        _theTableView.dataSource = self;
        _theTableView.tableFooterView = [[UIView alloc]init];
        _theTableView.separatorColor = separateLineColor;
        if ([_theTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_theTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        if ([_theTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_theTableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
    }
    return _theTableView;
}
- (NSArray *)baseArray
{
    if (_baseArray == nil) {
        if([SearchInfoModel shareInstance].fromType != FromPurchaseVC){
            _baseArray = @[NSInternationalString(@"关键字", @"关键字"),NSInternationalString(@"品牌", @"品牌"),NSInternationalString(@"类型", @"类型"),NSInternationalString(@"条码", @"条码"),NSInternationalString(@"日期", @"日期")];
        }else{
            _baseArray = @[NSInternationalString(@"关键字", @"关键字"),NSInternationalString(@"品牌", @"品牌"),NSInternationalString(@"类型", @"类型"),NSInternationalString(@"条码", @"条码"),NSInternationalString(@"地点", @"地点"),NSInternationalString(@"聚合", @"聚合")];
        }
    }
    return _baseArray;
}
@end
