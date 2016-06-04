//
//  ComposeCommentViewTests.m
//  blocstagram
//
//  Created by Lisa on 5/23/16.
//  Copyright © 2016 Lisa Hackenberger. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ComposeCommentView.h"

@interface ComposeCommentViewTests : XCTestCase

@end

@implementation ComposeCommentViewTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma tests

- (void)testCommentSetToYesIfText {
    ComposeCommentView *view = [[ComposeCommentView alloc] init];
    [view setText:@"hello"];
    
    XCTAssertEqual(view.isWritingComment, YES);
}

- (void)testCommentSetToNoIfNotText {
    ComposeCommentView *view = [[ComposeCommentView alloc] init];
    [view setText:@""];
    
    XCTAssertEqual(view.isWritingComment, NO);
}

@end
