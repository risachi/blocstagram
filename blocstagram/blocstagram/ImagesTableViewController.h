//
//  ImagesTableViewController.h
//  blocstagram
//
//  Created by Lisa on 3/26/16.
//  Copyright © 2016 Lisa Hackenberger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagesTableViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, assign) CGFloat decelerationRate;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic) BOOL dragging;

@end
