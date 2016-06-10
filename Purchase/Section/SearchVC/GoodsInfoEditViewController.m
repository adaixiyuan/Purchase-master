//
//  GoodsInfoEditViewController.m
//  Purchase
//
//  Created by luoheng on 16/5/6.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "GoodsInfoEditViewController.h"

static const float TextHeight = 45;

@interface GoodsInfoEditViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView      *bgView;
@property (nonatomic, strong) UITextField *theTextField;

@end

@implementation GoodsInfoEditViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSInternationalString(self.titleStr, self.titleStr);
    [self.view addSubview:self.bgView];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:NSInternationalString(@"保存", @"保存") style:UIBarButtonItemStylePlain target:self action:@selector(saveGoodsInfoAction)]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
}
#pragma mark -Event
- (void)saveGoodsInfoAction
{
    [self.view endEditing:YES];
    if (self.updateTheGoodsInfo) {
        self.updateTheGoodsInfo(self.theTextField.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self saveGoodsInfoAction];
    return YES;
}
#pragma mark - Set && Get
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, ScreenWidth, TextHeight*SizeScaleHeight)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.borderWidth = HalfScale;
        _bgView.layer.borderColor = separateLineColor.CGColor;
    
        _theTextField = [[UITextField alloc]init];
        _theTextField.delegate = self;
        _theTextField.backgroundColor = [UIColor clearColor];
        _theTextField.font = [UIFont customFontOfSize:14];
        _theTextField.textColor = SHALLOWBLACK;
        _theTextField.placeholder = NSInternationalString(@"请输入相关信息", @"请输入相关信息");
        _theTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _theTextField.returnKeyType = UIReturnKeyDone;
        if ([_titleStr isEqualToString:NSInternationalString(@"收购个数", @"收购个数")]) {
            _theTextField.keyboardType = UIKeyboardTypeNumberPad;
        }else if ([_titleStr isEqualToString:NSInternationalString(@"价格", @"价格")]){
            _theTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }
        [_bgView addSubview:_theTextField];
        [_theTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_bgView).with.offset(0);
            make.left.equalTo(_bgView).with.offset(15);
            make.right.equalTo(_bgView).with.offset(-15);
            make.height.equalTo(_bgView.mas_height);
        }];
    }
    return _bgView;
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
