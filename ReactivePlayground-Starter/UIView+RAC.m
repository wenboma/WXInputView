//
//  UIView+RAC.m
//  ChangeSkinDemo
//
//  Created by tongxing on 15/9/17.
//  Copyright (c) 2015年 com.company.UOKO. All rights reserved.
//

#import "UIView+RAC.h"

@implementation UIView (RAC)
- (RACSignal*)tx_racSignalWhenTap{
    for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
        [self removeGestureRecognizer:gesture];
    }

    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] init];
    
    [self.gestureRecognizers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![obj isKindOfClass:[UITapGestureRecognizer class]]) return;
        
        UITapGestureRecognizer *tap = obj;
        BOOL rightTouches = (tap.numberOfTouchesRequired == 1);
        BOOL rightTaps = (tap.numberOfTapsRequired == 1);
        if (rightTouches && rightTaps) {
            [gesture requireGestureRecognizerToFail:obj];
        }
    }];
    
    [self addGestureRecognizer:gesture];
    return [gesture rac_gestureSignal];
}
@end
