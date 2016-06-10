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
#import "UpdateKeyNoteViewController.h"

static const float RowHeight = 100;
static const NSInteger CellTag = 1000;
static const float BootomHeight = 45;
static const NSInteger BottomTag = 100;

@interface HomePageViewController ()<UITableViewDelegate,UITableViewDataSource,CellDelegate,MWPhotoBrowserDelegate>

@property (nonatomic, strong) UITableView    *theTableView;
@property (nonatomic, strong) UIButton       *editButton;
@property (nonatomic, strong) UIView         *bottomView;
@property (nonatomic, strong) NSMutableArray *keyNoteList;
@property (nonatomic, assign) NSInteger      pageNum;
@property (nonatomic, strong) NSMutableArray *selectList;
@property (nonatomic, assign) BOOL           isEdit;

@end

@implementation HomePageViewController
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.isEdit = YES;
    [self navEditAction:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSInternationalString(@"首页", @"首页");
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.theTableView];
    [self creatRightNavView];
    
    self.isEdit = NO;
    self.pageNum = 1;
    self.keyNoteList = [[NSMutableArray alloc]init];
    self.selectList = [[NSMutableArray alloc]init];
    // 获取今日重点内容
    [MYMBProgressHUD showHudWithMessage:NSInternationalString(@"请稍等···", @"请稍等···") InView:self.view];
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
- (void)creatRightNavView
{
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 95, 40)];
    rightView.backgroundColor = [UIColor clearColor];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 40, 40);
    addButton.backgroundColor = [UIColor clearColor];
    [addButton setImage:[UIImage imageNamed:@"add_icon"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addkeyNoteAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:addButton];
    
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editButton.frame = CGRectMake(45, 0, 50, 40);
    self.editButton.backgroundColor = [UIColor clearColor];
    [self.editButton setTitle:NSInternationalString(@"编辑", @"编辑") forState:UIControlStateNormal];
    [self.editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.editButton.titleLabel.font = [UIFont customFontOfSize:13];
    [self.editButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self.editButton addTarget:self action:@selector(navEditAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:self.editButton];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:rightView] animated:YES];
}
#pragma mark - Event
- (void)addkeyNoteAction:(UIButton *)btn
{
    AddKeyNoteViewController *addKeyNoteVC = [[AddKeyNoteViewController alloc]init];
    [self.navigationController pushViewController:addKeyNoteVC animated:YES];
    __weak typeof(self) weakSelf = self;
    addKeyNoteVC.updataKeyNote = ^(){
        [weakSelf getTheKeyNoteRequest];
    };
}
- (void)navEditAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    self.isEdit = !self.isEdit;
    self.selectList = [[NSMutableArray alloc]init];
    
    __weak typeof(self) weakSelf = self;
    if (self.isEdit == YES) {
        [self.editButton setTitle:NSInternationalString(@"取消", @"取消") forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.bottomView.frame = CGRectMake(0, ScreenHeight-64-BootomHeight*SizeScaleHeight, ScreenWidth, BootomHeight*SizeScaleHeight);
            weakSelf.theTableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-BootomHeight*SizeScaleHeight);
        }];
    }else{
        [self.editButton setTitle:NSInternationalString(@"编辑", @"编辑") forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.bottomView.frame = CGRectMake(0, ScreenHeight-64, ScreenWidth, BootomHeight*SizeScaleHeight);
            weakSelf.theTableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
        }];
    }
    [self.theTableView reloadData];
}
- (void)buttonAction:(UIButton *)btn
{
    switch (btn.tag) {
        case BottomTag:{
            btn.selected = !btn.selected;
            self.selectList = [[NSMutableArray alloc]init];
            if(btn.selected == YES){
                [btn setTitle:NSInternationalString(@"全不选", @"全不选") forState:UIControlStateNormal];
                [self.selectList addObjectsFromArray:self.keyNoteList];
            }else{
                [btn setTitle:NSInternationalString(@"全选", @"全选") forState:UIControlStateNormal];
            }
            [self.theTableView reloadData];
        }
            break;
        case BottomTag+1:{
            if (self.selectList.count == 0) {
                [MYMBProgressHUD showMessage:NSInternationalString(@"您尚未选择任何商品！", @"您尚未选择任何商品！")];
                return;
            }
            NSMutableArray *sid_list = [[NSMutableArray alloc]init];
            for (NSDictionary *keyDic in self.selectList) {
                [sid_list addObject:@([[keyDic objectForKey:@"sid"] integerValue])];
            }
            NSString *sid_str = [sid_list componentsJoinedByString:@","];
            [MYMBProgressHUD showHudWithMessage:NSInternationalString(@"正在删除···", @"正在删除···") InView:self.view];
            NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
            [parameters setObject:@"delete" forKey:@"action"];
            [parameters setObject:@([UserInfoModel shareInstance].user_sid) forKey:@"user_sid"];
            [parameters setObject:SAFE_STRING(sid_str) forKey:@"sid"];
            [[NetworkManager sharedInstance] startRequestWithURL:kKeyNoteRequest method:RequestPost parameters:parameters result:^(AFHTTPRequestOperation *operation, id responseObject) {
                [MYMBProgressHUD hideHudFromView:self.view];
                for (NSDictionary *keyDic in self.selectList) {
                    [self.keyNoteList removeObject:keyDic];
                }
                [self.selectList removeAllObjects];
                [self.theTableView reloadData];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [MYMBProgressHUD hideHudFromView:self.view];
                [MYMBProgressHUD showMessage:error.userInfo[@"NSLocalizedDescription"]];
            }];
        }
            break;
        default:
            break;
    }
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
        [self.theTableView.mj_footer endRefreshing];
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
        [self.theTableView.mj_footer endRefreshing];
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
        titleLabel.text = NSInternationalString(@"今日重点", @"今日重点");
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
    NSString *identifier = [NSString stringWithFormat:@"cell%d%d",(int)indexPath.section,(int)indexPath.row];
    HomePageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HomePageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.theDelegate = self;
    cell.tag = CellTag + indexPath.row;
    NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:self.keyNoteList[indexPath.row]];
    [cell setCellContentWithDic:dic];
    [cell setCellContentConstraintsWithStatus:self.isEdit];
    
    if ([self.selectList containsObject:dic]) {
        cell.selectBtn.selected = YES;
    }else{
        cell.selectBtn.selected = NO;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HomePageCell *cell = (HomePageCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (self.isEdit == YES) {
        cell.selectBtn.selected = !cell.selectBtn.selected;
        [self updateCellSelectStatus:cell];
    }else{
        UpdateKeyNoteViewController *updateKeyVC = [[UpdateKeyNoteViewController alloc]init];
        updateKeyVC.goodsDic = [[NSDictionary alloc]initWithDictionary:self.keyNoteList[indexPath.row]];
        [self.navigationController pushViewController:updateKeyVC animated:YES];
        __weak typeof(self) weakSelf = self;
        updateKeyVC.updataKeyNote = ^(){
            [weakSelf getTheKeyNoteRequest];
        };
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return NSInternationalString(@"删除", @"删除");
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [MYMBProgressHUD showHudWithMessage:NSInternationalString(@"正在删除···", @"正在删除···") InView:self.view];
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
- (void)updateCellSelectStatus:(id)sender
{
    HomePageCell *cell = (HomePageCell *)sender;
    NSInteger row = cell.tag - CellTag;
    NSDictionary *keyDic = [[NSDictionary alloc]initWithDictionary:self.keyNoteList[row]];
    if (cell.selectBtn.selected == YES) {
        if (![self.selectList containsObject:keyDic]) {
            [self.selectList addObject:keyDic];
            [self.theTableView reloadData];
        }
    }else{
        if ([self.selectList containsObject:keyDic]) {
            [self.selectList removeObject:keyDic];
            [self.theTableView reloadData];
        }
    }
    NSLog(@"======%@",self.selectList);
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
- (UIView *)bottomView
{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-64, ScreenWidth, BootomHeight*SizeScaleHeight)];
        _bottomView.backgroundColor = NAVBARCOLOR;
        
        NSArray *titles = @[NSInternationalString(@"全选", @"全选"),NSInternationalString(@"删除", @"删除")];
        for (int i = 0; i < titles.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(ScreenWidth/titles.count*i, 0, ScreenWidth/titles.count, BootomHeight*SizeScaleHeight);
            button.backgroundColor = [UIColor clearColor];
            [button setTitle:titles[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont customFontOfSize:14];
            button.tag = BottomTag+i;
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [_bottomView addSubview:button];
        }
    }
    return _bottomView;
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
