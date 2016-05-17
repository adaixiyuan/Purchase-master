//
//  GoodsShowViewController.m
//  Purchase
//
//  Created by luoheng on 16/5/8.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "GoodsShowViewController.h"
#import "GoodsShowCell.h"

@interface GoodsShowViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *theCollectionView;

@end

@implementation GoodsShowViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"商品预览", @"商品预览");
    [self.view addSubview:self.theCollectionView];
    [self.theCollectionView setContentOffset:CGPointMake(ScreenWidth*self.index, 0)];
}
#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"UICollectionViewCell";
    GoodsShowCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *infoDic = [[NSDictionary alloc]initWithDictionary:self.dataList[indexPath.item]];
    [cell setCellContentWithInfo:infoDic withVCType:self.vcType];
    return cell;
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectGoodsIndex) {
        self.selectGoodsIndex(indexPath.item);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(ScreenWidth, ScreenHeight-64);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
#pragma mark - Set && Get
- (UICollectionView *)theCollectionView
{
    if (!_theCollectionView) {
        //确定是水平滚动，还是垂直滚动
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        _theCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) collectionViewLayout:flowLayout];
        _theCollectionView.dataSource = self;
        _theCollectionView.delegate = self;
        _theCollectionView.pagingEnabled = YES;
        [_theCollectionView setBackgroundColor:[UIColor clearColor]];
        _theCollectionView.showsVerticalScrollIndicator = NO;
        _theCollectionView.showsHorizontalScrollIndicator = NO;
        
        //注册Cell，必须要有
        [_theCollectionView registerClass:[GoodsShowCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    }
    return _theCollectionView;
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
