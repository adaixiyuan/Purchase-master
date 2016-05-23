//
//  HomePageViewController.m
//  Purchase
//
//  Created by luoheng on 16/5/2.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "HomePageViewController.h"
#import "HomePageCell.h"
#import "GoodsShowViewController.h"
#import "AddKeyNoteViewController.h"

static const float RowHeight = 100;
static const NSInteger CellTag = 1000;

@interface HomePageViewController ()<UITableViewDelegate,UITableViewDataSource,CellDelegate,MWPhotoBrowserDelegate>

@property (nonatomic, strong) UITableView    *theTableView;
@property (nonatomic, strong) NSMutableArray *keyNoteList;
@property (nonatomic, assign) NSInteger      pageNum;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"首页", @"首页");
    [self.view addSubview:self.theTableView];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    rightBtn.backgroundColor = [UIColor clearColor];
    [rightBtn setImage:[UIImage imageNamed:@"add_icon"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(addkeyNoteAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:rightBtn] animated:YES];
    
    self.pageNum = 1;
    self.keyNoteList = [[NSMutableArray alloc]init];
    // 获取今日重点内容
    [MYMBProgressHUD showHudWithMessage:NSLocalizedString(@"请稍等···", @"请稍等···") InView:self.view];
    [self getTheKeyNoteRequest];
    
    __weak typeof(self) weakSelf = self;
    self.theTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
         weakSelf.pageNum = 1;
        [weakSelf getTheKeyNoteRequest];
    }];
    self.theTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
         weakSelf.pageNum ++;
        [weakSelf getTheKeyNoteRequest];
    }];
}
#pragma mark - Event
- (void)addkeyNoteAction:(UIButton *)btn
{
    __weak typeof(self) weakSelf = self;
    AddKeyNoteViewController *addKeyNoteVC = [[AddKeyNoteViewController alloc]init];
    [self.navigationController pushViewController:addKeyNoteVC animated:YES];
    addKeyNoteVC.updataKeyNote = ^(){
        [weakSelf getTheKeyNoteRequest];
    };
}
#pragma mark - Request
- (void)getTheKeyNoteRequest
{
    NSMutableDictionary *parametersDic = [[NSMutableDictionary alloc]init];
    [parametersDic setObject:@"get" forKey:@"action"];
    [parametersDic setObject:@([UserInfoModel shareInstance].user_sid) forKey:@"user_sid"];
    [parametersDic setObject:SAFE_STRING([NSDate getCurrentStrDate]) forKey:@"date"];
    [parametersDic setObject:@(self.pageNum) forKey:@"page_no"];
    
    [[NetworkManager sharedInstance] startRequestWithURL:kKeyNoteRequest method:RequestPost parameters:parametersDic result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.theTableView.mj_header endRefreshing];
        [self.theTableView.mj_footer endRefreshingWithNoMoreData];
        [MYMBProgressHUD hideHudFromView:self.view];
        NSArray *dataList = [[NSArray alloc]initWithArray:[responseObject objectForKey:@"data"]];
        if (self.pageNum == 1){
            self.keyNoteList = [[NSMutableArray alloc]initWithArray:dataList];
        }else{
            [self.keyNoteList addObjectsFromArray:dataList];
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35*SizeScaleHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *sectionHeadIdentifier = @"sectionHeadIdentifier";
    UITableViewHeaderFooterView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionHeadIdentifier];
    if (!headView) {
        headView = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:sectionHeadIdentifier];
        headView.contentView.backgroundColor = [UIColor clearColor];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = SHALLOWBLACK;
        titleLabel.font = [UIFont customFontOfSize:14];
        titleLabel.text = NSLocalizedString(@"今日重点", @"今日重点");
        [headView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headView).with.offset(0);
            make.left.equalTo(headView).with.offset(15);
        }];
    }
    return headView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.keyNoteList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return RowHeight*SizeScaleHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    HomePageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HomePageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.theDelegate = self;
    cell.tag = CellTag + indexPath.row;
    NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:self.keyNoteList[indexPath.row]];
    [cell setCellContentWithDic:dic];
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [MYMBProgressHUD showHudWithMessage:@"正在删除···" InView:self.view];
        NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:self.keyNoteList[indexPath.row]];
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
        [parameters setObject:@"delete" forKey:@"action"];
        [parameters setObject:@([UserInfoModel shareInstance].user_sid) forKey:@"user_sid"];
        [parameters setObject:@([[dic objectForKey:@"sid"] integerValue]) forKey:@"sid"];
        [[NetworkManager sharedInstance] startRequestWithURL:kKeyNoteRequest method:RequestPost parameters:parameters result:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MYMBProgressHUD hideHudFromView:self.view];
            [self.keyNoteList removeObject:dic];
            [self.theTableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MYMBProgressHUD hideHudFromView:self.view];
            [MYMBProgressHUD showMessage:error.userInfo[@"NSLocalizedDescription"]];
        }];
    }
}
#pragma mark - CellDelegate
- (void)imageTapAction:(id)sender
{
    HomePageCell *cell = (HomePageCell *)sender;
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
    return self.keyNoteList.count;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    
    if (index < self.keyNoteList.count) {
        NSDictionary *infoDic = [[NSDictionary alloc]initWithDictionary:[self.keyNoteList objectAtIndex:index]];
        NSString *urls = SAFE_STRING([infoDic objectForKey:@"img_urls"]);
        NSArray *urls_list = [urls componentsSeparatedByString:@","];
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:SAFE_STRING([urls_list firstObject])]];
        photo.caption = SAFE_STRING([infoDic objectForKey:@"content"]);
        return photo;
    }
    return nil;
}
- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index
{
    NSDictionary *infoDic = [[NSDictionary alloc]initWithDictionary:[self.keyNoteList objectAtIndex:index]];
    return SAFE_STRING([infoDic objectForKey:@"title"]);
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
