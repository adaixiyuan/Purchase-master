//
//  TaoBaoChildViewController.m
//  Purchase
//
//  Created by luoheng on 16/5/26.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "TaoBaoChildViewController.h"
#import "TaoBaoChildCell.h"
#import "GoodsShowViewController.h"

static const float RowHeight = 125;
static const NSInteger CellTag = 1000;

@interface TaoBaoChildViewController ()<UITableViewDelegate,UITableViewDataSource,CellDelegate,MWPhotoBrowserDelegate>

@property (nonatomic, strong) AutoTableView       *theTableView;

@property (nonatomic, assign) NSInteger           pageNum;
@property (nonatomic, strong) NSString            *goods_type;  // 1表示淘宝商品2表示系统商品3 表示实拍商品
@property (nonatomic, strong) NSMutableArray      *taobaoList; // 淘宝

@end

@implementation TaoBaoChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"淘宝信息", @"淘宝信息");
    [self.view addSubview:self.theTableView];
    
    self.goods_type = @"1";
    self.pageNum = 1;
    self.taobaoList = [[NSMutableArray alloc]init];
    // 获取记录列表
    [MYMBProgressHUD showHudWithMessage:NSLocalizedString(@"请稍等···", @"请稍等···") InView:self.view];
    [self getTaoBaoGoodsListRequest];
    
    __weak typeof(self) weakSelf = self;
    self.theTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageNum = 1;
        [weakSelf getTaoBaoGoodsListRequest];
    }];
    self.theTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageNum ++;
        [weakSelf getTaoBaoGoodsListRequest];
    }];
}
#pragma mark - Request
- (void)getTaoBaoGoodsListRequest
{
    NSMutableDictionary *parametersDic = [[NSMutableDictionary alloc]init];
    [parametersDic setObject:@"get" forKey:@"action"];
    [parametersDic setObject:SAFE_STRING(self.goods_type) forKey:@"type"];
    [parametersDic setObject:@(self.pageNum) forKey:@"page_no"];
    [parametersDic setObject:@(self.num_iid) forKey:@"num_iid"];
    
    [[NetworkManager sharedInstance] startRequestWithURL:kProductRequest method:RequestPost parameters:parametersDic result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.theTableView.mj_header endRefreshing];
        [self.theTableView.mj_footer endRefreshing];
        [MYMBProgressHUD hideHudFromView:self.view];
        NSArray *dataList = [[NSArray alloc]initWithArray:[responseObject objectForKey:@"data"]];
        if (self.pageNum == 1) {
            self.taobaoList = [[NSMutableArray alloc]initWithArray:dataList];
        }else{
            [self.taobaoList addObjectsFromArray:dataList];
        }
        [self.theTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (self.pageNum > 1) {
            self.pageNum--;
        }
        [self.theTableView.mj_header endRefreshing];
        [self.theTableView.mj_footer endRefreshing];
        [MYMBProgressHUD hideHudFromView:self.view];
        [MYMBProgressHUD showMessage:error.userInfo[@"NSLocalizedDescription"]];
    }];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.taobaoList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return RowHeight*SizeScaleHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    TaoBaoChildCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TaoBaoChildCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.tag = CellTag+indexPath.row;
    cell.theDelegate = self;
    
    NSDictionary *goodInfo = [[NSDictionary alloc]initWithDictionary:self.taobaoList[indexPath.row]];
    [cell setCellContentWithGoodsDic:goodInfo];
    return cell;
}
#pragma mark - CellDelegate
- (void)imageTapAction:(id)sender
{
    TaoBaoChildCell *cell = (TaoBaoChildCell *)sender;
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
    TaoBaoChildCell *cell = (TaoBaoChildCell *)sender;
    NSInteger row = cell.tag - CellTag;
    NSDictionary *goodsInfoDic = [[NSDictionary alloc]initWithDictionary:self.taobaoList[row]];
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
            [parametersDic setObject:SAFE_STRING(self.goods_type) forKey:@"type"];
            [parametersDic setObject:SAFE_STRING([[alertView textFieldAtIndex:0] text]) forKey:@"need_qty"];
            [parametersDic setObject:SAFE_STRING([[alertView textFieldAtIndex:1] text]) forKey:@"price"];
            [parametersDic setObject:@([[goodsInfoDic objectForKey:@"num_iid"] integerValue]) forKey:@"num_iid"];
            [parametersDic setObject:@([[goodsInfoDic objectForKey:@"sku_id"] integerValue]) forKey:@"sku_id"];
            
            [[NetworkManager sharedInstance] startRequestWithURL:kProductRequest method:RequestPost parameters:parametersDic result:^(AFHTTPRequestOperation *operation, id responseObject) {
                [MYMBProgressHUD hideHudFromView:self.view];
                weakSelf.pageNum = 1;
                [MYMBProgressHUD showMessage:SAFE_STRING([responseObject objectForKey:@"msg"])];
                [weakSelf getTaoBaoGoodsListRequest];
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
    return self.taobaoList.count;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    
    if (index < self.taobaoList.count) {
        NSDictionary *infoDic = [[NSDictionary alloc]initWithDictionary:[self.taobaoList objectAtIndex:index]];
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:SAFE_STRING([infoDic objectForKey:@"img_url"])]];
        photo.caption = SAFE_STRING([infoDic objectForKey:@"des"]);
        return photo;
    }
    return nil;
}
- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index
{
    NSDictionary *infoDic = [[NSDictionary alloc]initWithDictionary:[self.taobaoList objectAtIndex:index]];
    return SAFE_STRING([infoDic objectForKey:@"brand_name"]);
}
#pragma mark - Set && Get
- (UITableView *)theTableView
{
    if (_theTableView == nil) {
        _theTableView = [[AutoTableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
