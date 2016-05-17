//
//  PhotoView.h
//  PhotoDemo
//
//  Created by huixin on 14/11/8.
//  Copyright (c) 2014年 huixin. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "ZYQAssetPickerController.h"

@protocol PhotoViewDelegate <NSObject>

@optional

-(void)addPicker:(UIImagePickerController *)picker; //UIImagePickerController

-(void)addZYQPicker:(ZYQAssetPickerController *)picker;

-(void)showPhotos:(NSMutableArray *)photos;

@end

@interface PhotoShowView : UIView<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,ZYQAssetPickerControllerDelegate>

@property (nonatomic,weak) id <PhotoViewDelegate> delegate;

@end
