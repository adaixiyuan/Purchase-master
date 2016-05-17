//
//  PhotoView.m
//  PhotoDemo
//
//  Created by huixin on 14/11/8.
//  Copyright (c) 2014年 huixin. All rights reserved.
//

#define PHOTOCOUNT 6
#define TopMargin  10 // 上边距
#define Space      20 // 图片边距

#define imageViewSizeWight  80
#define imageViewSizeHeight 100

static const NSInteger PhotoBtnTag = 100;

#import "PhotoShowView.h"

@interface PhotoShowView ()

@property (nonatomic,strong) UIScrollView      *scrollView;
@property (nonatomic,strong) UIButton          *photoBtn;
@property (nonatomic,assign) NSInteger         photoTag;
@property (nonatomic,strong) NSMutableArray    *photoArray;//存储相片

@end

@implementation PhotoShowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        _photoTag = 0;
        _photoArray = [[NSMutableArray alloc]init];
    }
    return self;
}
- (void)setup
{
    _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    _photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _photoBtn.frame = CGRectMake(Space, TopMargin, imageViewSizeWight, imageViewSizeHeight);
    _photoBtn.backgroundColor = [UIColor clearColor];
    [_photoBtn setBackgroundImage:[UIImage imageNamed:@"add_images"] forState:UIControlStateNormal];
    [_scrollView addSubview:_photoBtn];
    [_photoBtn addTarget:self action:@selector(photoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)photoBtnClick:(id)sender
{
    __weak typeof(self) weakSelf = self;
    [UIActionSheet showInView:self.window
                    withTitle:nil
            cancelButtonTitle:NSLocalizedString(@"取消", @"取消")
       destructiveButtonTitle:NSLocalizedString(@"拍照上传", @"拍照上传")
            otherButtonTitles:@[NSLocalizedString(@"从相册上传", @"从相册上传")]
                     tapBlock:^(UIActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
                         switch (buttonIndex) {
                             case 0:
                             {
                                 if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                     UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
                                     imagePicker.delegate = weakSelf;
                                     imagePicker.allowsEditing = YES;
                                     //摄像头
                                     imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                     if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(addPicker:)]) {
                                         [weakSelf.delegate addPicker:imagePicker];
                                     }
                                 }
                             }
                                 break;
                             case 1:
                             {
                                 ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
                                 picker.maximumNumberOfSelection = PHOTOCOUNT - _photoArray.count;
                                 picker.assetsFilter = [ALAssetsFilter allPhotos];
                                 picker.showEmptyGroups = NO;
                                 picker.delegate = weakSelf;
                                 picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                                     if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                                         NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                                         return duration >= 5;
                                     } else {
                                         return YES;
                                     }
                                 }];
                                 if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(addZYQPicker:)]) {
                                     [weakSelf.delegate addZYQPicker:picker];
                                 }
                             }
                                 break;
                             default:
                                 break;
                         }
                     }];
}
#pragma mark - 相机
- (void)imagePickerController: (UIImagePickerController *)picker didFinishPickingMediaWithInfo: (NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *tempImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    NSInteger num = _photoArray.count +1;
    // 重新布局
    [self updateThePhotoViewWithImageCount:num];
    
    UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake((num-1)*(imageViewSizeWight+Space) + Space, TopMargin, imageViewSizeWight, imageViewSizeHeight)];
    imgview.userInteractionEnabled = YES;
    [imgview setImage:tempImg];
    [_scrollView addSubview:imgview];
    UIImage *deleteImage = [UIImage imageNamed:@"photo_delete"];
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(imgview.frame.size.width-deleteImage.size.width*2, -deleteImage.size.height*2, deleteImage.size.width*4, deleteImage.size.height*4);
    [deleteBtn setImage:deleteImage forState:UIControlStateNormal];
    deleteBtn.backgroundColor = [UIColor clearColor];
    deleteBtn.tag = _photoArray.count + PhotoBtnTag;
    [deleteBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    [imgview addSubview:deleteBtn];
    
    [_photoArray addObject:tempImg];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(showPhotos:)]) {
        [self.delegate showPhotos:_photoArray];
    }
}
#pragma mark - 相册 ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
   
    NSInteger num = _photoArray.count + assets.count;
    // 重新布局
    [self updateThePhotoViewWithImageCount:num];
    
    for (int i = 0; i < assets.count; i++) {
        
        ALAsset *asset = assets[i];
        UIImageView *imgview=[[UIImageView alloc] initWithFrame:CGRectMake((i+_photoArray.count)*(imageViewSizeWight+Space) + Space, TopMargin, imageViewSizeWight, imageViewSizeHeight)];
        imgview.userInteractionEnabled = YES;
        
        UIImage *deleteImage = [UIImage imageNamed:@"photo_delete"];
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(imgview.frame.size.width-deleteImage.size.width*2, -deleteImage.size.height*2, deleteImage.size.width*4, deleteImage.size.height*4);
        [deleteBtn setImage:deleteImage forState:UIControlStateNormal];
        deleteBtn.backgroundColor = [UIColor clearColor];
        deleteBtn.tag = i+_photoArray.count + PhotoBtnTag;
        [deleteBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
        [imgview addSubview:deleteBtn];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *newImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            [imgview setImage:newImg];
            [_photoArray addObject:newImg];
            [_scrollView addSubview:imgview];
            if (i == assets.count -1) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(showPhotos:)]) {
                    [self.delegate showPhotos:_photoArray];
                }
            }
        });
    }
}
- (void)updateThePhotoViewWithImageCount:(NSInteger)num
{
    // 清除所有Button视图
    [_photoBtn removeFromSuperview];
    if (num < PHOTOCOUNT ) {
        _scrollView.contentSize = CGSizeMake((num+1)*(imageViewSizeWight+Space)+Space, _scrollView.frame.size.height);
        // 添加btn图片
        _photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _photoBtn.frame = CGRectMake(Space + num*(imageViewSizeWight+Space), TopMargin, imageViewSizeWight, imageViewSizeHeight);
        [_photoBtn setBackgroundImage:[UIImage imageNamed:@"add_images"] forState:UIControlStateNormal];
        [_photoBtn addTarget:self action:@selector(photoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:_photoBtn];
        
    }else{
        _scrollView.contentSize = CGSizeMake(num*(imageViewSizeWight+Space)+Space, _scrollView.frame.size.height);
    }
}
#pragma mark - 删除
- (void)delete:(UIButton *)sender
{
    _photoTag = sender.tag;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"删除图片", @"删除图片") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", @"取消") otherButtonTitles:NSLocalizedString(@"确定", @"确定"), nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [_photoArray removeObjectAtIndex:_photoTag - PhotoBtnTag];
        for (UIView *view in _scrollView.subviews) {
            [view removeFromSuperview];
        }
        NSInteger num = _photoArray.count ;
        
        _scrollView.contentSize = CGSizeMake((num+1)*(imageViewSizeWight+Space)+Space, _scrollView.frame.size.height);
        _photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _photoBtn.frame=CGRectMake(Space + num*(imageViewSizeWight+Space), TopMargin, imageViewSizeWight, imageViewSizeHeight);
        [_photoBtn setBackgroundImage:[UIImage imageNamed:@"add_images"] forState:UIControlStateNormal];
        [_photoBtn addTarget:self action:@selector(photoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:_photoBtn];
        
        if (num == 0) {
            _photoBtn.frame = CGRectMake(Space, TopMargin, imageViewSizeWight, imageViewSizeHeight);
        }
        for (int i = 0; i < num; i++){
            UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(i*(imageViewSizeWight+Space) + Space, TopMargin, imageViewSizeWight, imageViewSizeHeight)];
            imgview.userInteractionEnabled = YES;
            [imgview setImage:[_photoArray objectAtIndex:i]];
            [_scrollView addSubview:imgview];
            
            UIImage *deleteImage = [UIImage imageNamed:@"photo_delete"];
            UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteBtn.frame = CGRectMake(imgview.frame.size.width-deleteImage.size.width*2, -deleteImage.size.height*2, deleteImage.size.width*4, deleteImage.size.height*4);
            [deleteBtn setImage:deleteImage forState:UIControlStateNormal];
            deleteBtn.backgroundColor = [UIColor clearColor];
            deleteBtn.tag = i + PhotoBtnTag;
            [deleteBtn addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
            [imgview addSubview:deleteBtn];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(showPhotos:)]) {
            [self.delegate showPhotos:_photoArray];
        }
    }
}


@end
