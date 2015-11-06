//
//  UIView+RAC.h
//  ChangeSkinDemo
//
//  Created by tongxing on 15/9/17.
//  Copyright (c) 2015年 com.company.UOKO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface UIView (RAC)
- (RACSignal*)tx_racSignalWhenTap;
@end
