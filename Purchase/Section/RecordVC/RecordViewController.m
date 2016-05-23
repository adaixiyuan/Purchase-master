//
//  RecordViewController.m
//  Purchase
//
//  Created by luoheng on 16/5/4.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "RecordViewController.h"
#import "SearchViewController.h"
#import "RecordViewCell.h"
#import "GoodsShowViewController.h"
#import "SearchInfoModel.h"

static const float TopHeight = 40;
static const float RowHeight = 100;
static const float BootomHeight = 45;
static const NSInteger TopTag = 100;
static const NSInteger BottomTag = 200;
static const NSInteger CellTag = 1000;

@interface RecordViewController ()<UITableViewDelegate,UITableViewDataSource,MGSwipeTableCellDelegate,CellDelegate,MWPhotoBrowserDelegate>

@property (nonatomic, strong) AutoTableView       *theTableView;
@property (nonatomic, strong) UIButton            *editButton;
@property (nonatomic, strong) UIView              *topView;
@property (nonatomic, strong) UIView              *animateView;
@property (nonatomic, strong) UIView              *bottomView;
@property (nonatomic, assign) BOOL                isEdit;
@property (nonatomic, assign) NSInteger           pageNum_one;
@property (nonatomic, assign) NSInteger           pageNum_two;
@property (nonatomic, strong) NSString            *record_type;  // 1表示采购记录， 2表示订货记录
@property (nonatomic, strong) NSMutableArray      *purchaseList; // 采购
@property (nonatomic, strong) NSMutableArray      *bookList;    // 订货

@property (nonatomic, strong) NSArray             *goodsList;   // 照片浏览器

