//
//  TypeListViewController.m
//  Purchase
//
//  Created by luoheng on 16/5/15.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "TypeListViewController.h"
#import "SearchInfoModel.h"

@interface TypeListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *theTableView;

@end

@implementation TypeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSInternationalString(@"类型", @"类型");
    [self.view addSubview:self.theTableView];
}
#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [SearchInfoModel shareInstance].typeList.count;
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
    cell.textLabel.text = SAFE_STRING([[SearchInfoModel shareInstance].typeList objectAtIndex:indexPath.row]);
    if ([SearchInfoModel shareInstance].fromType == FromPurchaseVC) {
        
        NSArray *typeIDs = [[SearchInfoModel shareInstance].typeID componentsSeparatedByString:@","];
        if ([typeIDs containsObject:[NSString stringWithFormat:@"%d",(int)indexPath.row+1]]) {
            cell.textLabel.textColor = NAVBARCOLOR;
            UIImageView *checkImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 18, 12)];
            checkImageView.backgroundColor = [UIColor clearColor];
            checkImageView.image = [UIImage imageNamed:@"checkMark"];
            cell.accessoryView = checkImageView;
        }else{
            cell.textLabel.textColor = SHALLOWBLACK;
            cell.accessoryView = nil;
        }
    }else{
        if ([[SearchInfoModel shareInstance].typeID isEqualToString:[NSString stringWithFormat:@"%d",(int)indexPath.row+1]]) {
            cell.textLabel.textColor = NAVBARCOLOR;
            UIImageView *checkImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 18, 12)];
            checkImageView.backgroundColor = [UIColor clearColor];
            checkImageView.image = [UIImage imageNamed:@"checkMark"];
            cell.accessoryView = checkImageView;
        }else{
            cell.textLabel.textColor = SHALLOWBLACK;
            cell.accessoryView = nil;
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([SearchInfoModel shareInstance].fromType == FromPurchaseVC) {
        NSMutableArray *typeIDs = [[NSMutableArray alloc]init];
        if ([SearchInfoModel shareInstance].typeID != nil && [SearchInfoModel shareInstance].typeID.length > 0) {
           typeIDs = [[NSMutableArray alloc]initWithArray:[[SearchInfoModel shareInstance].typeID componentsSeparatedByString:@","]];
        }
        if ([typeIDs containsObject:[NSString stringWithFormat:@"%d",(int)indexPath.row+1]]) {
            [typeIDs removeObject:[NSString stringWithFormat:@"%d",(int)indexPath.row+1]];
        }else{
            [typeIDs addObject:[NSString stringWithFormat:@"%d",(int)indexPath.row+1]];
        }
        NSMutableArray *typeNames = [[NSMutableArray alloc]init];
        for (int i = 0; i < typeIDs.count; i++) {
            [typeNames addObject:[[SearchInfoModel shareInstance].typeList objectAtIndex:[[typeIDs objectAtIndex:i] integerValue]-1]];
        }
        NSString *typeName = [typeNames componentsJoinedByString:@","];
        if (self.selectTheType) {
            self.selectTheType(typeName,nil,typeIDs);
        }
        [tableView reloadData];
    }else{
        NSString *typeName =  SAFE_STRING([[SearchInfoModel shareInstance].typeList objectAtIndex:indexPath.row]);
        NSString *typeID = [NSString stringWithFormat:@"%d",(int)indexPath.row+1];
        [tableView reloadData];
        if (self.selectTheType) {
            self.selectTheType(typeName,typeID,nil);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
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
