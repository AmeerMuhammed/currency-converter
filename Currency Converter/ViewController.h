//
//  ViewController.h
//  Currency Converter
//
//  Created by AmeerMuhammed on 9/15/20.
//  Copyright © 2020 AmeerMuhammed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSString *currencyStr,*apiKey,*fromCurr,*toCurr;
    NSArray *currencies;
}
-(void) alertConversionData:(double)currencyValue;
@property (weak,nonatomic) IBOutlet UITextField *textField;
@property (weak,nonatomic) IBOutlet UIPickerView *pickerViewFrom;
@property (weak,nonatomic) IBOutlet UIPickerView *pickerViewTo;
- (IBAction)convertPressed:(UIButton *)sender;
@end
