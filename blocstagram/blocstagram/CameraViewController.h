//
//  CameraViewController.h
//  blocstagram
//
//  Created by Lisa on 5/9/16.
//  Copyright © 2016 Lisa Hackenberger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CameraViewController;

@protocol CameraViewControllerDelegate <NSObject>

- (void) cameraViewController:(CameraViewController *)cameraViewController didCompleteWithImage:(UIImage *)image;

@end

@interface CameraViewController : UIViewController

@property (nonatomic, weak) NSObject <CameraViewControllerDelegate> *delegate;

@end
