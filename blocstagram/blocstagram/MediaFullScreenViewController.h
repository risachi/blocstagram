//
//  MediaFullScreenViewController.h
//  blocstagram
//
//  Created by Lisa on 4/17/16.
//  Copyright © 2016 Lisa Hackenberger. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Media;

@interface MediaFullScreenViewController : UIViewController

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) Media *media;

- (instancetype) initWithMedia:(Media *)media;

- (void) centerScrollView;

- (void) recalculateZoomScale;

@end
