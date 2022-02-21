//
//  OTPStackView.m
//  OTPStackView
//
//  Created by Charlie.Hsu on 2021/6/7.
//

#import "OTPStackView.h"

@interface OTPStackView() <UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray* textFieldsCollection;
@property (nonatomic, strong, nullable) OTPTextField* currentTextField;
@end

@implementation OTPStackView

-(instancetype)initWithCount:(NSInteger) count {
    if (self = [super init]) {
        [self setupWithCount:count];
        [self setupTextField];
    }
    return self;
}

-(void) setupWithCount:(NSInteger)count {
    self.numberOfCount = count;
    self.axis = UILayoutConstraintAxisHorizontal;
    self.distribution = UIStackViewDistributionFillEqually;
    self.spacing = 5;
    self.userInteractionEnabled = YES;
}

-(void) setupTextField {
    
    for (int i = 0 ; i < self.numberOfCount ; i++) {
        OTPTextField* textField = [[OTPTextField alloc]init];
        textField.delegate = self;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.borderStyle = UITextBorderStyleNone;
        textField.userInteractionEnabled = YES;
        textField.textAlignment = NSTextAlignmentCenter;
        __weak typeof(self)weakSelf = self;
        textField.OTPTextFieldDeleteBackward = ^(OTPTextField * _Nonnull currentTextField) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            if (currentTextField) {
                self.currentTextField = currentTextField;
            }
        };

        [self.textFieldsCollection addObject:textField];
        
        if (i != 0 ) {
            OTPTextField* preTextField = self.textFieldsCollection[i-1];
            textField.preTextField = preTextField;
            preTextField.nextTextField = textField;
        }
        [self addArrangedSubview:textField];
    }
}


-(NSString *)OTPCode {
    NSString* OTP = @"";
    for (OTPTextField*textField in self.textFieldsCollection) {
        OTP = [OTP stringByAppendingString:textField.text];
    }
    return OTP;
}


//MARK: - UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    //判斷是否第一次點擊
    if ([self.OTPCode isEqualToString:@""]) {
        OTPTextField* firstOTPTextField = self.textFieldsCollection[0];
        if (textField == firstOTPTextField) {
            return YES;
        }else{
            [firstOTPTextField becomeFirstResponder];
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(OTPTextField *)textField {
    if (![textField.text isEqualToString: @""] && textField != self.currentTextField) {
        textField.text = @"";
        self.currentTextField = textField;
    }
}

-(BOOL)textField:(OTPTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (string.length > 1) {
        [textField resignFirstResponder];
        return NO;
    } else {
        if (range.length == 0 && [string isEqualToString:@""]){
            return NO;
        }else if (range.length == 0){
        
            if (textField.nextTextField == nil) {
                textField.text = string;
                [textField resignFirstResponder];
            }else{
                textField.text = string;
                self.currentTextField = textField.nextTextField;
                [textField.nextTextField becomeFirstResponder];
            }
                return NO;
        }
        return YES;
    }
    return YES;
}



//MARK: -
-(NSMutableArray *)textFieldsCollection {
    if (!_textFieldsCollection) {
        _textFieldsCollection = [[NSMutableArray alloc]init];
    }
    return _textFieldsCollection;
}

@end

@implementation OTPTextField

-(instancetype)init {
    if (self = [super init]) {
        UIView* bottomLine = [[UIView alloc]init];
        bottomLine.translatesAutoresizingMaskIntoConstraints = NO;
        bottomLine.backgroundColor = UIColor.LightGrayColor;
        [self addSubview:bottomLine];
        
        [[bottomLine.bottomAnchor constraintEqualToAnchor:self constant:1] setActive:YES];
        [[bottomLine.leftAnchor constraintEqualToAnchor:self.leftAnchor] setActive:YES];
        [[bottomLine.rightAnchor constraintEqualToAnchor:self.rightAnchor] setActive:YES];
        [[bottomLine.heightAnchor constraintEqualToConstant:1] setActive:YES];
    }
    return self;
}

-(void)deleteBackward {
    self.text = @"";
    if (self.OTPTextFieldDeleteBackward) {
        self.OTPTextFieldDeleteBackward(self.preTextField);
    }    
    [self.preTextField becomeFirstResponder];
}

@end
