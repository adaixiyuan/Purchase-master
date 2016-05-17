//
//  AutoScrollView.m
//  CarShowAdviser
//
//  Created by Cars on 16/3/17.
//  Copyright © 2016年 Cars. All rights reserved.
//

#import "AutoScrollView.h"

@interface AutoScrollView ()

@property (nonatomic, assign) CGRect theFrame;

@end

@implementation AutoScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.theFrame = frame;
        self.backgroundColor = [UIColor clearColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [self.superview addGestureRecognizer:tap];
    }
    return self;
}
- (void)tapClick:(UITapGestureRecognizer *)tap
{
    [self.superview endEditing:YES];
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self KeyboardAvoiding_findFirstResponderBeneathView:self] resignFirstResponder];
    [super touchesEnded:touches withEvent:event];
}
- (UIView *)KeyboardAvoiding_findFirstResponderBeneathView:(UIView*)view {
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] ){
            return childView;
        }
        UIView *result = [self KeyboardAvoiding_findFirstResponderBeneathView:childView];
        if ( result ) return result;
    }
    return nil;
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
        weakSelf.frame = CGRectMake(weakSelf.theFrame.origin.x, weakSelf.theFrame.origin.y, weakSelf.theFrame.size.width, weakSelf.theFrame.size.height-height);
    }];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
@end
