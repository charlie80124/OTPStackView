//
//  OTPStackView.h
//  OTPStackView
//
//  Created by Charlie.Hsu on 2021/6/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OTPTextField;
@interface OTPStackView : UIStackView
-(instancetype)initWithCount:(NSInteger) count;
@property (nonatomic, strong) NSString* OTPCode;
@property (nonatomic, assign) NSInteger numberOfCount;
@end

@interface OTPTextField: UITextField
@property (nonatomic, strong, nullable) OTPTextField* preTextField;
@property (nonatomic, strong, nullable) OTPTextField* nextTextField;
@property (nonatomic, copy, nullable) void(^OTPTextFieldDeleteBackward)(OTPTextField* currentTextField);
@end

NS_ASSUME_NONNULL_END
