//
//  AddKeyNoteViewController.m
//  Purchase
//
//  Created by luoheng on 16/5/21.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "AddKeyNoteViewController.h"
#import "PhotoShowView.h"
#import "GoodsInfoEditViewController.h"
#import "BrandsViewController.h"
#import "DatePickerView.h"
#import "KeyNoteModel.h"

static const float HeadHeight = 42;
static const float FootHeight = 80;
static const float RowHeight_one = 110;
static const float RowHeight_two = 44;
static const NSInteger TitleTag = 100;

@interface AddKeyNoteViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,PhotoViewDelegate>

@property (nonatomic, strong) AutoTableView    *theTableView;
@property (nonatomic, strong) PhotoShowView    *myPhotoView;
@property (nonatomic, strong) NSArray          *imageList;
@property (nonatomic, strong) UITextView       *textView;
@property (nonatomic, strong) UIButton         *addBtn;
@property (nonatomic, strong) KeyNoteModel     *keyNoteModel;

@end

@implementation AddKeyNoteViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSInternationalString(@"新增重点", @"新增重点");
    [self.view addSubview:self.theTableView];
    
    self.keyNoteModel = [[KeyNoteModel alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark - Event
- (void)publishAction:(UIButton *)btn
{
    [MYMBProgressHUD showHudWithMessage:NSInternationalString(@"请稍等···", @"请稍等···") InView:self.view];
    NSMutableDictionary *publishDic = [[NSMutableDictionary alloc]init];
    [publishDic setObject:@"add" forKey:@"action"];
    [publishDic setObject:@(self.keyNoteModel.type) forKey:@"type"];
    [publishDic setObject:@([UserInfoModel shareInstance].user_sid) forKey:@"user_sid"];
    [publishDic setObject:SAFE_STRING(self.keyNoteModel.title) forKey:@"title"];
    [publishDic setObject:SAFE_STRING(self.keyNoteModel.expire_dt) forKey:@"expire_dt"];
    [publishDic setObject:SAFE_STRING(self.keyNoteModel.content) forKey:@"content"];
    [publishDic setObject:SAFE_STRING(self.keyNoteModel.tag) forKey:@"tag"];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    NSMutableArray *namesArray = [[NSMutableArray alloc]init];
    NSMutableArray *filesArray = [[NSMutableArray alloc]init];
    NSMutableArray *mimeTypeArray = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < self.imageList.count ; i++) {
        UIImage *theImage = (UIImage *)self.imageList[i];
        NSData *data = UIImageJPEGRepresentation(theImage, 0.3);
        [dataArray addObject:data];
        [namesArray addObject:[NSString stringWithFormat:@"img%d",i]];
        [filesArray addObject:[NSString stringWithFormat:@"img%d.png",i]];
        [mimeTypeArray addObject:@"image/png"];
    }
    [[NetworkManager sharedInstance] uploadRequestWithURL:kKeyNoteRequest method:RequestPost parameters:publishDic datas:dataArray names:namesArray fileNames:filesArray mimeTypes:mimeTypeArray result:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MYMBProgressHUD hideHudFromView:self.view];
        if (self.updataKeyNote) {
            self.updataKeyNote();
        }
        [MYMBProgressHUD showMessage:SAFE_STRING([responseObject objectForKey:@"msg"])];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MYMBProgressHUD hideHudFromView:self.view];
        [MYMBProgressHUD showMessage:error.userInfo[@"NSLocalizedDescription"]];
    }];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HeadHeight*SizeScaleHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *SectionHeadIdentifier = @"SectionHeadIdentifier";
    UITableViewHeaderFooterView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeadIdentifier];
    if (!headView) {
        headView = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:SectionHeadIdentifier];
        headView.contentView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont customFontOfSize:14];
        titleLabel.textColor = SHALLOWBLACK;
        titleLabel.tag = TitleTag;
        [headView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headView).with.offset(0);
            make.left.equalTo(headView).with.offset(15);
        }];
    }
    NSArray *titles = @[NSInternationalString(@"商品图片", @"商品图片"),NSInternationalString(@"商品内容", @"商品内容"),NSInternationalString(@"商品信息", @"商品信息")];
    UILabel *titleLabel = (UILabel *)[headView viewWithTag:TitleTag];
    titleLabel.text = titles[section];
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section < 2) {
        return 10;
    }else{
        return FootHeight*SizeScaleHeight;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section < 2) {
        return nil;
    }else{
        static NSString *sectionFootIdentifier = @"sectionFootIdentifier";
        UITableViewHeaderFooterView *footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionFootIdentifier];
        if (!footView) {
            footView = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:sectionFootIdentifier];
            footView.contentView.backgroundColor = [UIColor clearColor];
            
            self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.addBtn.backgroundColor = [UIColor clearColor];
            [self.addBtn setBackgroundImage:[UIImage imageNamed:@"button_inEffect"] forState:UIControlStateNormal];
            [self.addBtn setBackgroundImage:[UIImage imageNamed:@"button_invalid"] forState:UIControlStateDisabled];
            [self.addBtn setTitle:NSInternationalString(@"发布", @"发布") forState:UIControlStateNormal];
            [self.addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.addBtn.titleLabel.font = [UIFont customFontOfSize:15];
            [self.addBtn addTarget:self action:@selector(publishAction:) forControlEvents:UIControlEventTouchUpInside];
            [footView addSubview:self.addBtn];
            
            [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(footView).with.offset(0);
                make.left.equalTo(footView).with.offset(15);
                make.right.equalTo(footView).with.offset(-15);
                make.height.equalTo(@(40*SizeScaleHeight));
            }];
        }
        if (self.keyNoteModel.title.length > 0 && self.keyNoteModel.typeStr.length > 0 && self.keyNoteModel.expire_dt.length > 0) {
            self.addBtn.enabled = YES;
        }else{
            self.addBtn.enabled = NO;
        }
        return footView;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1) {
        return RowHeight_one*SizeScaleHeight;
    }else{
        return RowHeight_two*SizeScaleHeight;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 1;
    }else{
        return 4;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"cell%d%d",(int)indexPath.section,(int)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont customFontOfSize:14];
        cell.textLabel.textColor = SHALLOWBLACK;
        cell.detailTextLabel.font = [UIFont customFontOfSize:14];
        cell.detailTextLabel.textColor = SHALLOWBLACK;
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (indexPath.section == 0) {
        [cell.contentView addSubview:self.myPhotoView];
    }else if(indexPath.section == 1){
        [cell.contentView addSubview:self.textView];
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        NSArray *titles = @[NSInternationalString(@"标题", @"标题"),NSInternationalString(@"类型", @"类型"),NSInternationalString(@"失效时间", @"失效时间"),NSInternationalString(@"标签", @"标签")];
        NSArray *details_list = @[SAFE_STRING(self.keyNoteModel.title),SAFE_STRING(self.keyNoteModel.typeStr),SAFE_STRING(self.keyNoteModel.expire_dt),SAFE_STRING(self.keyNoteModel.tag)];
        cell.textLabel.text = titles[indexPath.row];
        cell.detailTextLabel.text = details_list[indexPath.row];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __weak typeof(self) weakSelf = self;
    if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 0:{
                GoodsInfoEditViewController *goodsInfoVC = [[GoodsInfoEditViewController alloc]init];
                goodsInfoVC.titleStr = NSInternationalString(@"标题", @"标题");
                [self.navigationController pushViewController:goodsInfoVC animated:YES];
                goodsInfoVC.updateTheGoodsInfo = ^(NSString *info){
                    weakSelf.keyNoteModel.title = SAFE_STRING(info);
                    [weakSelf.theTableView reloadData];
                };
            }
                break;
            case 1:{
                NSArray *titles = @[NSInternationalString(@"普通信息", @"普通信息"),NSInternationalString(@"折扣信息", @"折扣信息")];
                [UIActionSheet showInView:self.view
                                withTitle:nil
                        cancelButtonTitle:NSInternationalString(@"取消", @"取消")
                   destructiveButtonTitle:nil
                        otherButtonTitles:titles
                                 tapBlock:^(UIActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                                     if(buttonIndex < 2){
                                         weakSelf.keyNoteModel.type = buttonIndex+1;
                                         weakSelf.keyNoteModel.typeStr = titles[buttonIndex];
                                         [weakSelf.theTableView reloadData];
                                     }
                                 }];
            }
                break;
            case 2:{
                DatePickerView *dateView = [[DatePickerView alloc]init];
                dateView.datePicker.minimumDate = [NSDate date];
                [dateView showInView:self.view];
                dateView.setTheTime = ^(NSString *dateStr){
                    weakSelf.keyNoteModel.expire_dt = SAFE_STRING(dateStr);
                    [weakSelf.theTableView reloadData];
                };
            }
                break;
            case 3:{
                GoodsInfoEditViewController *goodsInfoVC = [[GoodsInfoEditViewController alloc]init];
                goodsInfoVC.titleStr = NSInternationalString(@"标签", @"标签");
                [self.navigationController pushViewController:goodsInfoVC animated:YES];
                goodsInfoVC.updateTheGoodsInfo = ^(NSString *info){
                    weakSelf.keyNoteModel.tag = SAFE_STRING(info);
                    [weakSelf.theTableView reloadData];
                };
            }
                break;
            default:
                break;
        }
    }
}
#pragma mark - UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text > 0) {
        self.keyNoteModel.content = SAFE_STRING(textView.text);
    }
}
#pragma mark - PhotoViewDelegate
- (void)addPicker:(UIImagePickerController *)picker
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:picker animated:YES completion:nil];
    });
}
- (void)addZYQPicker:(ZYQAssetPickerController *)picker
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:picker animated:YES completion:nil];
    });
}
- (void)showPhotos:(NSMutableArray *)photos
{
    self.imageList = [[NSMutableArray alloc]initWithArray:photos];
}
#pragma mark - 监听键盘
- (void)keyboardShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    [self autoMoveKeyboard:(float)keyboardRect.size.height];
}
- (void)keyboardHide:(NSNotification *)notification
{
    [self autoMoveKeyboard:0];
}
- (void)autoMoveKeyboard:(float)height
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.theTableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-height);
        if (height > 0.000000) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            [weakSelf.theTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
        }
    }];
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
- (PhotoShowView *)myPhotoView
{
    if (_myPhotoView == nil) {
        _myPhotoView = [[PhotoShowView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, RowHeight_one*SizeScaleHeight)];
        _myPhotoView.delegate = self;
        _myPhotoView.backgroundColor = [UIColor clearColor];
    }
    return _myPhotoView;
}
- (UITextView *)textView
{
    if (_textView == nil) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 5, ScreenWidth-20, RowHeight_one-10)];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.placeholder = NSInternationalString(@"请添加商品内容及介绍", @"请添加商品内容及介绍");
        _textView.placeholderColor = SHALLOWGRAY;
        _textView.textColor = SHALLOWBLACK;
        _textView.font = [UIFont customFontOfSize:14];
    }
    return _textView;
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
