//
//  LoginViewController.h
//  blocstagram
//
//  Created by Lisa on 4/9/16.
//  Copyright © 2016 Lisa Hackenberger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

//any object that needs to be notified when an access token is obtained will use this string
extern NSString *const LoginViewControllerDidGetAccessTokenNotification;

@end
