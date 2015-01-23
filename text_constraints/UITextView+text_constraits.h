//
//  UITextView+text_constraits.h
//  text_constraints
//
//  Created by Zhenglinqin on 14/12/19.
//  Copyright (c) 2014年 Binglin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextField+text_constraints.h"

#pragma mark - UITextView (text_constraints)
@interface UITextView (text_constraints)<UITextInputTextConstraintsDelegate>

@property (nonatomic, assign) id<UITextInputTextFigureDelegate> figureDelegate;
- (BOOL)shouldChangeInRange:(NSRange)range replaceString:(NSString *)string;

@end