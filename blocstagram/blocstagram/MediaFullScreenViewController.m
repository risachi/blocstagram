//
//  MediaFullScreenViewController.m
//  blocstagram
//
//  Created by Lisa on 4/17/16.
//  Copyright © 2016 Lisa Hackenberger. All rights reserved.
//

#import "MediaFullScreenViewController.h"
#import "Media.h"

@interface MediaFullScreenViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) Media *media;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;
@property (nonatomic, strong) UIButton *shareButton;

@end

@implementation MediaFullScreenViewController

- (instancetype) initWithMedia:(Media *)media {
    self = [super init];
    
    if (self) {
        self.media = media;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //here we create and configure a scroll view, and add it as the only subview of self.view
    self.scrollView = [UIScrollView new];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.scrollView];
    
    //we create an image view, set the image, and add it as a subview of the scroll view
    self.imageView = [UIImageView new];
    self.imageView.image = self.media.image;
    
    [self.scrollView addSubview:self.imageView];
    
    //contentSize represents the size of the content view, which is the content being scrolled around
    self.scrollView.contentSize = self.media.image.size;
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
    
    self.doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapFired:)];
    self.doubleTap.numberOfTapsRequired = 2; //numberOfTapsRequired allowes a tap gesture recognizer to require more than one tap to fire
    
    [self.tap requireGestureRecognizerToFail:self.doubleTap]; //requireGestureRecognizerToFail: allows one gesture recognizer to wait for another gesture recognizer to fail before it succeeds; without this line, it would be impossible to double-tap becasue the single tap gesture recognizer woul dfire before the user had a chance to tap twice
    
    [self.scrollView addGestureRecognizer:self.tap];
    [self.scrollView addGestureRecognizer:self.doubleTap];
    
    self.shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.shareButton setTitle:NSLocalizedString(@"Share", @"Share button") forState:UIControlStateNormal];
    [self.shareButton addTarget:self action:@selector(shareButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.shareButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    //the scroll view's frame is set to the view's bounds; this way the scroll view will always take up all of the view's space
    self.scrollView.frame = self.view.bounds;
    CGFloat itemHeight = 70;
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat scrollViewHeight = CGRectGetHeight(self.view.bounds) - itemHeight;
    CGFloat shareButtonWidth = width / 3;
    
    self.shareButton.frame = CGRectMake(CGRectGetMaxX(self.view.bounds) - shareButtonWidth, 0, shareButtonWidth, itemHeight);
    self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.shareButton.frame), width, scrollViewHeight);
    self.shareButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.shareButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.shareButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    //the ratio of the scroll view's width to the image's width vs. the ratio of the scroll view's height to the image's height; whichever is smaller will become our minimumZoomScale
    //this prevents the user from pinching the image so small that there's wasted screen space
    //maximumZoomScale will always be 1 (which is 100%)
    CGSize scrollViewFrameSize = self.scrollView.frame.size;
    CGSize scrollViewContentSize = self.scrollView.contentSize;
    
    CGFloat scaleWidth = scrollViewFrameSize.width / scrollViewContentSize.width;
    CGFloat scaleHeight = scrollViewFrameSize.height / scrollViewContentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.maximumZoomScale = 1;
}

//the user will still be able to see all of a square image on a non-square view (e.g. square Instagram photo on your rectangular phone)
- (void)centerScrollView {
    [self.imageView sizeToFit];
    
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - CGRectGetWidth(contentsFrame)) / 2;
    } else {
        contentsFrame.origin.x = 0;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - CGRectGetHeight(contentsFrame)) / 2;
    } else {
        contentsFrame.origin.y = 0;
    }
    
    self.imageView.frame = contentsFrame;
}

//ensures the image starts out centered
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self centerScrollView];
}

#pragma mark - UIScrollViewDelegate
//tells the scroll view which view to zoom in and out on
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

//calls centerScrollView after the user has changed the zoom level
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self centerScrollView];
}

#pragma mark - Gesture Recognizers
//when the user single-taps, dismiss the view controller:
- (void) tapFired:(UITapGestureRecognizer *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//when the user double-taps, adjust the zoom level:
- (void) doubleTapFired:(UITapGestureRecognizer *)sender {
    if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) {
        //if the current zoom scale is already as small as it can be, double-tapping will zoom in
        //this works by calculating a rectangle using the user's finger as a center point, and telling the scroll view to zoom in on that rectangle
        CGPoint locationPoint = [sender locationInView:self.imageView];
        
        CGSize scrollViewSize = self.scrollView.bounds.size;
        
        CGFloat width = scrollViewSize.width / self.scrollView.maximumZoomScale;
        CGFloat height = scrollViewSize.height / self.scrollView.maximumZoomScale;
        CGFloat x = locationPoint.x - (width / 2);
        CGFloat y = locationPoint.y - (height / 2);
        
        [self.scrollView zoomToRect:CGRectMake(x, y, width, height) animated:YES];
    } else {
        //if the current zoom scals is larger, then zomo out to the minimum scale
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    }
}

- (void) shareButtonPressed {
    if (self.imageView) {
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.imageView.image] applicationActivities:nil];
        [self presentViewController:activityViewController animated:YES completion:nil];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