@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"记录", @"记录");
    
    self.isEdit = NO;
    self.record_type = @"1";
    // 创建导航栏右边按钮
    [self creatRightNavView];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.theTableView];
    [self.view addSubview:self.bottomView];
    
    self.pageNum_one = 1;
    self.pageNum_two = 1;
    self.purchaseList = [[NSMutableArray alloc]init];
    self.bookList = [[NSMutableArray alloc]init];
    // 获取记录列表
    [MYMBProgressHUD showHudWithMessage:NSLocalizedString(@"请稍等···", @"请稍等···") InView:self.view];
    [self getBuyRecordListRequest];
    
    __weak typeof(self) weakSelf = self;
    self.theTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if ([weakSelf.record_type integerValue] == 1) {
            weakSelf.pageNum_one = 1;
        }else{
            weakSelf.pageNum_two = 1;
        }
        [weakSelf getBuyRecordListRequest];
    }];
    self.theTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if ([weakSelf.record_type integerValue] == 1) {
            weakSelf.pageNum_one ++;
        }else{
            weakSelf.pageNum_two ++;
        }
        [weakSelf getBuyRecordListRequest];
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
    [self.editButton setTitle:NSLocalizedString(@"编辑", @"编辑") forState:UIControlStateNormal];
    [self.editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.editButton.titleLabel.font = [UIFont customFontOfSize:14];
    [self.editButton addTarget:self action:@selector(navEditAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:self.editButton];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:rightView] animated:YES];
}
#pragma mark - Event
- (void)navSearchAction:(UIButton *)btn
{
    if (self.isEdit == YES) {
        [self navEditAction:self.editButton];
    }
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    
    [SearchInfoModel shareInstance].fromType = FromRecordVC;
    [SearchInfoModel shareInstance].typeID = self.record_type;
    [SearchInfoModel shareInstance].typeList = @[@"采购记录",@"订货记录"];
    [SearchInfoModel shareInstance].domain = @"BuyRecord";
    [SearchInfoModel shareInstance].typeName = [[SearchInfoModel shareInstance].typeList objectAtIndex:[self.record_type integerValue]-1];
    
    [self.navigationController pushViewController:searchVC animated:YES];
    __weak typeof(self) weakSelf = self;
    searchVC.beginSearchWithTheKey = ^(NSString *des,NSString *brand,NSString *type, NSString *date, NSString *location){
        
        UIButton *button = (UIButton *)[weakSelf.topView viewWithTag:[type integerValue]+TopTag-1];
        [weakSelf typeSwitch:button];
    };
}
- (void)navEditAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    self.isEdit = btn.selected;
    
    __weak typeof(self) weakSelf = self;
    if (self.isEdit == YES) {
        [self.editButton setTitle:NSLocalizedString(@"取消", @"取消") forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.bottomView.frame = CGRectMake(0, ScreenHeight-64-BootomHeight*SizeScaleHeight, ScreenWidth, BootomHeight*SizeScaleHeight);
            weakSelf.theTableView.frame = CGRectMake(0, TopHeight*SizeScaleHeight, ScreenWidth, ScreenHeight-64-TopHeight*SizeScaleHeight-BootomHeight*SizeScaleHeight);
        }];
    }else{
        [self.editButton setTitle:NSLocalizedString(@"编辑", @"编辑") forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.bottomView.frame = CGRectMake(0, ScreenHeight-64, ScreenWidth, BootomHeight*SizeScaleHeight);
            weakSelf.theTableView.frame = CGRectMake(0, TopHeight*SizeScaleHeight, ScreenWidth, ScreenHeight-64-TopHeight*SizeScaleHeight);
        }];
    }
    [self.theTableView reloadData];
}
- (void)typeSwitch:(UIButton *)btn
{
    for(int i = TopTag ; i < TopTag+2; i++){
        UIButton *button = (UIButton *)[self.topView viewWithTag:i];
        [button setTitleColor:SHALLOWGRAY forState:UIControlStateNormal];
    }
    [btn setTitleColor:NAVBARCOLOR forState:UIControlStateNormal];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.animateView.frame = CGRectMake(ScreenWidth/2*(btn.tag-TopTag), CGRectGetHeight(self.topView.frame)-2, ScreenWidth/2, 2);
    }];
    
    self.record_type = [NSString stringWithFormat:@"%d",(int)(btn.tag-TopTag+1)];
    self.pageNum_one = 1;
    self.pageNum_two = 1;
    [self.theTableView reloadData];
    [self getBuyRecordListRequest];
}
- (void)buttonAction:(UIButton *)btn
{
    
}
#pragma mark - Request
- (void)getBuyRecordListRequest
{
    NSInteger pageNum;
    if ([self.record_type integerValue]== 1) {
        pageNum = self.pageNum_one;
    }else{
        pageNum = self.pageNum_two;
    }
    NSMutableDictionary *parametersDic = [[NSMutableDictionary alloc]init];
    [parametersDic setObject:@"get" forKey:@"action"];
    [parametersDic setObject:@([UserInfoModel shareInstance].user_sid) forKey:@"user_sid"];
    [parametersDic setObject:SAFE_STRING(self.record_type) forKey:@"type"];
    [parametersDic setObject:@(pageNum) forKey:@"page_no"];
    [parametersDic setObject:SAFE_STRING([SearchInfoModel shareInstance].keyStr) forKey:@"des"];
    [parametersDic setObject:SAFE_STRING([SearchInfoModel shareInstance].dateStr) forKey:@"date"];
    [parametersDic setObject:SAFE_STRING([SearchInfoModel shareInstance].brandName) forKey:@"brand_name"];
    
    [[NetworkManager sharedInstance] startRequestWithURL:kBuyRecordRequest method:RequestPost parameters:parametersDic result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.theTableView.mj_header endRefreshing];
        [self.theTableView.mj_footer endRefreshingWithNoMoreData];
        [MYMBProgressHUD hideHudFromView:self.view];
        NSArray *dataList = [[NSArray alloc]initWithArray:[responseObject objectForKey:@"data"]];
        if ([self.record_type integerValue] == 1) {
            if (self.pageNum_one == 1) {
                self.purchaseList = [[NSMutableArray alloc]initWithArray:dataList];
            }else{
                [self.purchaseList addObjectsFromArray:dataList];
            }
        }else{
            if (self.pageNum_two == 1) {
                self.bookList = [[NSMutableArray alloc]initWithArray:dataList];
            }else{
                [self.bookList addObjectsFromArray:dataList];
            }
        }
        [self.theTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([self.record_type integerValue] == 1 && self.pageNum_one > 1) {
            self.pageNum_one--;
        }else if([self.record_type integerValue] == 2 && self.pageNum_two > 1){
            self.pageNum_two--;
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
    if ([self.record_type integerValue] == 1) {
        return self.purchaseList.count;
    }else{
        return self.bookList.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return RowHeight*SizeScaleHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"cell%d%d",(int)indexPath.section,(int)indexPath.row];
    RecordViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[RecordViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.delegate = self;
    cell.theDelegate = self;
    cell.tag = CellTag+indexPath.row;
    [cell setCellContentConstraintsWithStatus:self.isEdit];
    
    NSDictionary *recordDic = [[NSDictionary alloc]init];
    if ([self.record_type integerValue] == 1) {
        recordDic = [[NSDictionary alloc]initWithDictionary:self.purchaseList[indexPath.row]];
    }else{
        recordDic = [[NSDictionary alloc]initWithDictionary:self.bookList[indexPath.row]];
    }
    [cell setCellContentWithDataDic:recordDic];
    return cell;
}
#pragma mark - MGSwipeTableCellDelegate
- (BOOL)swipeTableCell:(MGSwipeTableCell*)cell canSwipe:(MGSwipeDirection)direction
{
    if (self.isEdit == NO) {
        return YES;
    }else{
        return NO;
    }
}
-(BOOL) swipeTableCell:(MGSwipeTableCell*)cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion
{
    NSLog(@"-----------%ld",index);
    return YES;
}
#pragma mark - CellDelegate
- (void)imageTapAction:(id)sender
{
    RecordViewCell *cell = (RecordViewCell *)sender;
    self.goodsList = [[NSArray alloc]init];
    if ([self.record_type integerValue] == 1) {
        self.goodsList = [[NSArray alloc]initWithArray:self.purchaseList];
    }else{
        self.goodsList = [[NSArray alloc]initWithArray:self.bookList];
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
#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.goodsList.count;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    
    if (index < self.goodsList.count) {
        NSDictionary *infoDic = [[NSDictionary alloc]initWithDictionary:[self.goodsList objectAtIndex:index]];
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:SAFE_STRING([infoDic objectForKey:@"imgUrl"])]];
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
        
        NSArray *titles = @[NSLocalizedString(@"采购", @"采购"),NSLocalizedString(@"订货", @"订货")];
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
            }
        }
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = separateLineColor;
        [_topView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topView).with.offset(10);
            make.left.equalTo(_topView).with.offset(ScreenWidth/2);
            make.bottom.equalTo(_topView).with.offset(-10);
            make.width.equalTo(@(HalfScale));
        }];
        UIView *bottomLine = [[UIView alloc]init];
        bottomLine.backgroundColor = separateLineColor;
        [_topView addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_topView).with.offset(0);
            make.bottom.equalTo(_topView).with.offset(0);
            make.right.equalTo(_topView).with.offset(0);
            make.height.equalTo(@(HalfScale));
        }];
        _animateView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_topView.frame)-2, ScreenWidth/2, 2)];
        _animateView.backgroundColor = NAVBARCOLOR;
        [_topView addSubview:_animateView];
    }
    return _topView;
}
- (AutoTableView *)theTableView
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
- (UIView *)bottomView
{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-64, ScreenWidth, BootomHeight*SizeScaleHeight)];
        _bottomView.backgroundColor = NAVBARCOLOR;
        
        NSArray *titles = @[NSLocalizedString(@"全选", @"全选"),NSLocalizedString(@"删除", @"删除"),NSLocalizedString(@"更新", @"更新")];
        for (int i = 0; i < titles.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(15+ScreenWidth/titles.count*i, 0, ScreenWidth/titles.count-30, BootomHeight*SizeScaleHeight);
            button.backgroundColor = [UIColor clearColor];
            [button setTitle:titles[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont customFontOfSize:14];
            button.tag = BottomTag+i;
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [_bottomView addSubview:button];
            if (i == 0) {
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            }else if (i == 2){
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            }
        }
    }
    return _bottomView;
}
@end
