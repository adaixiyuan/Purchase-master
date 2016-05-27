//
//  GoodsInfoViewController.m
//  Purchase
//
//  Created by luoheng on 16/5/4.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "GoodsInfoViewController.h"
#import "GoodsInfoCell.h"
#import "SearchViewController.h"
#import "GoodsShowViewController.h"
#import "SearchInfoModel.h"
#import "TaoBaoChildViewController.h"

static const float RowHeight = 125;
static const float TopHeight = 40;
static const NSInteger TopTag = 100;
static const NSInteger CellTag = 1000;

@interface GoodsInfoViewController ()<UITableViewDelegate,UITableViewDataSource,CellDelegate,MWPhotoBrowserDelegate>

@property (nonatomic, strong) AutoTableView       *theTableView;
@property (nonatomic, strong) UIView              *topView;
@property (nonatomic, strong) UIView              *animateView;
@property (nonatomic, strong) UIView              *bottomView;

@property (nonatomic, assign) NSInteger           pageNum_one;
@property (nonatomic, assign) NSInteger           pageNum_two;
@property (nonatomic, assign) NSInteger           pageNum_three;
@property (nonatomic, strong) NSString            *goods_type;  // 1表示淘宝商品2表示系统商品3 表示实拍商品
@property (nonatomic, strong) NSMutableArray      *taobaoList; // 淘宝
@property (nonatomic, strong) NSMutableArray      *systemList; // 系统
@property (nonatomic, strong) NSMutableArray      *livePhotosList; // 实拍

@property (nonatomic, strong) NSArray             *goodsList;

@end

