//
//  Media.m
//  blocstagram
//
//  Created by Lisa on 3/28/16.
//  Copyright © 2016 Lisa Hackenberger. All rights reserved.
//

#import "User.h"
#import "Media.h"
#import "Comment.h"

@implementation Media

- (instancetype) initWithDictionary:(NSDictionary *)mediaInfo {
    self = [super init];
    if (! self) {
        return self;
    }
    
    self.idNumber = mediaInfo[@"id"];
    self.user = [[User alloc] initWithDictionary:mediaInfo[@"user"]];
    NSString *standardResolutionImageURLString = mediaInfo[@"images"][@"standard_resolution"][@"url"];
    NSURL *standardResolutionImageURL = [NSURL URLWithString:standardResolutionImageURLString];
    
    if (standardResolutionImageURL) {
        self.mediaURL = standardResolutionImageURL;
        self.downloadState = MediaDownloadStateNeedsImage;
    } else {
        self.downloadState = MediaDownloadStateNonRecoverableError;
    }
    
    
    self.caption = [Media getCaptionSafely: mediaInfo];
    
    
    NSMutableArray *commentsArray = [NSMutableArray array];
    
    for (NSDictionary *commentDictionary in mediaInfo[@"comments"][@"data"]) {
        Comment *comment = [[Comment alloc] initWithDictionary:commentDictionary];
        [commentsArray addObject:comment];
    }
    
    self.comments = commentsArray;
    
    // Figure out whether the user has liked an image
    BOOL userHasLiked = [mediaInfo[@"user_has_liked"] boolValue];
    self.likeState = userHasLiked ? LikeStateLiked : LikeStateNotLiked;

    return self;
}

#pragma mark - NSCoding

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        self.idNumber = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(idNumber))];
        self.user = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(user))];
        self.mediaURL = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(mediaURL))];
        self.image = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(image))];
        
        if (self.image) {
            self.downloadState = MediaDownloadStateHasImage;
        } else if (self.mediaURL) {
            self.downloadState = MediaDownloadStateNeedsImage;
        } else {
            self.downloadState = MediaDownloadStateNonRecoverableError;
        }
        
        self.caption = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(caption))];
        self.comments = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(comments))];
        self.likeState = [aDecoder decodeIntegerForKey:NSStringFromSelector(@selector(likeState))];

    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.idNumber forKey:NSStringFromSelector(@selector(idNumber))];
    [aCoder encodeObject:self.user forKey:NSStringFromSelector(@selector(user))];
    [aCoder encodeObject:self.mediaURL forKey:NSStringFromSelector(@selector(mediaURL))];
    [aCoder encodeObject:self.image forKey:NSStringFromSelector(@selector(image))];
    [aCoder encodeObject:self.caption forKey:NSStringFromSelector(@selector(caption))];
    [aCoder encodeObject:self.comments forKey:NSStringFromSelector(@selector(comments))];
    [aCoder encodeInteger:self.likeState forKey:NSStringFromSelector(@selector(likeState))];

}


#pragma mark - Private


+ (NSString *) getCaptionSafely:(NSDictionary *)mediaInfo {
    NSDictionary *captionDictionary = mediaInfo[@"caption"];
    
    if ([captionDictionary isKindOfClass:[NSDictionary class]]) {
        return captionDictionary[@"text"];
    } else {
        return @"";
    }
}

@end
