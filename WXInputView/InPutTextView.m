//
//  InPutTextView.m
//  RWReactivePlayground
//
//  Created by 马文铂 on 15/11/3.
//  Copyright © 2015年 Colin Eberhardt. All rights reserved.
//

#import "InPutTextView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIView+TGOViewFrame.h"

#define WeakSelfType __weak __typeof(&*self)

@interface InPutTextView()<UITextViewDelegate>

@end

@implementation InPutTextView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubviews];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
        [self addRacSingles];
    }
    return self;
}
- (void)initSubviews{
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 10, self.frame.size.width-40, self.frame.size.height-20)];
    self.textView.delegate = self;
    self.textView.font = [UIFont systemFontOfSize:17];
    [self addSubview:self.textView];
}
- (void)addRacSingles{

    @weakify(self);
    [[self rac_signalForSelector:@selector(setFrame:)]subscribeNext:^(id x) {
        @strongify(self);
        self.textView.frame = CGRectMake(20, 10, self.frame.size.width-40, self.frame.size.height-20);
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil]subscribeNext:^(id x) {
        @strongify(self);
        NSDictionary *userInfo = [(NSNotification*)x userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        [self setBottom:keyboardRect.origin.y];
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil]subscribeNext:^(id x) {
        @strongify(self);
        NSDictionary *userInfo = [(NSNotification*)x userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        [self setBottom:keyboardRect.origin.y];
    }];
    

    CGFloat minHeight = 37;
    CGFloat maxHeight = 120;
    __block  CGFloat originHeight = self.textView.frame.size.height;
    [[RACObserve(self, textView.contentSize) filter:^BOOL(id value) {
        CGSize size = [(NSValue *)value CGSizeValue];
        return size.height>=minHeight&&size.height<=maxHeight;
    }]subscribeNext:^(id x) {
        @strongify(self);
        CGSize size = [(NSValue *)x CGSizeValue];
        [self setTop:self.top-(size.height - originHeight)];
        [self setHeight:self.height+(size.height - originHeight)];
        originHeight = size.height;
    }];
}
@end
