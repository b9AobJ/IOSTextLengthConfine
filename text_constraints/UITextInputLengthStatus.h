//
//  UITextInputLengthStatus.h
//  text_constraints
//
//  Created by Zhenglinqin on 14/12/18.
//  Copyright (c) 2014年 Binglin. All rights reserved.
//

#ifndef text_constraints_UITextInputLengthStatus_h
#define text_constraints_UITextInputLengthStatus_h

typedef enum : NSUInteger {
    UITextInputLengthOK      ,//没有超出范围
    UITextInputLengthLess    ,//小于最小字数
    UITextInputLengthEqualMin,//等于最小字数
    UITextInputLengthEqualMax,//等于最大字数
    UITextInputLengthMore    ,//大于最大字数
} UITextInputLengthStatus;


typedef struct UITextInputStatus {
    NSUInteger inputed;
    UITextInputLengthStatus status;
}UITextInputStatus;


NS_INLINE UITextInputStatus UIMakeTextInputStatus(NSUInteger inputLen, UITextInputLengthStatus status){
    UITextInputStatus statusStruct;
    statusStruct.inputed = inputLen;
    statusStruct.status  = status;
    return statusStruct;
}
#endif
