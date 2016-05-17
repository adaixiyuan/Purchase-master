//
//  LoginViewController.m
//  Purchase
//
//  Created by luoheng on 16/5/2.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

static const float ImageHeight = 75;
static const float BgViewHeight = 90;

@interface LoginViewController ()

@property (nonatomic, strong) AutoScrollView         *bgScrollView;
@property (nonatomic, strong) UITextField            *accountText;  // 账号
@property (nonatomic, strong) UITextField            *passwordText; // 密码
@property (nonatomic, strong) UIButton               *rememberBtn;
@property (nonatomic, strong) UIButton               *sureLoginBtn;

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.bgScrollView];

    NSDictionary *rememberDic = [[MyStore sharedInstance] getObjectById:kRememberTable fromTable:kUserTable];
    self.accountText.text = SAFE_STRING([rememberDic objectForKey:@"account"]);
    self.passwordText.text = SAFE_STRING([rememberDic objectForKey:@"password"]);
    if (self.accountText.text.length > 0 && self.passwordText.text.length > 0) {
        self.sureLoginBtn.enabled = YES;
        self.rememberBtn.selected = YES;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)backAction:(id)sender
{
    if (self.isPresented == YES && self.startLoginNotification) {
        self.startLoginNotification();
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else{
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app changeRootVC];
    }
}
#pragma mark - Event
- (void)remberBtnAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
}
- (void)goToLoginBtnAction:(UIButton *)btn
{
    [self.view endEditing:YES];
    [MYMBProgressHUD showHudWithMessage:NSLocalizedString(@"请稍等···", @"请稍等···") InView:self.view];
    NSMutableDictionary *loginDic = [[NSMutableDictionary alloc]init];
    [loginDic setObject:SAFE_STRING(self.accountText.text) forKey:@"user_name"];
    [loginDic setObject:SAFE_STRING(self.passwordText.text) forKey:@"password"];
    [[NetworkManager sharedInstance] startRequestWithURL:kLoginRequest method:RequestPost parameters:loginDic result:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MYMBProgressHUD hideHudFromView:self.view];
        NSDictionary *dataDic = [[NSDictionary alloc]initWithDictionary:responseObject];
        [UserInfoModel shareInstance].role = SAFE_STRING([dataDic objectForKey:@"role"]);
        [UserInfoModel shareInstance].user_name = SAFE_STRING([dataDic objectForKey:@"user_name"]);
        [UserInfoModel shareInstance].user_sid = [SAFE_NUMBER([dataDic objectForKey:@"user_sid"]) integerValue];
        
        if (self.rememberBtn.selected == YES) {
            NSDictionary *rememberDic = [[NSDictionary alloc]initWithObjectsAndKeys:self.accountText.text,@"account",self.passwordText.text,@"password",nil];
            [[MyStore sharedInstance] putObject:rememberDic withId:kRememberTable intoTable:kUserTable];
        }else{
            [[MyStore sharedInstance] deleteObjectById:kRememberTable fromTable:kUserTable];
        }
        [self backAction:nil];
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MYMBProgressHUD hideHudFromView:self.view];
        [MYMBProgressHUD showMessage:error.userInfo[@"NSLocalizedDescription"]];
    }];
}
#pragma mark - UITextFieldDelegate
- (void)textFieldChange:(NSNotification *)notification
{
    if (self.accountText.text.length > 0 && self.passwordText.text.length > 0) {
        self.sureLoginBtn.enabled = YES;
    }else{
        self.sureLoginBtn.enabled = NO;
    }
}
#pragma mark - Set && Get
- (AutoScrollView *)bgScrollView
{
    if (_bgScrollView == nil) {
        _bgScrollView = [[AutoScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _bgScrollView.backgroundColor = [UIColor clearColor];
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.showsVerticalScrollIndicator = NO;
        _bgScrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight);
        
        UIImageView *logoIconView = [[UIImageView alloc]init];
        logoIconView.backgroundColor = [UIColor clearColor];
        logoIconView.image = [UIImage imageNamed:@"logoIcon"];
        [_bgScrollView addSubview:logoIconView];
        
        UIView *bgView = [[UIView alloc]init];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.borderWidth = HalfScale;
        bgView.layer.borderColor = separateLineColor.CGColor;
        [_bgScrollView addSubview:bgView];
        
        UIImageView *accountImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
        accountImageView.backgroundColor = [UIColor clearColor];
        accountImageView.contentMode = UIViewContentModeScaleAspectFit;
        accountImageView.image = [UIImage imageNamed:@"user_account"];
        _accountText = [[UITextField alloc]init];
        _accountText.backgroundColor = [UIColor whiteColor];
        _accountText.clearButtonMode = UITextFieldViewModeWhileEditing;
        _accountText.font = [UIFont customFontOfSize:14];
        _accountText.placeholder = NSLocalizedString(@"请输入您的账号", @"请输入您的账号");
        _accountText.leftView = accountImageView;
        _accountText.leftViewMode = UITextFieldViewModeAlways;
        [bgView addSubview:_accountText];
        
        UIImageView *passwordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
        passwordImageView.backgroundColor = [UIColor clearColor];
        passwordImageView.contentMode = UIViewContentModeScaleAspectFit;
        passwordImageView.image = [UIImage imageNamed:@"password"];
        _passwordText = [[UITextField alloc]init];
        _passwordText.backgroundColor = [UIColor whiteColor];
        _passwordText.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordText.font = [UIFont customFontOfSize:14];
        _passwordText.secureTextEntry = YES;
        _passwordText.placeholder = NSLocalizedString(@"请输入您的密码", @"请输入您的密码");
        _passwordText.leftView = passwordImageView;
        _passwordText.leftViewMode = UITextFieldViewModeAlways;
        [bgView addSubview:_passwordText];
        
        _rememberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rememberBtn.backgroundColor = [UIColor clearColor];
        [_rememberBtn setImage:[UIImage imageNamed:@"chooes_no"] forState:UIControlStateNormal];
        [_rememberBtn setImage:[UIImage imageNamed:@"chooes_yes"] forState:UIControlStateSelected];
        [_rememberBtn setTitle:@" 记住密码" forState:UIControlStateNormal];
        [_rememberBtn setTitleColor:SHALLOWBLACK forState:UIControlStateNormal];
        _rememberBtn.titleLabel.font = [UIFont customFontOfSize:12];
        [_rememberBtn addTarget:self action:@selector(remberBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgScrollView addSubview:_rememberBtn];
        
        _sureLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureLoginBtn.backgroundColor = [UIColor clearColor];
        [_sureLoginBtn setBackgroundImage:[UIImage imageNamed:@"button_invalid"] forState:UIControlStateDisabled];
        [_sureLoginBtn setBackgroundImage:[UIImage imageNamed:@"button_inEffect"] forState:UIControlStateNormal];
        [_sureLoginBtn setTitle:NSLocalizedString(@"登录", @"登录") forState:UIControlStateNormal];
        [_sureLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureLoginBtn.titleLabel.font = [UIFont boldCustomFontOfSize:15];
        [_sureLoginBtn addTarget:self action:@selector(goToLoginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bgScrollView addSubview:_sureLoginBtn];
        _sureLoginBtn.enabled = NO;
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = separateLineColor;
        [bgView addSubview:line];
        
        [logoIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_bgScrollView.mas_centerX);
            make.top.equalTo(_bgScrollView).with.offset(64);
            make.width.and.height.equalTo(@(ImageHeight*SizeScaleWidth));
        }];
        logoIconView.layer.cornerRadius = ImageHeight*SizeScaleWidth/2;
        logoIconView.clipsToBounds = YES;
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(logoIconView.mas_bottom).with.offset(25);
            make.width.equalTo(@(ScreenWidth));
            make.height.equalTo(@(BgViewHeight*SizeScaleHeight));
        }];
        [_accountText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView).with.offset(0);
            make.left.equalTo(bgView).with.offset(10);
            make.bottom.equalTo(_passwordText.mas_top).with.offset(HalfScale);
            make.width.equalTo(@(ScreenWidth-20));
            make.height.equalTo(_passwordText.mas_height);
        }];
        [_passwordText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_accountText.mas_bottom).with.offset(-HalfScale);
            make.left.equalTo(bgView).with.offset(10);
            make.width.equalTo(@(ScreenWidth-20));
            make.height.equalTo(bgView).multipliedBy(0.5);
        }];
        [_rememberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_passwordText.mas_bottom).with.offset(15);
            make.left.equalTo(_bgScrollView).with.offset(15);
            make.width.equalTo(@(85));
            make.height.equalTo(@(18*SizeScaleHeight));
        }];
        [_sureLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_rememberBtn.mas_bottom).with.offset(15);
            make.centerX.equalTo(_bgScrollView);
            make.width.equalTo(@(ScreenWidth-30));
            make.height.equalTo(@(40*SizeScaleHeight));
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bgView);
            make.width.equalTo(bgView.mas_width);
            make.height.equalTo(@HalfScale);
        }];
    }
    return _bgScrollView;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
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
