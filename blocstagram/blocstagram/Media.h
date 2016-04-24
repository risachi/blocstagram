//
//  Media.h
//  blocstagram
//
//  Created by Lisa on 3/28/16.
//  Copyright © 2016 Lisa Hackenberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MediaDownloadState) {
    MediaDownloadStateNeedsImage            = 0,
    MediaDownloadStateDownloadInProgress    = 1,
    MediaDownloadStateNonRecoverableError   = 2,
    MediaDownloadStateHasImage              = 3
};

@class User;

@interface Media : NSObject <NSCoding>

@property (nonatomic, strong) NSString *idNumber;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSURL *mediaURL;
@property (nonatomic, strong) UIImage *image;
//assign instead of strong, because MediaDownloadState (aka NSInteger) is a simple type, not an object
@property (nonatomic, assign) MediaDownloadState downloadState;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSArray *comments;

 - (instancetype) initWithDictionary:(NSDictionary *)mediaDictionary;

@end
