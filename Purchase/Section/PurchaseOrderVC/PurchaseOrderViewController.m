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

static const float FootHeight = 35;
static const float RowHeight = 120;
static const float BottomHeight = 40;
static const float animateTime = 0.3;
static const NSInteger CellTag = 1000;

@interface PurchaseOrderViewController ()<UITableViewDelegate,UITableViewDataSource,CellDelegate>

@property (nonatomic, strong) AutoTableView  *theTableView;
@property (nonatomic, strong) UIButton       *editButton;
@property (nonatomic, strong) UIView         *bottomView;
@property (nonatomic, assign) BOOL           isEdit;

@property (nonatomic, assign) NSInteger      pageNum;
@property (nonatomic, strong) NSMutableArray *purchaseList;
@property (nonatomic, strong) NSMutableArray *selectList;

@property (nonatomic, strong) NSString       *searchDesStr;// 搜索关键字
@property (nonatomic, strong) NSString       *searchBrandStr;// 搜索品牌
@property (nonatomic, strong) NSString       *searchLocation; //  搜索地点

@end

@implementation PurchaseOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"采购单", @"采购单");
    self.isEdit = NO;
    self.selectList = [[NSMutableArray alloc]init];
    // 创建导航栏右边按钮
    [self creatRightNavView];
    [self.view addSubview:self.theTableView];
    [self.view addSubview:self.bottomView];
    
    self.pageNum = 1;
    self.purchaseList = [[NSMutableArray alloc]init];
    // 获取采购单列表
    [MYMBProgressHUD showHudWithMessage:NSLocalizedString(@"请稍等···", @"请稍等···") InView:self.view];
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
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 70, 30)];
    rightView.backgroundColor = [UIColor clearColor];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(0, 0, 30, 30);
    searchButton.backgroundColor = [UIColor clearColor];
    [searchButton setImage:[UIImage imageNamed:@"nav_search"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(navSearchAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:searchButton];
    
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editButton.frame = CGRectMake(30, 0, 40, 30);
    self.editButton.backgroundColor = [UIColor clearColor];
    [self.editButton setTitle:NSLocalizedString(@"批量", @"批量") forState:UIControlStateNormal];
    [self.editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.editButton.titleLabel.font = [UIFont customFontOfSize:14];
    [self.editButton addTarget:self action:@selector(navEditAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:self.editButton];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:rightView] animated:YES];
}
#pragma mark - Event
- (void)navSearchAction:(UIButton *)btn
{
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    
    [SearchInfoModel shareInstance].fromType = FromPurchaseVC;
    [SearchInfoModel shareInstance].typeList = @[@"采购单",@"收货单",@"实时发布商品"];
    [SearchInfoModel shareInstance].domain = @"Order";
    
    [self.navigationController pushViewController:searchVC animated:YES];
    __weak typeof(self) weakSelf = self;
    searchVC.beginSearchWithTheKey = ^(NSString *des,NSString *brand,NSString *type, NSString *date, NSString *location){
        weakSelf.pageNum = 1;
        [MYMBProgressHUD showHudWithMessage:NSLocalizedString(@"请稍等···", @"请稍等···") InView:weakSelf.view];
        [weakSelf getPurchaseRequest];
    };
}
- (void)navEditAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    self.isEdit = btn.selected;
    [UIView animateWithDuration:animateTime*3 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.theTableView cache:YES];
        if (self.isEdit == NO) {
            [self.editButton setTitle:NSLocalizedString(@"批量", @"批量") forState:UIControlStateNormal];
            [UIView animateWithDuration:animateTime/2 animations:^{
                self.bottomView.frame = CGRectMake(0 ,ScreenHeight-64, ScreenWidth, BottomHeight*SizeScaleHeight);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:animateTime animations:^{
                    self.theTableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
                    [self.theTableView reloadData];
                }];
            }];
        }else{
            [self.editButton setTitle:NSLocalizedString(@"取消", @"取消") forState:UIControlStateNormal];
            [UIView animateWithDuration:animateTime animations:^{
                self.theTableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-BottomHeight*SizeScaleHeight);
                [self.theTableView reloadData];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:animateTime animations:^{
                    self.bottomView.frame = CGRectMake(0 ,ScreenHeight-64-BottomHeight*SizeScaleHeight, ScreenWidth, BottomHeight*SizeScaleHeight);
                }];
            }];
        }
    }];
}
- (void)goodsAction:(UIButton *)btn event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.theTableView];
    NSIndexPath *indexPath = [self.theTableView indexPathForRowAtPoint:currentTouchPosition];
    PurchaseOrderCell *cell = (PurchaseOrderCell *)[self.theTableView cellForRowAtIndexPath:indexPath];
    NSDictionary *purchaseDic = [[NSDictionary alloc]initWithDictionary:[self.purchaseList objectAtIndex:indexPath.section]];
    NSString *sidStr = [NSString stringWithFormat:@"%d",(int)[purchaseDic objectForKey:@"sid"]];
    NSString *qtyStr = cell.numText.text;
    if ([btn.titleLabel.text isEqualToString:NSLocalizedString(@"采购", @"采购")]) {
        if (qtyStr.length == 0) {
            [MYMBProgressHUD showMessage:@"请输入采购数量！"];
            return;
        }
        [self purchaseOrderWithSid:sidStr withQty:qtyStr withAction:@"purchase"];
    }else if ([btn.titleLabel.text isEqualToString:NSLocalizedString(@"订购", @"订购")]){
        if (qtyStr.length == 0) {
            [MYMBProgressHUD showMessage:@"请输入订购数量！"];
            return;
        }
        [self purchaseOrderWithSid:sidStr withQty:qtyStr withAction:@"reserve"];
    }else{
        [self purchaseOrderWithSid:sidStr withQty:nil withAction:@"out_of_stock"];
    }
}
- (void)goodsBatchAction:(UIButton *)btn
{
    if (self.selectList.count == 0) {
        [MYMBProgressHUD showMessage:NSLocalizedString(@"请选择批量操作的商品！", @"请选择批量操作的商品！")];
        return;
    }
    NSMutableArray *sid_list = [[NSMutableArray alloc]init];
    NSMutableArray *qty_list = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.selectList.count; i++) {
        NSDictionary *purchaseDic = [[NSDictionary alloc]initWithDictionary:[self.purchaseList objectAtIndex:[self.selectList[i] integerValue]]];
        [sid_list addObject:[NSString stringWithFormat:@"%d",(int)[purchaseDic objectForKey:@"sid"]]];
        NSIndexPath *indexPath =  [NSIndexPath indexPathForRow:0 inSection:[self.selectList[i] integerValue]];
        PurchaseOrderCell *cell = (PurchaseOrderCell *)[self.theTableView cellForRowAtIndexPath:indexPath];
         [qty_list addObject:SAFE_STRING(cell.numText.text)];
    }
    NSString *sidStr = [sid_list componentsJoinedByString:@","];
    NSString *qtyStr = [qty_list componentsJoinedByString:@","];
    if ([btn.titleLabel.text isEqualToString:NSLocalizedString(@"批量采购", @"批量采购")]) {
        [self purchaseOrderWithSid:sidStr withQty:qtyStr withAction:@"purchase"];
    }else if ([btn.titleLabel.text isEqualToString:NSLocalizedString(@"批量订购", @"批量订购")]){
        [self purchaseOrderWithSid:sidStr withQty:qtyStr withAction:@"reserve"];
    }else{
        [self purchaseOrderWithSid:sidStr withQty:nil withAction:@"out_of_stock"];
    }
}
// 采购操作
- (void)purchaseOrderWithSid:(NSString *)sid withQty:(NSString *)qty withAction:(NSString *)action
{
    [MYMBProgressHUD showHudWithMessage:NSLocalizedString(@"请稍等···", @"请稍等···") InView:self.view];
    NSMutableDictionary *parametersDic = [[NSMutableDictionary alloc]init];
    [parametersDic setObject:action forKey:@"action"];
    [parametersDic setObject:@([UserInfoModel shareInstance].user_sid) forKey:@"user_sid"];
    [parametersDic setObject:SAFE_STRING(sid) forKey:@"sid"];
    [parametersDic setObject:SAFE_STRING(qty) forKey:@"qty"];
    
    [[NetworkManager sharedInstance] startRequestWithURL:kOrderRequest method:RequestPost parameters:parametersDic result:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.pageNum = 1;
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
    
    [[NetworkManager sharedInstance] startRequestWithURL:kOrderRequest method:RequestPost parameters:parametersDic result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.theTableView.mj_header endRefreshing];
        [self.theTableView.mj_footer endRefreshingWithNoMoreData];
        [MYMBProgressHUD hideHudFromView:self.view];
        NSArray *dataList = [[NSArray alloc]initWithArray:[responseObject objectForKey:@"data"]];
        if (self.pageNum == 1){
            self.purchaseList = [[NSMutableArray alloc]initWithArray:dataList];
        }else{
            [self.purchaseList addObjectsFromArray:dataList];
        }
        [self.theTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.pageNum > 1) {
            self.pageNum--;
        }
        [self.theTableView.mj_header endRefreshing];
        [self.theTableView.mj_footer endRefreshingWithNoMoreData];
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
    if (self.isEdit == NO) {
        return FootHeight*SizeScaleHeight;
    }else{
        return 0.01;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    static NSString *sectionFootIdentifier = @"sectionFootIdentifier";
    UITableViewHeaderFooterView *footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionFootIdentifier];
    if (!footView) {
        footView = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:sectionFootIdentifier];
        footView.contentView.backgroundColor = [UIColor whiteColor];
    
        NSArray *titles = @[NSLocalizedString(@"采购", @"采购"),NSLocalizedString(@"订购", @"订购"),NSLocalizedString(@"缺货", @"缺货")];
        for (int i = 0; i < titles.count; i ++) {
            UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
            actionButton.backgroundColor = [UIColor clearColor];
            actionButton.frame = CGRectMake(ScreenWidth/3*i, 0, ScreenWidth/3, FootHeight*SizeScaleHeight);
            [actionButton setTitle:titles[i] forState:UIControlStateNormal];
            [actionButton setTitleColor:SHALLOWGRAY forState:UIControlStateNormal];
            [actionButton setTitleColor:NAVBARCOLOR forState:UIControlStateHighlighted];
            actionButton.titleLabel.font = [UIFont customFontOfSize:14];
            [actionButton addTarget:self action:@selector(goodsAction:event:) forControlEvents:UIControlEventTouchUpInside];
            [footView addSubview:actionButton];
            
            if (i > 0) {
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/3*i, 5, HalfScale,FootHeight*SizeScaleHeight-10)];
                line.backgroundColor = separateLineColor;
                [footView addSubview:line];
            }
        }
    }
    if (self.isEdit == NO) {
        return footView;
    }else{
        return nil;
    }
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
    PurchaseOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PurchaseOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.tag = CellTag+indexPath.section;
    cell.theDelegate = self;
    [cell setCellContentConstraintsWithEditStatus:self.isEdit];
    
    NSDictionary *purchaseDic = [[NSDictionary alloc]initWithDictionary:[self.purchaseList objectAtIndex:indexPath.section]];
    [cell setCellContentWithPurchaseInfo:purchaseDic];
    
    if ([self.selectList containsObject:@(indexPath.section)]) {
        cell.selectBtn.selected = YES;
    }else{
        cell.selectBtn.selected = NO;
    }
    return cell;
}
#pragma mark - CellDelegate
- (void)imageTapAction:(id)sender
{
    PurchaseOrderCell *cell = (PurchaseOrderCell *)sender;
    GoodsShowViewController *goodsShowVC = [[GoodsShowViewController alloc]init];
    goodsShowVC.vcType = PurchaseVC;
    goodsShowVC.dataList = self.purchaseList;
    goodsShowVC.index = cell.tag - CellTag;
    [self.navigationController pushViewController:goodsShowVC animated:YES];
    
    __weak typeof(self) weakSelf = self;
    goodsShowVC.selectGoodsIndex = ^(NSInteger index){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
        [weakSelf.theTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    };
}
- (void)goodsCountAdd:(id)sender
{
    PurchaseOrderCell *cell = (PurchaseOrderCell *)sender;
    NSInteger num = [cell.numText.text integerValue];
    if (num < 9999) {
        num = num+1;
    }
    cell.numText.text = [NSString stringWithFormat:@"%d",(int)num];
}
- (void)goodsCountCut:(id)sender
{
    PurchaseOrderCell *cell = (PurchaseOrderCell *)sender;
    NSInteger num = [cell.numText.text integerValue];
    if (num > 0) {
        num = num-1;
    }
    cell.numText.text = [NSString stringWithFormat:@"%d",(int)num];
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
        
        NSArray *titles = @[NSLocalizedString(@"批量采购", @"批量采购"),NSLocalizedString(@"批量订购", @"批量订购"),NSLocalizedString(@"批量缺货", @"批量缺货")];
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
