//
//  LikeButton.m
//  blocstagram
//
//  Created by Lisa on 4/25/16.
//  Copyright © 2016 Lisa Hackenberger. All rights reserved.
//

#import "LikeButton.h"
#import "CircleSpinnerView.h"

#define kLikedStateImage @"heart-full"
#define kUnlikedStateImage @"heart-empty"

@interface LikeButton ()

@property (nonatomic, strong) CircleSpinnerView *spinnerView;

@end

@implementation LikeButton

//create the spinner view, set up the button
- (instancetype) init {
    self = [super init];
    
    if (self) {
        self.spinnerView = [[CircleSpinnerView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [self addSubview:self.spinnerView];
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10); //provides a buffer between the edge of the button and the content
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop; //specifies the alignment of the button's content; by default it's centered but here we align it to the top so the button doesn't misalign on photos with longer captions
        
        self.likeButtonState = LikeStateNotLiked;
    }
    
    return self;
}

//the spinner view's frame updates whenever the button's frame changes
- (void) layoutSubviews {
    [super layoutSubviews];
    self.spinnerView.frame = self.imageView.frame;
}

//update the button's appearance based on the set state
- (void) setLikeButtonState:(LikeState)likeState {
    _likeButtonState = likeState;
    
    NSString *imageName;
    
    switch (_likeButtonState) {
        case LikeStateLiked:
        case LikeStateUnliking:
            imageName = kLikedStateImage;
            break;
            
        case LikeStateNotLiked:
        case LikeStateLiking:
            imageName = kUnlikedStateImage;
    }
    
    switch (_likeButtonState) {
        case LikeStateLiking:
        case LikeStateUnliking:
            self.spinnerView.hidden = NO;
            self.userInteractionEnabled = NO;
            break;
            
        case LikeStateLiked:
        case LikeStateNotLiked:
            self.spinnerView.hidden = YES;
            self.userInteractionEnabled = YES;
    }
    
    
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
