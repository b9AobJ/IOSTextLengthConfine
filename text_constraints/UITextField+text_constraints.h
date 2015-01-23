//
//  UITextField+text_constraints.h
//  text_constraints
//
//  Created by Zhenglinqin on 14/12/17.
//  Copyright (c) 2014年 Binglin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextInputLengthStatus.h"

#pragma mark - UITextInputCommon
/**
 *  @param notif .object是监听UITextFieldTextDidChangeNotification或者UITextViewTextDidChangeNotification发出的通知内容
 *  @param input 文字改变的UITextField或者UITextView
 */
void textInputTextDidChangeNotif(NSNotification *notif,id<UITextInput> input,NSRange confineRange);

/**
 *  @param input
 *  @param range
 *  @param string
 *
 *  @return 返回当前文本长度状态
 *  对应)textField:(UITextField *)textField 
             shouldChangeCharactersInRange:(NSRange)range 
                         replacementString:(NSString *)string;
 */
UITextInputLengthStatus checkInputViewReplaceInRangeOfText(id<UITextInput>input,
                                                           NSRange range,NSRange confineRange,
                                                           NSString *string);
/*返回上述方法的status及已输入的字数*/
UITextInputStatus checkInputStatusReplaceInRangeOfText(id<UITextInput>input,
                                                           NSRange range,NSRange confineRange,
                                                           NSString *string);






#pragma mark - UITextInputTextConstraintsDelegate
@protocol UITextInputTextConstraintsDelegate <NSObject>

@required
@property (nonatomic, assign) NSRange textLengthRange;//输入字数范围

@optional
@property (nonatomic, assign) BOOL    isASCII;//是否中文一个字算两个字符   默认为NO～～一个汉字算一个长度
@property (nonatomic, assign) BOOL    forceTruncation;//超过长度是否截断  默认为YES

@end


#pragma mark - UITextInputTextLengthDelegate
@protocol UITextInputTextFigureDelegate <NSObject>

@optional
- (void)textInput:(id<UITextInput>)input HadInputText:(NSUInteger)inputlength;
- (void)textInput:(id<UITextInput>)input RemainText:(NSInteger)remain;

@end



#pragma mark - UITextField (text_constraints)
@interface UITextField (text_constraints)<UITextInputTextConstraintsDelegate>

@property (nonatomic, assign) BOOL    trimWhitespace ;//空白字符是否trim 默认为NO
@property (nonatomic, assign) id<UITextInputTextFigureDelegate> figureDelegate;
- (BOOL)shouldChangeInRange:(NSRange)range replaceString:(NSString *)string;

@end







