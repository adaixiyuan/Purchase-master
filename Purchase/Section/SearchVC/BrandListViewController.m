//
//  BrandListViewController.m
//  Purchase
//
//  Created by luoheng on 16/5/14.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "BrandListViewController.h"
#import "SearchInfoModel.h"

static const float BarHeight = 44;

@interface BrandListViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic, strong) UITableView    *theTableView;
@property (nonatomic, strong) UISearchBar    *searchBar;
@property (nonatomic, strong) NSMutableArray *brandList;
@property (nonatomic, strong) NSMutableArray *searchList;

@end

@implementation BrandListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"品牌", @"品牌");
    [self.view addSubview:self.theTableView];
    self.theTableView.tableHeaderView = self.searchBar;
    
    self.brandList = [[NSMutableArray alloc]init];
    // 获取品牌列表
    [self getBrandListRequest];
}
- (void)getBrandListRequest
{
    [MYMBProgressHUD showHudWithMessage:NSLocalizedString(@"请稍等···", @"请稍等···") InView:self.view];
    NSMutableDictionary *parametersDic = [[NSMutableDictionary alloc]init];
    [parametersDic setObject:@([UserInfoModel shareInstance].user_sid) forKey:@"user_sid"];
    [parametersDic setObject:SAFE_STRING([SearchInfoModel shareInstance].domain) forKey:@"domain"];
    [parametersDic setObject:@"true" forKey:@"has_wait_to_buy"];
    [[NetworkManager sharedInstance] startRequestWithURL:kBrandListRequest method:RequestPost parameters:parametersDic result:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MYMBProgressHUD hideHudFromView:self.view];
        NSArray *dataList = [[NSArray alloc]initWithArray:[responseObject objectForKey:@"data"]];
        self.brandList = [[NSMutableArray alloc]initWithArray:dataList];
        NSDictionary *defultDic = [[NSDictionary alloc]initWithObjectsAndKeys:NSLocalizedString(@"默认", @"默认"),@"brand_name",nil];
        [self.brandList insertObject:defultDic atIndex:0];
        self.searchList = [[NSMutableArray alloc]initWithArray:self.brandList];
        [self.theTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MYMBProgressHUD hideHudFromView:self.view];
        [MYMBProgressHUD showMessage:error.userInfo[@"NSLocalizedDescription"]];
    }];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        cell.textLabel.font = [UIFont customFontOfSize:14];
        cell.textLabel.textColor = SHALLOWBLACK;
    }
    NSDictionary *brandDic = [[NSDictionary alloc]initWithDictionary:self.searchList[indexPath.row]];
    cell.textLabel.text = SAFE_STRING([brandDic objectForKey:@"brand_name"]);
    
    if ([SAFE_STRING([brandDic objectForKey:@"brand_name"]) isEqualToString:[SearchInfoModel shareInstance].brandName]) {
        cell.textLabel.textColor = NAVBARCOLOR;
        UIImageView *checkImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 18, 12)];
        checkImageView.backgroundColor = [UIColor clearColor];
        checkImageView.image = [UIImage imageNamed:@"checkMark"];
        cell.accessoryView = checkImageView;
    }else{
        cell.textLabel.textColor = SHALLOWBLACK;
        cell.accessoryView = nil;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *brandDic = [[NSDictionary alloc]initWithDictionary:self.searchList[indexPath.row]];
    if (self.selectTheBrand) {
        self.selectTheBrand(SAFE_STRING([brandDic objectForKey:@"brand_name"]));
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    self.searchBar.text = nil;
    [self.searchBar resignFirstResponder];
    self.searchList = [[NSMutableArray alloc]initWithArray:self.brandList];
    [self.theTableView reloadData];
}
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchBar:self.searchBar textDidChange:self.searchBar.text];
    [self.searchBar resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (self.searchList != nil) {
        [self.searchList removeAllObjects];
    }
    for (NSDictionary *brandDic in self.brandList) {
        if ([[brandDic objectForKey:@"brand_name"] rangeOfString:searchText].location != NSNotFound) {
            [self.searchList addObject:brandDic];
        }
    }
    [self.theTableView reloadData];
}
#pragma mark - Set && Get
- (UITableView *)theTableView
{
    if (_theTableView == nil) {
        _theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) style:UITableViewStylePlain];
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
- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, BarHeight)];
        _searchBar.showsCancelButton = YES;
        _searchBar.placeholder = NSLocalizedString(@"请输入搜索的内容", @"请输入搜索的内容");
        _searchBar.delegate = self;
        _searchBar.backgroundColor = [UIColor whiteColor];
    }
    return _searchBar;
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