@implementation GoodsInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"商品信息", @"商品信息");
    [self.view addSubview:self.topView];
    [self.view addSubview:self.theTableView];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_search"] style:UIBarButtonItemStylePlain target:self action:@selector(navSearchAction:)];
    [self.navigationItem setRightBarButtonItem:rightItem animated:YES];
    
    self.goods_type = @"1";
    self.pageNum_one = 1;
    self.pageNum_two = 1;
    self.pageNum_three = 1;
    self.taobaoList = [[NSMutableArray alloc]init];
    self.systemList = [[NSMutableArray alloc]init];
    self.livePhotosList = [[NSMutableArray alloc]init];
    // 获取记录列表
    [MYMBProgressHUD showHudWithMessage:NSLocalizedString(@"请稍等···", @"请稍等···") InView:self.view];
    [self getGoodsListRequest];
    
    __weak typeof(self) weakSelf = self;
    self.theTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if ([weakSelf.goods_type integerValue] == 1) {
            weakSelf.pageNum_one = 1;
        }else if ([weakSelf.goods_type integerValue] == 2){
            weakSelf.pageNum_two = 1;
        }else{
            weakSelf.pageNum_three = 1;
        }
        [weakSelf getGoodsListRequest];
    }];
    self.theTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if ([weakSelf.goods_type integerValue] == 1) {
            weakSelf.pageNum_one ++;
        }else if ([weakSelf.goods_type integerValue] == 2){
            weakSelf.pageNum_two ++;
        }else{
            weakSelf.pageNum_three ++;
        }
        [weakSelf getGoodsListRequest];
    }];
}
#pragma mark - Event
- (void)navSearchAction:(UIButton *)btn
{
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    
    [SearchInfoModel shareInstance].fromType = FromGoodsInfoVC;
    [SearchInfoModel shareInstance].typeID = self.goods_type;
    [SearchInfoModel shareInstance].typeList = @[NSLocalizedString(@"淘宝商品", @"淘宝商品"),NSLocalizedString(@"系统商品", @"系统商品"),NSLocalizedString(@"实拍商品", @"实拍商品")];
    [SearchInfoModel shareInstance].domain = @"Product";
    [SearchInfoModel shareInstance].typeName = [[SearchInfoModel shareInstance].typeList objectAtIndex:[self.goods_type integerValue]-1];
    
    [self.navigationController pushViewController:searchVC animated:YES];
    __weak typeof(self) weakSelf = self;
    searchVC.beginSearchWithTheKey = ^(NSString *des,NSString *brand,NSString *type, NSString *date, NSString *location){
        UIButton *button = (UIButton *)[weakSelf.topView viewWithTag:[type integerValue]+TopTag-1];
        [weakSelf typeSwitch:button];
    };
}
- (void)typeSwitch:(UIButton *)btn
{
    for(int i = TopTag ; i < TopTag+3; i++){
        UIButton *button = (UIButton *)[self.topView viewWithTag:i];
        [button setTitleColor:SHALLOWGRAY forState:UIControlStateNormal];
    }
    [btn setTitleColor:NAVBARCOLOR forState:UIControlStateNormal];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.animateView.frame = CGRectMake(ScreenWidth/3*(btn.tag-TopTag), CGRectGetHeight(weakSelf.topView.frame)-2, ScreenWidth/3, 2);
    }];
    
    self.goods_type = [NSString stringWithFormat:@"%d",(int)(btn.tag-TopTag+1)];
    self.pageNum_one = 1;
    self.pageNum_two = 1;
    self.pageNum_three = 1;
    [self.theTableView reloadData];
    [MYMBProgressHUD showHudWithMessage:NSLocalizedString(@"请稍等···", @"请稍等···") InView:self.view];
    [self getGoodsListRequest];
}
#pragma mark - Request
- (void)getGoodsListRequest
{
    NSInteger pageNum;
    if ([self.goods_type integerValue] == 1) {
        pageNum = self.pageNum_one;
    }else if ([self.goods_type integerValue] == 2){
        pageNum = self.pageNum_two;
    }else{
        pageNum = self.pageNum_three;
    }
    NSMutableDictionary *parametersDic = [[NSMutableDictionary alloc]init];
    [parametersDic setObject:@"get" forKey:@"action"];
    [parametersDic setObject:@([UserInfoModel shareInstance].user_sid) forKey:@"user_sid"];
    [parametersDic setObject:SAFE_STRING(self.goods_type) forKey:@"type"];
    [parametersDic setObject:@(pageNum) forKey:@"page_no"];
    [parametersDic setObject:SAFE_STRING([SearchInfoModel shareInstance].keyStr) forKey:@"des"];
    [parametersDic setObject:SAFE_STRING([SearchInfoModel shareInstance].dateStr) forKey:@"date"];
    [parametersDic setObject:SAFE_STRING([SearchInfoModel shareInstance].brandName) forKey:@"brand_name"];
    
    [[NetworkManager sharedInstance] startRequestWithURL:kProductRequest method:RequestPost parameters:parametersDic result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.theTableView.mj_header endRefreshing];
        [self.theTableView.mj_footer endRefreshingWithNoMoreData];
        [MYMBProgressHUD hideHudFromView:self.view];
        NSArray *dataList = [[NSArray alloc]initWithArray:[responseObject objectForKey:@"data"]];
        switch ([self.goods_type integerValue]) {
            case 1:{
                if (self.pageNum_one == 1) {
                    self.taobaoList = [[NSMutableArray alloc]initWithArray:dataList];
                }else{
                    [self.taobaoList addObjectsFromArray:dataList];
                }
            }
                break;
            case 2:{
                if (self.pageNum_two == 1) {
                    self.systemList = [[NSMutableArray alloc]initWithArray:dataList];
                }else{
                    [self.systemList addObjectsFromArray:dataList];
                }
            }
                break;
            case 3:{
                if (self.pageNum_three == 1) {
                    self.livePhotosList = [[NSMutableArray alloc]initWithArray:dataList];
                }else{
                    [self.livePhotosList addObjectsFromArray:dataList];
                }
            }
                break;
            default:
                break;
        }
        [self.theTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([self.goods_type integerValue] == 1 && self.pageNum_one > 1) {
            self.pageNum_one--;
        }else if([self.goods_type integerValue] == 2 && self.pageNum_two > 1){
            self.pageNum_two--;
        }else if ([self.goods_type integerValue] == 3 && self.pageNum_three > 1){
            self.pageNum_three--;
        }
        [self.theTableView.mj_header endRefreshing];
        [self.theTableView.mj_footer endRefreshingWithNoMoreData];
        [MYMBProgressHUD hideHudFromView:self.view];
        [MYMBProgressHUD showMessage:error.userInfo[@"NSLocalizedDescription"]];
    }];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.goods_type integerValue] == 1) {
        return self.taobaoList.count;
    }else if ([self.goods_type integerValue] == 2){
        return self.systemList.count;
    }else{
        return self.livePhotosList.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return RowHeight*SizeScaleHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    GoodsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GoodsInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.tag = CellTag+indexPath.row;
    cell.theDelegate = self;
    
    NSDictionary *goodInfo = [[NSDictionary alloc]init];
    if ([self.goods_type integerValue] == 1) {
        goodInfo = [[NSDictionary alloc]initWithDictionary:self.taobaoList[indexPath.row]];
    }else if ([self.goods_type integerValue] == 2){
        goodInfo = [[NSDictionary alloc]initWithDictionary:self.systemList[indexPath.row]];
    }else{
        goodInfo = [[NSDictionary alloc]initWithDictionary:self.livePhotosList[indexPath.row]];
    }
    [cell setCellContentWithGoodsDic:goodInfo];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.goods_type integerValue] == 1) {
        NSDictionary *goodsInfoDic = [[NSDictionary alloc]initWithDictionary:self.taobaoList[indexPath.row]];
        if ([SAFE_NUMBER([goodsInfoDic objectForKey:@"has_child"]) integerValue] == 1) {
            TaoBaoChildViewController *taobaoChildVC = [[TaoBaoChildViewController alloc]init];
            taobaoChildVC.num_iid = [[goodsInfoDic objectForKey:@"num_iid"] integerValue];
            [self.navigationController pushViewController:taobaoChildVC animated:YES];
        }
    }
}
#pragma mark - CellDelegate
- (void)imageTapAction:(id)sender
{
    GoodsInfoCell *cell = (GoodsInfoCell *)sender;
    self.goodsList = [[NSArray alloc]init];
    if ([self.goods_type integerValue] == 1) {
        self.goodsList = [[NSArray alloc]initWithArray:self.taobaoList];
    }else if ([self.goods_type integerValue] == 2){
        self.goodsList = [[NSArray alloc]initWithArray:self.systemList];
    }else{
        self.goodsList = [[NSArray alloc]initWithArray:self.livePhotosList];
    }
    GoodsShowViewController *goodsShowVC = [[GoodsShowViewController alloc]initWithDelegate:self];
    [goodsShowVC setCurrentPhotoIndex:cell.tag - CellTag];
    [self.navigationController pushViewController:goodsShowVC animated:YES];
    __weak typeof(self) weakSelf = self;
    goodsShowVC.selectGoodsIndex = ^(NSInteger index){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [weakSelf.theTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    };
}
- (void)addCartToPurchase:(id)sender
{
    if([[UserInfoModel shareInstance].role isEqualToString:@"buyer"]){
        [MYMBProgressHUD showMessage:NSLocalizedString(@"采购员暂无此权限！", @"采购员暂无此权限！")];
        return;
    }
    GoodsInfoCell *cell = (GoodsInfoCell *)sender;
    NSInteger row = cell.tag - CellTag;
    NSDictionary *goodsInfoDic;
    if ([self.goods_type integerValue] == 1) {
        goodsInfoDic = [[NSDictionary alloc]initWithDictionary:self.taobaoList[row]];
    }else if ([self.goods_type integerValue] == 2){
        goodsInfoDic = [[NSDictionary alloc]initWithDictionary:self.systemList[row]];
    }else{
        goodsInfoDic = [[NSDictionary alloc]initWithDictionary:self.livePhotosList[row]];
    }
    __weak typeof(self) weakSelf = self;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                   message:NSLocalizedString(@"请输入商品个数与价格", @"请输入商品个数与价格")
                                                  delegate:self
                                         cancelButtonTitle:NSLocalizedString(@"取消", @"取消")
                                         otherButtonTitles:NSLocalizedString(@"确定", @"确定"), nil];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    alert.tapBlock = ^(UIAlertView *alertView, NSInteger buttonIndex) {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        if (buttonIndex == 1) {
            [MYMBProgressHUD showHudWithMessage:NSLocalizedString(@"请稍等···", @"请稍等···") InView:weakSelf.view];
            NSMutableDictionary *parametersDic = [[NSMutableDictionary alloc]init];
            [parametersDic setObject:@"publish" forKey:@"action"];
            [parametersDic setObject:@([UserInfoModel shareInstance].user_sid) forKey:@"user_sid"];
            [parametersDic setObject:SAFE_STRING(weakSelf.goods_type) forKey:@"type"];
            [parametersDic setObject:SAFE_STRING([[alertView textFieldAtIndex:0] text]) forKey:@"need_qty"];
            [parametersDic setObject:SAFE_STRING([[alertView textFieldAtIndex:1] text]) forKey:@"price"];
            if([weakSelf.goods_type integerValue] == 1){
                [parametersDic setObject:@([[goodsInfoDic objectForKey:@"num_iid"] integerValue]) forKey:@"num_iid"];
            }else if ([weakSelf.goods_type integerValue] == 2){
                [parametersDic setObject:@([[goodsInfoDic objectForKey:@"sid"] integerValue]) forKey:@"goods_sid"];
            }else if ([weakSelf.goods_type integerValue] == 3){
                [parametersDic setObject:SAFE_NUMBER([goodsInfoDic objectForKey:@"sid"]) forKey:@"live_sid"];
                [parametersDic setObject:@"true" forKey:@"is_Live_Public"];
            }
            [[NetworkManager sharedInstance] startRequestWithURL:kProductRequest method:RequestPost parameters:parametersDic result:^(AFHTTPRequestOperation *operation, id responseObject) {
                [MYMBProgressHUD hideHudFromView:self.view];
                if ([weakSelf.goods_type integerValue] == 1){
                    weakSelf.pageNum_one = 1;
                }else if ([weakSelf.goods_type integerValue] == 2){
                    weakSelf.pageNum_two = 1;
                }else{
                    weakSelf.pageNum_three = 1;
                }
                [MYMBProgressHUD showMessage:SAFE_STRING([responseObject objectForKey:@"msg"])];
                [weakSelf getGoodsListRequest];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [MYMBProgressHUD hideHudFromView:weakSelf.view];
                [MYMBProgressHUD showMessage:error.userInfo[@"NSLocalizedDescription"]];
            }];
        }
    };
    alert.shouldEnableFirstOtherButtonBlock = ^BOOL(UIAlertView *alertView) {
        [alertView textFieldAtIndex:0].placeholder = NSLocalizedString(@"请输入商品个数", @"请输入商品个数");
        [alertView textFieldAtIndex:1].placeholder = NSLocalizedString(@"请输入商品价格", @"请输入商品价格");
        [alertView textFieldAtIndex:1].secureTextEntry = NO;
        [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
        [alertView textFieldAtIndex:1].keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        return ([alertView textFieldAtIndex:0].text.length > 0 && [NSString isPureInt:[alertView textFieldAtIndex:0].text] && [alertView textFieldAtIndex:1].text.length > 0 && ([NSString isPureFloat:[alertView textFieldAtIndex:1].text] || [NSString isPureInt:[alertView textFieldAtIndex:1].text]));
    };
    [alert show];
}
#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.goodsList.count;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    
    if (index < self.goodsList.count) {
        NSDictionary *infoDic = [[NSDictionary alloc]initWithDictionary:[self.goodsList objectAtIndex:index]];
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:SAFE_STRING([infoDic objectForKey:@"img_url"])]];
        photo.caption = SAFE_STRING([infoDic objectForKey:@"des"]);
        return photo;
    }
    return nil;
}
- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index
{
    NSDictionary *infoDic = [[NSDictionary alloc]initWithDictionary:[self.goodsList objectAtIndex:index]];
    return SAFE_STRING([infoDic objectForKey:@"brand_name"]);
}
#pragma mark - Set && Get
- (UIView *)topView
{
    if (_topView == nil) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, TopHeight*SizeScaleHeight-5)];
        _topView.backgroundColor = [UIColor whiteColor];
        
        NSArray *titles = @[NSLocalizedString(@"淘宝", @"淘宝"),NSLocalizedString(@"系统", @"系统"),NSLocalizedString(@"实拍", @"实拍")];
        for (int i = 0; i < titles.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(ScreenWidth/titles.count*i, 0, ScreenWidth/titles.count, CGRectGetHeight(_topView.frame));
            [button setTitle:titles[i] forState:UIControlStateNormal];
            [button setTitleColor:SHALLOWGRAY forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont customFontOfSize:16];
            button.tag = TopTag+i;
            [button addTarget:self action:@selector(typeSwitch:) forControlEvents:UIControlEventTouchUpInside];
            [_topView addSubview:button];
            if (i == 0) {
                [button setTitleColor:NAVBARCOLOR forState:UIControlStateNormal];
            }else{
                UIView *line = [[UIView alloc]init];
                line.backgroundColor = separateLineColor;
                [_topView addSubview:line];
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(_topView).with.offset(10);
                    make.left.equalTo(_topView).with.offset(ScreenWidth/titles.count*i);
                    make.bottom.equalTo(_topView).with.offset(-10);
                    make.width.equalTo(@(HalfScale));
                }];
            }
        }
        UIView *bottomLine = [[UIView alloc]init];
        bottomLine.backgroundColor = separateLineColor;
        [_topView addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_topView).with.offset(0);
            make.bottom.equalTo(_topView).with.offset(0);
            make.right.equalTo(_topView).with.offset(0);
            make.height.equalTo(@(HalfScale));
        }];
        _animateView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_topView.frame)-2, ScreenWidth/titles.count, 2)];
        _animateView.backgroundColor = NAVBARCOLOR;
        [_topView addSubview:_animateView];
    }
    return _topView;
}
- (UITableView *)theTableView
{
    if (_theTableView == nil) {
        _theTableView = [[AutoTableView alloc]initWithFrame:CGRectMake(0, TopHeight*SizeScaleHeight, ScreenWidth, ScreenHeight-64-TopHeight*SizeScaleHeight) style:UITableViewStylePlain];
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

@end
