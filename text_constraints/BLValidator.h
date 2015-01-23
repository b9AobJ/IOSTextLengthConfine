//
//  BLValidator.h
//  text_constraints
//
//  Created by Zhenglinqin on 14/12/18.
//  Copyright (c) 2014年 Binglin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UITextInputLengthStatus.h"

@interface BLValidator : NSObject

+ (instancetype)validator;


/**
 *  @param range   .length      表示长度
 *  @param isASCII YES表示一个汉字两个字符
 */

- (UITextInputLengthStatus)validateText:(NSString *)text
                      constraitsInRange:(NSRange)range isACII:(BOOL)isASCII;

- (UITextInputStatus)validateTextStatus:(NSString *)text
                      constraitsInRange:(NSRange)range isACII:(BOOL)isASCII;

- (UITextInputLengthStatus)validateText:(NSString *)text
                      constraitsInRange:(NSRange)range;


- (NSString *)sissorText:(NSString *)text constraitsInRange:(NSRange)range;
- (NSUInteger)textLength:(NSString *)text isASCII:(BOOL)isASCII;
@end
