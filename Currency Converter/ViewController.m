//
//  ViewController.m
//  Currency Converter
//
//  Created by AmeerMuhammed on 9/15/20.
//  Copyright © 2020 AmeerMuhammed. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"APISecrets" ofType:@"plist"]];
    apiKey = [dictionary objectForKey:@"API_KEY"];
    
    self.pickerViewFrom.dataSource = self;
    self.pickerViewFrom.delegate = self;
    self.pickerViewTo.dataSource = self;
    self.pickerViewTo.delegate = self;
    
    currencies = [NSArray arrayWithObjects:  @"AED",@"AFN",@"ALL",@"AMD",@"ANG",@"AOA",@"ARS",@"AUD",@"AWG",@"AZN",@"BAM",@"BBD",@"BDT",@"BGN",@"BHD",@"BIF",@"BMD",@"BND",@"BOB",@"BRL",@"BSD",@"BTC",@"BTN",@"BWP",@"BYN",@"BYR",@"BZD",@"CAD",@"CDF",@"CHF",@"CLF",@"CLP",@"CNY",@"COP",@"CRC",@"CUC",@"CUP",@"CVE",@"CZK",@"DJF",@"DKK",@"DOP",@"DZD",@"EGP",@"ERN",@"ETB",@"EUR",@"FJD",@"FKP",@"GBP",@"GEL",@"GGP",@"GHS",@"GIP",@"GMD",@"GNF",@"GTQ",@"GYD",@"HKD",@"HNL",@"HRK",@"HTG",@"HUF",@"IDR",@"ILS",@"IMP",@"INR",@"IQD",@"IRR",@"ISK",@"JEP",@"JMD",@"JOD",@"JPY",@"KES",@"KGS",@"KHR",@"KMF",@"KPW",@"KRW",@"KWD",@"KYD",@"KZT",@"LAK",@"LBP",@"LKR",@"LRD",@"LSL",@"LVL",@"LYD",@"MAD",@"MDL",@"MGA",@"MKD",@"MMK",@"MNT",@"MOP",@"MRO",@"MUR",@"MVR",@"MWK",@"MXN",@"MYR",@"MZN",@"NAD",@"NGN",@"NIO",@"NOK",@"NPR",@"NZD",@"OMR",@"PAB",@"PEN",@"PGK",@"PHP",@"PKR",@"PLN",@"PYG",@"QAR",@"RON",@"RSD",@"RUB",@"RWF",@"SAR",@"SBD",@"SCR",@"SDG",@"SEK",@"SGD",@"SHP",@"SLL",@"SOS",@"SRD",@"STD",@"SVC",@"SYP",@"SZL",@"THB",@"TJS",@"TMT",@"TND",@"TOP",@"TRY",@"TTD",@"TWD",@"TZS",@"UAH",@"UGX",@"USD",@"UYU",@"UZS",@"VEF",@"VND",@"VUV",@"WST",@"XAF",@"XAG",@"XCD",@"XDR",@"XOF",@"XPF",@"YER",@"ZAR",@"ZMK",@"ZMW",@"ZWL",nil];
    
    //Init
    fromCurr=toCurr=@"AED";currencyStr=@"1";
}

-(void)alertConversionData:(double)currencyValue{
    double userValue = [currencyStr doubleValue];
    double conversionResult = currencyValue*userValue;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        dispatch_async(dispatch_get_main_queue(), ^(void){
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ %.2f",self->toCurr,conversionResult] message: [NSString stringWithFormat:@"%@ %.2f to %@",self->fromCurr,userValue,self->toCurr] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        });
    });
}


- (IBAction)convertPressed:(UIButton *)sender {
    NSString *currKey = [NSString stringWithFormat:@"%@_%@",fromCurr,toCurr];
    NSString *apiString = [NSString stringWithFormat:@"https://free.currconv.com/api/v7/convert?q=%@&compact=ultra&apiKey=%@",currKey,apiKey];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:apiString]];
    
    [urlRequest setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200)
        {
            NSError *parseError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            double currencyValue = [[responseDictionary objectForKey:currKey] doubleValue];
            [self alertConversionData:currencyValue];
        }
        else
        {
            NSLog(@"Error");
        }
    }];
    [dataTask resume];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    currencyStr = textField.text;
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return currencies.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return currencies[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView ==_pickerViewFrom)
        fromCurr = currencies[row];
    else
        toCurr = currencies[row];
}
@end
