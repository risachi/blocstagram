//
//  ImagesHeightTests.m
//  blocstagram
//
//  Created by Lisa on 5/23/16.
//  Copyright © 2016 Lisa Hackenberger. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MediaTableViewCell.h"
#import "Media.h"
#import "User.h"

@interface ImagesHeightTests : XCTestCase

@end

@implementation ImagesHeightTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testHeight {
    Media *media = [[Media alloc] init];
    media.image = [UIImage imageNamed:@"insta-test"];
    
    User *user = [[User alloc] init];
    user.userName = @"name";
    media.user = user;
    
    XCTAssertEqual([MediaTableViewCell heightForMediaItem:media width:300 traitCollection:[UITraitCollection traitCollectionWithUserInterfaceIdiom:UIUserInterfaceIdiomPhone]], 138.0);
}

@end
