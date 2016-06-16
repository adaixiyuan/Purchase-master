//
//  PurchaseChildViewController.m
//  Purchase
//
//  Created by luoheng on 16/6/10.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "PurchaseChildViewController.h"
#import "PurchaseChildCell.h"
#import "SearchInfoModel.h"
#import "GoodsShowViewController.h"

static const float RowHeight = 140;
static const float BottomHeight = 40;
static const NSInteger CellTag = 1000;

@interface PurchaseChildViewController ()<UITableViewDelegate,UITableViewDataSource,CellDelegate,MWPhotoBrowserDelegate>

@property (nonatomic, strong) AutoTableView  *theTableView;
@property (nonatomic, strong) UIView         *bottomView;

@property (nonatomic, assign) NSInteger      pageNum;
@property (nonatomic, strong) NSMutableArray *purchaseList;
@property (nonatomic, strong) NSMutableArray *selectList;
@property (nonatomic, strong) NSMutableArray *qty_list;

@property (nonatomic, assign) BOOL           setNumTextOriginal; // numtext 还原

@end

@implementation PurchaseChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSInternationalString(@"采购列表", @"采购列表");
    self.setNumTextOriginal = NO;
    self.selectList = [[NSMutableArray alloc]init];
    self.qty_list = [[NSMutableArray alloc]init];
    [self.view addSubview:self.theTableView];
    [self.view addSubview:self.bottomView];
    
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
#pragma mark - Event
- (void)goodsBatchAction:(UIButton *)btn
{
    if (self.selectList.count == 0) {
        [MYMBProgressHUD showMessage:NSInternationalString(@"请选择批量操作的商品！", @"请选择批量操作的商品！")];
        return;
    }
    NSMutableArray *sid_list = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.selectList.count; i++) {
        NSDictionary *purchaseDic = [[NSDictionary alloc]initWithDictionary:self.selectList[i]];
        [sid_list addObject:[NSString stringWithFormat:@"%d",[[purchaseDic objectForKey:@"sid"] intValue]]];
    }
    NSString *sidStr = [sid_list componentsJoinedByString:@","];
    NSString *qtyStr = [self.qty_list componentsJoinedByString:@","];
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
    [parametersDic setObject:self.num_iid forKey:@"num_iid"];
    
    [parametersDic setObject:SAFE_STRING([SearchInfoModel shareInstance].keyStr) forKey:@"des"];
    [parametersDic setObject:SAFE_STRING([SearchInfoModel shareInstance].typeID) forKey:@"types"];
    [parametersDic setObject:SAFE_STRING([SearchInfoModel shareInstance].locationStr) forKey:@"locs"];
    [parametersDic setObject:SAFE_STRING([SearchInfoModel shareInstance].brandName) forKey:@"brand_name"];
    
    [[NetworkManager sharedInstance] startRequestWithURL:kOrderRequest method:RequestPost parameters:parametersDic result:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.theTableView.mj_header endRefreshing];
        [self.theTableView.mj_footer endRefreshing];
        [MYMBProgressHUD hideHudFromView:self.view];
        NSArray *dataList = [[NSArray alloc]initWithArray:[responseObject objectForKey:@"data"]];
        if (self.pageNum == 1){
            self.purchaseList = [[NSMutableArray alloc]initWithArray:dataList];
            self.selectList = [[NSMutableArray alloc]init];
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
    return RowHeight*SizeScaleHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"cell%d%d",(int)indexPath.section,(int)indexPath.row];
    PurchaseChildCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PurchaseChildCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.tag = CellTag+indexPath.section;
    cell.theDelegate = self;
    
    if(self.setNumTextOriginal == YES){
        cell.numText.text = @"0";
    }
    
    NSDictionary *purchaseDic = [[NSDictionary alloc]initWithDictionary:[self.purchaseList objectAtIndex:indexPath.section]];
    [cell setCellContentWithPurchaseInfo:purchaseDic];
    if ([self.selectList containsObject:purchaseDic]) {
        cell.selectBtn.selected = YES;
    }else{
        cell.selectBtn.selected = NO;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PurchaseChildCell *cell = (PurchaseChildCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.selectBtn.selected = !cell.selectBtn.selected;
    [self updateCellSelectStatus:cell];
}
#pragma mark - CellDelegate
- (void)imageTapAction:(id)sender
{
    PurchaseChildCell *cell = (PurchaseChildCell *)sender;
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
    PurchaseChildCell *cell = (PurchaseChildCell *)sender;
    NSDictionary *purchaseDic = [[NSDictionary alloc]initWithDictionary:[self.purchaseList objectAtIndex:cell.tag-CellTag]];
    if (cell.selectBtn.selected == YES) {
        if (![self.selectList containsObject:purchaseDic]) {
            [self.selectList addObject:purchaseDic];
            [self.qty_list addObject:SAFE_STRING(cell.numText.text)];
        }else{
            NSInteger index = (NSInteger)[self.selectList indexOfObject:purchaseDic];
            [self.qty_list replaceObjectAtIndex:index withObject:SAFE_STRING(cell.numText.text)];
        }
    }else{
        if ([self.selectList containsObject:purchaseDic]) {
            NSInteger index = (NSInteger)[self.selectList indexOfObject:purchaseDic];
            [self.qty_list removeObjectAtIndex:index];
            [self.selectList removeObject:purchaseDic];
        }
    }
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
- (AutoTableView *)theTableView
{
    if (_theTableView == nil) {
        _theTableView = [[AutoTableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-BottomHeight*SizeScaleHeight) style:UITableViewStyleGrouped];
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
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-64-BottomHeight*SizeScaleHeight, ScreenWidth, BottomHeight*SizeScaleHeight)];
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
