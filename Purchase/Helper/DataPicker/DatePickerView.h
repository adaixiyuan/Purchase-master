

#import <UIKit/UIKit.h>

@interface DatePickerView : UIView

@property (nonatomic, strong) UIDatePicker   *datePicker;
@property (nonatomic, copy) void (^setTheTime)(NSString *timeStr);

- (id)init;
- (void)showInView:(UIView *)view;
- (void)dismiss;

@end
