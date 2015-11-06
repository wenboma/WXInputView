//
//  RWViewController.m
//  RWReactivePlayground
//
//  Created by Colin Eberhardt on 18/12/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "RWViewController.h"
#import "RWDummySignInService.h"
#import "InPutTextView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIView+TGOViewFrame.h"
#import "UIView+RAC.h"
typedef NSString* (^TestBlock)(NSString *obj);
@interface RWViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UILabel *signInFailureText;

@property (nonatomic, assign) TestBlock testBlock;

@property (nonatomic) BOOL passwordIsValid;
@property (nonatomic) BOOL usernameIsValid;
@property (strong, nonatomic) RWDummySignInService *signInService;


@property (nonatomic, strong) InPutTextView *inputView;

@end

@implementation RWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RAC(self.usernameTextField,backgroundColor) = [[self.usernameTextField.rac_textSignal map:^id(id value) {
        return @(((NSString *)value).length>3);
    }] map:^id(id value) {
        NSNumber *number = value;
        return number.boolValue?[UIColor greenColor]:[UIColor yellowColor];
    }];
    
    
    RAC(self.passwordTextField,backgroundColor) = [[self.passwordTextField.rac_textSignal map:^id(id value) {
        return @(((NSString *)value).length >3);
    }]map:^id(id value) {
        return ((NSNumber *)value).boolValue?[UIColor greenColor]:[UIColor yellowColor];
    }];
    
    RACSignal *vailableUser = [self.usernameTextField.rac_textSignal map:^id(id value) {
        return @(((NSString *)value).length>3);
    }];
    
    RACSignal *vailablePassword = [self.passwordTextField.rac_textSignal map:^id(id value) {
        return @(((NSString *)value).length>3);
    }];
    
    RAC(self.signInButton,enabled) = [[RACSignal combineLatest:@[vailableUser,vailablePassword]]map:^id(id value) {

        RACTuple *ple = value;
        for(NSNumber *number in ple.allObjects){
            if(!number.boolValue){
                return @(0);
            }
        }
        return @(1);
    }];
    
    
    self.signInService = [RWDummySignInService new];
    
//    [[[self.signInButton
//       rac_signalForControlEvents:UIControlEventTouchUpInside]
//      flattenMap:^id(id x){
//          RACSignal * single = [self signInSignal];
//          return single;
//      }]
//     subscribeNext:^(id x){
//         NSLog(@"Sign in result: %@", x);
//     } error:^(NSError *error) {
//         NSLog(@"Sign in result: %@", error);
//     }completed:^{
//         NSLog(@"完成");
//     }];
    

    

    
   
    
    RACSubject *letters = [RACSubject subject];
    RACSignal *single = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"34567");
        [subscriber sendNext:@"234567"];
        return nil;
    }];
//    single = letters;
    [single subscribeNext:^(id x) {
        ;
    } error:^(NSError *error) {
        ;
    }];
//    single = letters;
//    [single subscribeNext:^(id x) {
//        ;
//    } error:^(NSError *error) {
//        ;
//    }];

