//
//  PurchaseOrderViewController.m
//  Purchase
//
//  Created by luoheng on 16/5/6.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "PurchaseOrderViewController.h"
#import "PurchaseOrderCell.h"
#import "SearchViewController.h"
#import "SearchInfoModel.h"
#import "GoodsShowViewController.h"
#import "PurchaseChildViewController.h"

static const float RowHeight = 140;
static const float BottomHeight = 40;
static const NSInteger CellTag = 1000;

@interface PurchaseOrderViewController ()<UITableViewDelegate,UITableViewDataSource,CellDelegate,MWPhotoBrowserDelegate>

@property (nonatomic, strong) AutoTableView  *theTableView;
@property (nonatomic, strong) UIView         *bottomView;

@property (nonatomic, assign) NSInteger      pageNum;
@property (nonatomic, strong) NSMutableArray *purchaseList;
@property (nonatomic, strong) NSMutableArray *selectList;

@property (nonatomic, strong) NSString       *searchDesStr;// 搜索关键字
@property (nonatomic, strong) NSString       *searchBrandStr;// 搜索品牌
@property (nonatomic, strong) NSString       *searchLocation; //  搜索地点

@property (nonatomic, assign) BOOL           setNumTextOriginal; // numtext 还原

@end

@implementation PurchaseOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSInternationalString(@"采购列表", @"采购列表");
    self.setNumTextOriginal = NO;
    self.selectList = [[NSMutableArray alloc]init];
    // 创建导航栏右边按钮
    [self creatRightNavView];
    [self.view addSubview:self.theTableView];
    [self.view addSubview:self.bottomView];
    
    [SearchInfoModel shareInstance].groupStatus = YES;
    self.pageNum = 1;
    self.purchaseList = [[NSMutableArray alloc]init];
    // 获取采购单列表
    [MYMBProgressHUD showHudWithMessage:NSInternationalString(@"请稍等···", @"请稍等···") InView:self.view];
    [self getPurchaseRequest];
    
    __weak typeof(self) weakSelf = self;
    self.theTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageNum = 1;
        [weakSelf getPurchaseRequest];
    }];
    self.theTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageNum ++;
        [weakSelf getPurchaseRequest];
    }];
}
- (void)creatRightNavView
{
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(0, 0, 45, 40);
    searchButton.backgroundColor = [UIColor clearColor];
    [searchButton setImage:[UIImage imageNamed:@"nav_search"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(navSearchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:searchButton] animated:YES];
}
#pragma mark - Event
- (void)navSearchAction:(UIButton *)btn
{
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [SearchInfoModel shareInstance].fromType = FromPurchaseVC;
    [SearchInfoModel shareInstance].typeList = @[NSInternationalString(@"采购单", @"采购单"),NSInternationalString(@"收货单", @"收货单"),NSInternationalString(@"实时发布商品", @"实时发布商品")];
    [SearchInfoModel shareInstance].domain = @"Order";
    
    [self.navigationController pushViewController:searchVC animated:YES];
    __weak typeof(self) weakSelf = self;
    searchVC.beginSearchWithTheKey = ^(NSString *des,NSString *brand,NSString *type, NSString *date, NSString *location){
        weakSelf.pageNum = 1;
        [MYMBProgressHUD showHudWithMessage:NSInternationalString(@"请稍等···", @"请稍等···") InView:weakSelf.view];
        [weakSelf getPurchaseRequest];
    };
}
- (void)purchaseEditAction
{
    __weak typeof(self) weakSelf = self;
    if (self.selectList.count > 0) {
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.bottomView.frame = CGRectMake(0, ScreenHeight-64-BottomHeight*SizeScaleHeight, ScreenWidth, BottomHeight*SizeScaleHeight);
            weakSelf.theTableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-BottomHeight*SizeScaleHeight);
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.bottomView.frame = CGRectMake(0, ScreenHeight-64, ScreenWidth, BottomHeight*SizeScaleHeight);
            weakSelf.theTableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
        }];
    }
    [self.theTableView reloadData];
}
- (void)goodsBatchAction:(UIButton *)btn
{
    if (self.selectList.count == 0) {
        [MYMBProgressHUD showMessage:NSInternationalString(@"请选择批量操作的商品！", @"请选择批量操作的商品！")];
        return;
    }
    NSMutableArray *sid_list = [[NSMutableArray alloc]init];
    NSMutableArray *qty_list = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.selectList.count; i++) {
        NSDictionary *purchaseDic = [[NSDictionary alloc]initWithDictionary:[self.purchaseList objectAtIndex:[self.selectList[i] integerValue]]];
        [sid_list addObject:[NSString stringWithFormat:@"%d",[[purchaseDic objectForKey:@"sid"] intValue]]];
        NSIndexPath *indexPath =  [NSIndexPath indexPathForRow:0 inSection:[self.selectList[i] integerValue]];
        PurchaseOrderCell *cell = (PurchaseOrderCell *)[self.theTableView cellForRowAtIndexPath:indexPath];
         [qty_list addObject:SAFE_STRING(cell.numText.text)];
    }
    NSString *sidStr = [sid_list componentsJoinedByString:@","];
    NSString *qtyStr = [qty_list componentsJoinedByString:@","];
    if ([btn.titleLabel.text isEqualToString:NSInternationalString(@"批量采购", @"批量采购")]) {
        [self purchaseOrderWithSid:sidStr withQty:qtyStr withLoc:nil withAction:@"purchase"];
    }else if ([btn.titleLabel.text isEqualToString:NSInternationalString(@"批量订购", @"批量订购")]){
        __weak typeof(self) weakSelf = self;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                       message:NSInternationalString(@"请输入订货地点", @"请输入订货地点")
                                                      delegate:self
                                             cancelButtonTitle:NSInternationalString(@"取消", @"取消")
                                             otherButtonTitles:NSInternationalString(@"确定", @"确定"), nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        alert.tapBlock = ^(UIAlertView *alertView, NSInteger buttonIndex) {
            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
            if (buttonIndex == 1) {
                [weakSelf purchaseOrderWithSid:sidStr withQty:qtyStr withLoc:SAFE_STRING([alertView textFieldAtIndex:0].text) withAction:@"reserve"];
            }
        };
        alert.shouldEnableFirstOtherButtonBlock = ^BOOL(UIAlertView *alertView) {
            return ([[[alertView textFieldAtIndex:0] text] length] > 0);
        };
        [alert show];
    }else{
        __weak typeof(self) weakSelf = self;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                       message:NSInternationalString(@"请输入缺货地点", @"请输入缺货地点")
                                                      delegate:self
                                             cancelButtonTitle:NSInternationalString(@"取消", @"取消")
                                             otherButtonTitles:NSInternationalString(@"确定", @"确定"), nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        alert.tapBlock = ^(UIAlertView *alertView, NSInteger buttonIndex) {
            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
            if (buttonIndex == 1) {
                [weakSelf purchaseOrderWithSid:sidStr withQty:nil withLoc:SAFE_STRING([alertView textFieldAtIndex:0].text) withAction:@"out_of_stock"];
            }
        };
        alert.shouldEnableFirstOtherButtonBlock = ^BOOL(UIAlertView *alertView) {
            return ([[[alertView textFieldAtIndex:0] text] length] > 0);
        };
        [alert show];
    }
}
// 采购操作
- (void)purchaseOrderWithSid:(NSString *)sid withQty:(NSString *)qty withLoc:(NSString *)loc withAction:(NSString *)action
{
    [MYMBProgressHUD showHudWithMessage:NSInternationalString(@"请稍等···", @"请稍等···") InView:self.view];
    NSMutableDictionary *parametersDic = [[NSMutableDictionary alloc]init];
    [parametersDic setObject:action forKey:@"action"];
    [parametersDic setObject:@([UserInfoModel shareInstance].user_sid) forKey:@"user_sid"];
    [parametersDic setObject:SAFE_STRING(sid) forKey:@"sid"];
    [parametersDic setObject:SAFE_STRING(qty) forKey:@"qty"];
    if([action isEqualToString:@"out_of_stock"]){
        [parametersDic setObject:SAFE_STRING(loc) forKey:@"lack_loc"];
    }else if([action isEqualToString:@"reserve"]){
        [parametersDic setObject:SAFE_STRING(loc) forKey:@"reserve_loc"];
    }
    
    [[NetworkManager sharedInstance] startRequestWithURL:kOrderRequest method:RequestPost parameters:parametersDic result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.pageNum = 1;
        [self.selectList removeAllObjects];
        self.setNumTextOriginal = YES; // 还原输入框
        [self.theTableView reloadData];
        [self getPurchaseRequest];
        [MYMBProgressHUD hideHudFromView:self.view];
        [MYMBProgressHUD showMessage:SAFE_STRING([responseObject objectForKey:@"msg"])];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MYMBProgressHUD hideHudFromView:self.view];
        [MYMBProgressHUD showMessage:error.userInfo[@"NSLocalizedDescription"]];
    }];
}
#pragma mark - Request
- (void)getPurchaseRequest
{
    NSMutableDictionary *parametersDic = [[NSMutableDictionary alloc]init];
    [parametersDic setObject:@"get" forKey:@"action"];
    [parametersDic setObject:@(self.pageNum) forKey:@"page_no"];
    [parametersDic setObject:SAFE_STRING([SearchInfoModel shareInstance].keyStr) forKey:@"des"];
    [parametersDic setObject:SAFE_STRING([SearchInfoModel shareInstance].typeID) forKey:@"types"];
    [parametersDic setObject:SAFE_STRING([SearchInfoModel shareInstance].locationStr) forKey:@"locs"];
    [parametersDic setObject:SAFE_STRING([SearchInfoModel shareInstance].brandName) forKey:@"brand_name"];
    [parametersDic setObject:SAFE_STRING([SearchInfoModel shareInstance].goods_no) forKey:@"goods_no"];
    if ([SearchInfoModel shareInstance].groupStatus == YES) {
        [parametersDic setObject:@"true" forKey:@"group_tb"];
    }
    
    [[NetworkManager sharedInstance] startRequestWithURL:kOrderRequest method:RequestPost parameters:parametersDic result:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.theTableView.mj_header endRefreshing];
        [self.theTableView.mj_footer endRefreshing];
        [MYMBProgressHUD hideHudFromView:self.view];
        NSArray *dataList = [[NSArray alloc]initWithArray:[responseObject objectForKey:@"data"]];
        if (self.pageNum == 1){
            self.purchaseList = [[NSMutableArray alloc]initWithArray:dataList];
        }else{
            [self.purchaseList addObjectsFromArray:dataList];
        }
        self.setNumTextOriginal = NO; // 不还原输入框
        [self.theTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.pageNum > 1) {
            self.pageNum--;
        }
        self.setNumTextOriginal = NO; // 不还原输入框
        [self.theTableView reloadData];
        [self.theTableView.mj_header endRefreshing];
        [self.theTableView.mj_footer endRefreshing];
        [MYMBProgressHUD hideHudFromView:self.view];
        [MYMBProgressHUD showMessage:error.userInfo[@"NSLocalizedDescription"]];
    }];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.purchaseList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 如果sid为0, 表示该商品为聚合商品, 不可以直接操作采购, 订货,或者缺货
    NSDictionary *purchaseDic = [[NSDictionary alloc]initWithDictionary:[self.purchaseList objectAtIndex:indexPath.section]];
    PurchaseInfoModel *purchaseModel = [PurchaseInfoModel mj_objectWithKeyValues:purchaseDic];
    if (purchaseModel.sid == 0){
        return RowHeight*SizeScaleHeight-35;
    }else{
        return RowHeight*SizeScaleHeight;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"cell%d%d",(int)indexPath.section,(int)indexPath.row];
    PurchaseOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PurchaseOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if(self.setNumTextOriginal == YES){
        cell.numText.text = @"0";
    }
    cell.tag = CellTag+indexPath.section;
    cell.theDelegate = self;
   
    NSDictionary *purchaseDic = [[NSDictionary alloc]initWithDictionary:[self.purchaseList objectAtIndex:indexPath.section]];
    [cell setCellContentWithPurchaseInfo:purchaseDic];
    
    if ([self.selectList containsObject:@(indexPath.section)]) {
        cell.selectBtn.selected = YES;
    }else{
        cell.selectBtn.selected = NO;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 如果sid为0, 表示该商品为聚合商品, 不可以直接操作采购, 订货,或者缺货
    NSDictionary *purchaseDic = [[NSDictionary alloc]initWithDictionary:[self.purchaseList objectAtIndex:indexPath.section]];
    if ([[purchaseDic objectForKey:@"sid"] integerValue] == 0) {
        PurchaseChildViewController *purchaseVC = [[PurchaseChildViewController alloc]init];
        purchaseVC.num_iid = SAFE_STRING([purchaseDic objectForKey:@"num_iid"]);
        [self.navigationController pushViewController:purchaseVC animated:YES];
    }else{
        PurchaseOrderCell *cell = (PurchaseOrderCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.selectBtn.selected = !cell.selectBtn.selected;
        [self updateCellSelectStatus:cell];
    }
}
#pragma mark - CellDelegate
- (void)imageTapAction:(id)sender
{
    PurchaseOrderCell *cell = (PurchaseOrderCell *)sender;
    GoodsShowViewController *goodsShowVC = [[GoodsShowViewController alloc]initWithDelegate:self];
    [goodsShowVC setCurrentPhotoIndex:cell.tag - CellTag];
    [self.navigationController pushViewController:goodsShowVC animated:YES];
    
    __weak typeof(self) weakSelf = self;
    goodsShowVC.selectGoodsIndex = ^(NSInteger index){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
        [weakSelf.theTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    };
}
- (void)updateCellSelectStatus:(id)sender
{
    PurchaseOrderCell *cell = (PurchaseOrderCell *)sender;
    if (cell.selectBtn.selected == YES) {
        if (![self.selectList containsObject:@(cell.tag-CellTag)]) {
            [self.selectList addObject:@(cell.tag-CellTag)];
            [self.theTableView reloadData];
        }
    }else{
        if ([self.selectList containsObject:@(cell.tag-CellTag)]) {
            [self.selectList removeObject:@(cell.tag-CellTag)];
            [self.theTableView reloadData];
        }
    }
    [self purchaseEditAction];
}
#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.purchaseList.count;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    
    if (index < self.purchaseList.count) {
        NSDictionary *infoDic = [[NSDictionary alloc]initWithDictionary:[self.purchaseList objectAtIndex:index]];
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:SAFE_STRING([infoDic objectForKey:@"img_url"])]];
        photo.caption = SAFE_STRING([infoDic objectForKey:@"des"]);
        return photo;
    }
    return nil;
}
- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index
{
    NSDictionary *infoDic = [[NSDictionary alloc]initWithDictionary:[self.purchaseList objectAtIndex:index]];
    return SAFE_STRING([infoDic objectForKey:@"brand_name"]);
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
- (UIView *)bottomView
{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-64, ScreenWidth, BottomHeight*SizeScaleHeight)];
        _bottomView.backgroundColor = NAVBARCOLOR;
        
        NSArray *titles = @[NSInternationalString(@"批量采购", @"批量采购"),NSInternationalString(@"批量订购", @"批量订购"),NSInternationalString(@"批量缺货", @"批量缺货")];
        for (int i = 0; i < titles.count; i ++) {
            UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
            actionButton.backgroundColor = [UIColor clearColor];
            actionButton.frame = CGRectMake(ScreenWidth/3*i, 0, ScreenWidth/3, BottomHeight*SizeScaleHeight);
            [actionButton setTitle:titles[i] forState:UIControlStateNormal];
            [actionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [actionButton setTitleColor:SHALLOWGRAY forState:UIControlStateHighlighted];
            actionButton.titleLabel.font = [UIFont customFontOfSize:14];
            [actionButton addTarget:self action:@selector(goodsBatchAction:) forControlEvents:UIControlEventTouchUpInside];
            [_bottomView addSubview:actionButton];
            
            if (i > 0) {
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/3*i, 5, HalfScale,BottomHeight*SizeScaleHeight-10)];
                line.backgroundColor = separateLineColor;
                [_bottomView addSubview:line];
            }
        }
    }
    return _bottomView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
