//
//  UITextView+text_constraits.m
//  text_constraints
//
//  Created by Zhenglinqin on 14/12/19.
//  Copyright (c) 2014年 Binglin. All rights reserved.
//

#import "UITextView+text_constraits.h"
#import <objc/runtime.h>


@implementation UITextView (text_constraints)

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

- (void)setFigureDelegate:(id<UITextInputTextFigureDelegate>)figureDelegate{
    objc_setAssociatedObject(self, @selector(figureDelegate), figureDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<UITextInputTextFigureDelegate>)figureDelegate{
    return objc_getAssociatedObject(self, @selector(figureDelegate));
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

/**
 *  添加文本变化的通知，输入拼音选择汉字时会有通知
 *  delegate shouldChangeCharactersInRange方法选择汉字时不会调用
 */
- (void)addTextChangeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChangeNotif:) name:UITextViewTextDidChangeNotification object:nil];
}


- (BOOL)shouldChangeInRange:(NSRange)range replaceString:(NSString *)string{
    UITextInputLengthStatus status = checkInputViewReplaceInRangeOfText(self, range, self.textLengthRange, string);
    if (status == UITextInputLengthEqualMax) {
        return NO;
    }
    return YES;
}


#pragma private
- (void)textViewTextDidChangeNotif:(NSNotification *)not{
    UITextView *field = not.object;
    if (field == self) {
        textInputTextDidChangeNotif(not, self, self.textLengthRange);
    }
}

@end
