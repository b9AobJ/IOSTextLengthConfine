//
//  BLValidator.m
//  text_constraints
//
//  Created by Zhenglinqin on 14/12/18.
//  Copyright (c) 2014年 Binglin. All rights reserved.
//

#import "BLValidator.h"

@implementation BLValidator

+ (instancetype)validator{
    static BLValidator *__blValidator = nil;
    if (__blValidator == nil) {
        __blValidator = [BLValidator new];
    }
    return __blValidator;
}

- (UITextInputLengthStatus)validateText:(NSString *)text constraitsInRange:(NSRange)range isACII:(BOOL)isASCII{
    
    NSUInteger min         = range.location;
    NSUInteger totalLength = range.location + range.length;
    NSUInteger textLength  = [self textLength:text isASCII:isASCII];
    
    if (isASCII == NO) {
        if (textLength < min)
        {
            return UITextInputLengthLess;
        }
        else if (textLength == min)
        {
            return UITextInputLengthEqualMin;
        }
        else if (textLength > totalLength)
        {
            return UITextInputLengthMore;
        }
        else if (textLength == totalLength)
        {
            return UITextInputLengthEqualMax;
        }
        else if (textLength < totalLength)
        {
            return UITextInputLengthOK;
        }
    }
    return UITextInputLengthOK;
}

- (UITextInputLengthStatus)validateText:(NSString *)text constraitsInRange:(NSRange)range{
    return [self validateText:text constraitsInRange:range isACII:NO];
}

- (NSString *)sissorText:(NSString *)text constraitsInRange:(NSRange)range{
    if (text.length > range.length) {
        return [text substringToIndex:(range.location + range.length)];
    }
    return text;
}


- (UITextInputStatus)validateTextStatus:(NSString *)text
                      constraitsInRange:(NSRange)range isACII:(BOOL)isASCII{
    NSUInteger min         = range.location;
    NSUInteger totalLength = range.location + range.length;
    NSUInteger textLength  = [self textLength:text isASCII:isASCII];
    NSUInteger inputed     = textLength;
    
    if (isASCII == NO) {
        if (textLength < min)
        {
            return UIMakeTextInputStatus(inputed,UITextInputLengthLess);
        }
        else if (textLength == min)
        {
            return UIMakeTextInputStatus(inputed,UITextInputLengthEqualMin);
        }
        else if (textLength > totalLength)
        {
            return UIMakeTextInputStatus(inputed,UITextInputLengthMore);
        }
        else if (textLength == totalLength)
        {
            return UIMakeTextInputStatus(inputed,UITextInputLengthEqualMax);
        }
        else if (textLength < totalLength)
        {
            return UIMakeTextInputStatus(inputed,UITextInputLengthOK);
        }
    }
    return UIMakeTextInputStatus(inputed,UITextInputLengthOK);
}

- (NSUInteger)textLength:(NSString *)text isASCII:(BOOL)isASCII{
    if (isASCII == NO) {
        return text.length;
    }
    int   size = 0;
    
    for (int i = 0 ; i < [text length]; i++) {
        unichar uc = [text characterAtIndex:i];
        int len    = isascii(uc)?1:2;
        size += len;
    }
    return size;
}

@end
