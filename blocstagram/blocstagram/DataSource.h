//
//  DataSource.h
//  blocstagram
//
//  Created by Lisa on 3/28/16.
//  Copyright © 2016 Lisa Hackenberger. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Media;

@interface DataSource : NSObject

+(instancetype) sharedInstance;
@property (nonatomic, strong, readonly) NSArray *mediaItems;

- (void) deleteMediaItem:(Media *)item;
- (void) addMediaItem:(Media *)item;

@end
