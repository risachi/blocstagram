//
//  UIImage+ImageUtilities.h
//  blocstagram
//
//  Created by Lisa on 5/9/16.
//  Copyright © 2016 Lisa Hackenberger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageUtilities)

- (UIImage *) imageWithFixedOrientation;
- (UIImage *) imageResizedToMatchAspectRatioOfSize:(CGSize)size;
- (UIImage *) imageCroppedToRect:(CGRect)cropRect;

@end
