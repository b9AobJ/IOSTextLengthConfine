//
//  ViewController.m
//  text_constraints
//
//  Created by Zhenglinqin on 14/12/17.
//  Copyright (c) 2014年 Binglin. All rights reserved.
//

#import "ViewController.h"
#import "UITextField+text_constraints.h"

@interface ViewController ()<UITextViewDelegate,UITextInputTextFigureDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFeild;

@property (weak, nonatomic) IBOutlet UILabel *numberFieldLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberViewLabel;

@property (strong, nonatomic)  UITextView *textView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textFeild.textLengthRange = NSMakeRange(2, 10);
    self.textFeild.figureDelegate  = self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.textFeild) {
        return [textField shouldChangeInRange:range replaceString:string];
    }
    return YES;
}



- (void)textInput:(id<UITextInput>)input RemainText:(NSInteger)remain{
    if (self.textFeild == input) {
        self.numberFieldLabel.text = [NSString stringWithFormat:@"还剩%d个字",remain];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