//    RACSignal *single = [[self signInSignal]subscribeNext:^(id x) {
//        NSLog(@"");
//    } error:^(NSError *error) {
//        NSLog(@"");
//    }];
//    RACSignal *single = [self signInSignal];
//    [single subscribeError:^(NSError *error) {
//        NSLog(@"error:%@",error);
//    }];
//    single = letters;

    
    NSError *error = [NSError errorWithDomain:@"1111" code:200 userInfo:@{}];
    [letters sendNext:error];
    
    
    
    
    [self test];
}
/*input*/
- (void)test{
    @weakify(self);
    [[self.view tx_racSignalWhenTap]subscribeNext:^(id x) {
        @strongify(self);
        [self.view endEditing:YES];
    }];
    
    
    self.inputView = [[InPutTextView alloc]initWithFrame:CGRectMake(0, self.view.bottom-60, [UIScreen mainScreen].bounds.size.width, 60)];
    self.inputView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.inputView];
    

   
    
}
- (void)testFuc1{
    //
    self.signInService = [RWDummySignInService new];
    //
    //  // handle text changes for both text fields
    //  [self.usernameTextField addTarget:self action:@selector(usernameTextFieldChanged) forControlEvents:UIControlEventEditingChanged];
    //  [self.passwordTextField addTarget:self action:@selector(passwordTextFieldChanged) forControlEvents:UIControlEventEditingChanged];
    //
    //  // initially hide the failure message
    //  self.signInFailureText.hidden = YES;
    
    self.testBlock = ^NSString *(NSString *obj){
        return @"";
    };
    
    RACSignal *validUsernameSignal =
    [self.usernameTextField.rac_textSignal
     map:^id(NSString *text) {
         return @([self isValidUsername:text]);
     }];
    RACSignal *validPasswordSignal =
    [self.passwordTextField.rac_textSignal
     map:^id(NSString *text) {
         return @([self isValidPassword:text]);
     }];
    
    
    RACSignal *signUpActiveSignal =
    [RACSignal combineLatest:@[validUsernameSignal, validPasswordSignal]
                      reduce:^id(NSNumber*usernameValid, NSNumber *passwordValid){
                          return @([usernameValid boolValue]&&[passwordValid boolValue]);
                      }];
    
    [signUpActiveSignal subscribeNext:^(NSNumber*signupActive){
        self.signInButton.enabled =[signupActive boolValue];
    }];
    
    RAC(self.passwordTextField, backgroundColor) =
    [validPasswordSignal
     map:^id(NSNumber *passwordValid){
         return[passwordValid boolValue] ? [UIColor clearColor]:[UIColor yellowColor];
     }];
    
    RAC(self.usernameTextField, backgroundColor) =
    [validUsernameSignal
     map:^id(NSNumber *passwordValid){
         return[passwordValid boolValue] ? [UIColor clearColor]:[UIColor yellowColor];
     }];
    
    
    
    
    [[[self.signInButton
       rac_signalForControlEvents:UIControlEventTouchUpInside]
      flattenMap:^id(id x){
          RACSignal * single = [self signInSignal];
          return single;
      }]
     subscribeNext:^(id x){
         NSLog(@"Sign in result: %@", x);
     } error:^(NSError *error) {
         NSLog(@"Sign in result: %@", error);
     }completed:^{
         NSLog(@"完成");
     }];
    
    //    [[[self.signInButton
    //       rac_signalForControlEvents:UIControlEventTouchUpInside]
    //      map:^id(id x){
    //          RACSignal * single = [self signInSignal];
    //          return [single subscribeNext:^(id x) {
    //              NSLog(@"x:%@",x);
    //          }error:^(NSError *error) {
    //              NSLog(@"error:x:%@",error);
    //          } completed:^{
    //              NSLog(@"完成");
    //          }];
    //      }]subscribeNext:^(id x) {
    //          NSLog(@"-------x:%@",x);
    //      }];
    
    self.usernameTextField.text = @"user";
    //    self.passwordTextField
    
    //    RACSignal* sig = [self.signInButton
    //                      rac_signalForControlEvents:UIControlEventTouchUpInside];
    RACSubject* sig = [RACSubject subject];
    
    [[sig
      flattenMap:^id(id x){
          RACSignal * single = [self signInSignal];
          return single;
      }]
     subscribeNext:^(id x){
         NSLog(@"Sign in result: %@", x);
     } error:^(NSError *error) {
         NSLog(@"Sign in result: %@", error);
     } completed:^{
         NSLog(@"完成");
     }];
    
    [sig sendNext:@(0)];
    [sig sendCompleted];
    //    [sig sendError:[NSError errorWithDomain:@"aa" code:2 userInfo:nil]];
    
    NSArray *array = @[ @1, @2, @3 ];
    //    NSLog(@"%@\n",[[[array rac_sequence] map:^id (id value){
    //        return [value stringValue];
    //    }] foldLeftWithStart:@"" reduce:^id (id accumulator, id value){
    //
    //        return [accumulator stringByAppendingString:value];
    //    }]);
    NSLog(@"%@\n",[[[array rac_sequence] map:^id (id value){
        return [value stringValue];
    }] foldRightWithStart:@"" reduce:^id (id accumulator, id value){
        NSLog(@"%@===%@",accumulator,value);
        return value;
        //        return [accumulator stringByAppendingString:value];
    }]);
}
- (RACSignal *)signInSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        [self.signInService
         signInWithUsername:self.usernameTextField.text
         password:self.passwordTextField.text
         complete:^(BOOL success){
             if (success) {
                 [subscriber sendNext:@(success)];
                 [subscriber sendCompleted];
             }else{
                 NSError *error = [NSError errorWithDomain:@"登录失败" code:200 userInfo:@{}];
                 [subscriber sendError:error];
             }
         }];
        return nil;
    }];
}
- (BOOL)isValidUsername:(NSString *)username {
  return username.length > 3;
}

- (BOOL)isValidPassword:(NSString *)password {
  return password.length > 3;
}
//
//- (IBAction)signInButtonTouched:(id)sender {
//
//  // disable all UI controls
//  self.signInButton.enabled = NO;
//  self.signInFailureText.hidden = YES;
//  
//  // sign in
//  [self.signInService signInWithUsername:self.usernameTextField.text
//                            password:self.passwordTextField.text
//                            complete:^(BOOL success) {
//                              self.signInButton.enabled = YES;
//                              self.signInFailureText.hidden = success;
//                              if (success) {
//                                [self performSegueWithIdentifier:@"signInSuccess" sender:self];
//                              }
//                            }];
//}
//
//
//// updates the enabled state and style of the text fields based on whether the current username
//// and password combo is valid
//- (void)updateUIState {
//  self.usernameTextField.backgroundColor = self.usernameIsValid ? [UIColor clearColor] : [UIColor yellowColor];
//  self.passwordTextField.backgroundColor = self.passwordIsValid ? [UIColor clearColor] : [UIColor yellowColor];
//  self.signInButton.enabled = self.usernameIsValid && self.passwordIsValid;
//}
//
//- (void)usernameTextFieldChanged {
//  self.usernameIsValid = [self isValidUsername:self.usernameTextField.text];
//  [self updateUIState];
//}
//
//- (void)passwordTextFieldChanged {
//  self.passwordIsValid = [self isValidPassword:self.passwordTextField.text];
//  [self updateUIState];
//}

@end
