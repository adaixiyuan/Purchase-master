//
//  UpdateKeyNoteViewController.h
//  Purchase
//
//  Created by luoheng on 16/6/4.
//  Copyright © 2016年 luoheng. All rights reserved.
//

#import "BaseViewController.h"

@interface UpdateKeyNoteViewController : BaseViewController

@property (nonatomic, strong) NSDictionary *goodsDic;
@property (nonatomic, copy) void (^updataKeyNote)();

@end
