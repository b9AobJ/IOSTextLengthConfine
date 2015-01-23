//
//  UITextField+text_constraints.m
//  text_constraints
//
//  Created by Zhenglinqin on 14/12/17.
//  Copyright (c) 2014年 Binglin. All rights reserved.
//

#import "UITextField+text_constraints.h"
#import "BLValidator.h"
#import <objc/runtime.h>

#pragma mark - UITextInputCommon
void textInputTextDidChangeNotif(NSNotification *notif,id<UITextInput> input,NSRange confineRange){
    id<UITextInput> inputNotiffield = notif.object;
    BOOL isTextField = NO;
    if ([input isKindOfClass:[UITextField class]]) {
        isTextField = YES;
    }
    UITextField *textField   = (UITextField *)input;
    NSString    *textInInput = textField.text;
    if (inputNotiffield == input)
    {
        if ([textField isKindOfClass:[UITextField class]] && textField.trimWhitespace) {
            textInInput = [textInInput stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        
        UITextInputLengthStatus status ;
        if (textField.figureDelegate == nil) {
            status = [[BLValidator validator] validateText:textInInput constraitsInRange:confineRange];
        }else{
            UITextInputStatus statusStruct = [[BLValidator validator] validateTextStatus:textInInput constraitsInRange:confineRange isACII:textField.isASCII];
            status = statusStruct.status;

            if ([textField.figureDelegate respondsToSelector:@selector(textInput:HadInputText:)]) {
                [textField.figureDelegate textInput:input HadInputText:statusStruct.inputed];
            }
            
            if ([textField.figureDelegate respondsToSelector:@selector(textInput:RemainText:)]) {
                NSInteger remain = confineRange.location + confineRange.length - statusStruct.inputed;
                if (remain < 0 && textField.forceTruncation && (input.markedTextRange == nil)) {
                    remain = 0;
                }
                [textField.figureDelegate textInput:input RemainText:remain];
            }
        }

        NSDictionary *d = @{@(UITextInputLengthOK)      :@">= min  <= max",
                            @(UITextInputLengthLess)    :@"< min",
                            @(UITextInputLengthEqualMax):@"= max",
                            @(UITextInputLengthEqualMin):@"= min",
                            @(UITextInputLengthMore)    :@">max"};

        NSLog(@"%@",d[@(status)]);
        if (status == UITextInputLengthMore)
        {
            if (input.markedTextRange == nil)
            {
                if (textField.forceTruncation)
                {
                    textField.text = [[BLValidator validator] sissorText:textInInput constraitsInRange:confineRange];
                }
            }
        }
    }
}


UITextInputLengthStatus checkInputViewReplaceInRangeOfText(id<UITextInput>input,
                        NSRange range,NSRange confineRange,NSString *string){
    UITextField *textField = (UITextField *)input;
    //删除字符时
    if (range.length == 1) {
        return UITextInputLengthOK;
    }
    //输入字符时 length == 0
    if (input.markedTextRange) {
        return UITextInputLengthOK;
    }
    //中文输入选择完汉字时
    else{
        return [[BLValidator validator] validateText:textField.text constraitsInRange:confineRange isACII:textField.isASCII];
    }
}


UITextInputStatus checkInputStatusReplaceInRangeOfText(id<UITextInput>input,
                                                       NSRange range,NSRange confineRange,
                                                       NSString *string){
     UITextField *textField = (UITextField *)input;
    //删除字符时
    if (range.length == 1) {
        return UIMakeTextInputStatus([[BLValidator validator] textLength:textField.text isASCII:textField.isASCII], UITextInputLengthOK);
    }
    //输入字符时 length == 0
    if (input.markedTextRange) {
        return UIMakeTextInputStatus([[BLValidator validator] textLength:textField.text isASCII:textField.isASCII],UITextInputLengthOK);
    }
    //中文输入选择完汉字时
    else{
        return [[BLValidator validator] validateTextStatus:textField.text constraitsInRange:confineRange isACII:textField.isASCII];
    }
}


/*
 *  UITextInput的umarkedTextRange非空时表示有高亮字符(可作为输入未完成状态的标志)
 */


@implementation UITextField (text_constraints)

- (BOOL)trimWhitespace{
    id isTrim = objc_getAssociatedObject(self, @selector(trimWhitespace));
    if (isTrim == nil) {
        return NO;
    }
    return [isTrim boolValue];
}

- (void)setTrimWhitespace:(BOOL)trimWhitespace{
    objc_setAssociatedObject(self, @selector(trimWhitespace), @(trimWhitespace), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)forceTruncation{
    id isForce = objc_getAssociatedObject(self, @selector(forceTruncation));
    if (isForce == nil) {
        return YES;
    }
    return [isForce boolValue];
}

- (void)setForceTruncation:(BOOL)forceTruncation{
    objc_setAssociatedObject(self, @selector(forceTruncation), @(forceTruncation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTextLengthRange:(NSRange)textLengthRange{
    
    [self addTextChangeNotification];
    objc_setAssociatedObject(self, @selector(textLengthRange), [NSValue valueWithRange:textLengthRange], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSRange)textLengthRange{
    NSValue *value = objc_getAssociatedObject(self, @selector(textLengthRange));
    if (value) {
        return value.rangeValue;
    }
    return NSMakeRange(0, NSUIntegerMax);
}

- (void)setFigureDelegate:(id<UITextInputTextFigureDelegate>)figureDelegate{
    objc_setAssociatedObject(self, @selector(figureDelegate), figureDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<UITextInputTextFigureDelegate>)figureDelegate{
    return objc_getAssociatedObject(self, @selector(figureDelegate));
}

- (BOOL)isASCII{
    id isAscii = objc_getAssociatedObject(self, @selector(isASCII));
    if (isAscii == nil) {
        return NO;
    }
    return [isAscii boolValue];
}

- (void)setIsASCII:(BOOL)isASCII{
    objc_setAssociatedObject(self, @selector(isASCII), @(isASCII), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**
 *  添加文本变化的通知，输入拼音选择汉字时会有通知
 *  delegate shouldChangeCharactersInRange方法选择汉字时不会调用
 */
- (void)addTextChangeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNotif:) name:UITextFieldTextDidChangeNotification object:nil];
}

/**
 *  @param range  .length == 1表示删除字符 .length == 0 表示输入字符
 */
- (BOOL)shouldChangeInRange:(NSRange)range replaceString:(NSString *)string{
    if (self.figureDelegate) {
        UITextInputStatus statusStruct = checkInputStatusReplaceInRangeOfText(self, range, self.textLengthRange, string);
        if (statusStruct.status == UITextInputLengthEqualMax) {
            return NO;
        }
        return YES;
    }else{
        UITextInputLengthStatus status = checkInputViewReplaceInRangeOfText(self, range, self.textLengthRange, string);
        if (status == UITextInputLengthEqualMax) {
            return NO;
        }
        return YES;
    }
}

#pragma private
- (void)textFieldTextDidChangeNotif:(NSNotification *)not{
    UITextField *field = not.object;
    if (field == self) {
        textInputTextDidChangeNotif(not, self, self.textLengthRange);
    }
}

@end

