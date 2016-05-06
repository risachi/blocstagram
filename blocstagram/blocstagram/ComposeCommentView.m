//
//  ComposeCommentView.m
//  blocstagram
//
//  Created by Lisa on 5/3/16.
//  Copyright © 2016 Lisa Hackenberger. All rights reserved.
//

#import "ComposeCommentView.h"

@interface ComposeCommentView () <UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *button;

@end

@implementation ComposeCommentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.textView = [UITextView new];
        self.textView.delegate = self;
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button setAttributedTitle:[self commentAttributedString] forState:UIControlStateNormal];
        [self.button addTarget:self action:@selector(commentButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.textView];
        [self.textView addSubview:self.button];
    }
    return self;
}

- (NSAttributedString *) commentAttributedString {
    NSString *baseString = NSLocalizedString(@"COMMENT", @"comment button text");
    NSRange range = [baseString rangeOfString:baseString];
    
    NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] initWithString:baseString];
    
    [commentString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:10] range:range];
    [commentString addAttribute:NSKernAttributeName value:@1.3 range:range];
    [commentString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1] range:range];
    
    return commentString;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    self.textView.frame = self.bounds;
    
    if (self.isWritingComment) {
        self.textView.backgroundColor = [UIColor colorWithRed:0.933 green:0.933 blue:0.933 alpha:1]; /*#eeeeee*/
        self.button.backgroundColor = [UIColor colorWithRed:0.345 green:0.318 blue:0.424 alpha:1]; /*#58516c*/
        
        CGFloat buttonX = CGRectGetWidth(self.bounds) - CGRectGetWidth(self.button.frame) - 20;
        self.button.frame = CGRectMake(buttonX, 10, 80, 20);
    } else {
        self.textView.backgroundColor = [UIColor colorWithRed:0.898 green:0.898 blue:0.898 alpha:1]; /*#e5e5e5*/
        self.button.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1]; /*#999999*/
        
        self.button.frame = CGRectMake(10, 10, 80, 20);
    }
    
    CGSize buttonSize = self.button.frame.size;
    buttonSize.height += 20;
    buttonSize.width += 20;
    //causes the text to wrap instead of writing over the button
    CGFloat blockX = CGRectGetWidth(self.textView.bounds) - buttonSize.width;
    CGRect areaToBlockText = CGRectMake(blockX, 0, buttonSize.width, buttonSize.height);
    UIBezierPath *buttonPath = [UIBezierPath bezierPathWithRect:areaToBlockText];
    
    self.textView.textContainer.exclusionPaths = @[buttonPath];
}

//dismisses the keyboard
- (void) stopComposingComment {
    [self.textView resignFirstResponder];
}

#pragma mark - Setters & Getters

- (void) setIsWritingComment:(BOOL)isWritingComment {
    [self setIsWritingComment:isWritingComment animated:NO];
}

- (void) setIsWritingComment:(BOOL)isWritingComment animated:(BOOL)animated {
    _isWritingComment = isWritingComment;
    
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            [self layoutSubviews];
        }];
    } else {
        [self layoutSubviews];
    }
}

//When text is set, we should update the text view. We should also determine which mode is correct depending on if text is empty:
- (void) setText:(NSString *)text {
    _text = text;
    self.textView.text = text;
    self.textView.userInteractionEnabled = YES;
    self.isWritingComment = text.length > 0;
}

#pragma mark - Button Target

//If the user hasn't started writing, bring up the keyboard.
//If the user is done writing, send the comment to the API.
- (void) commentButtonPressed:(UIButton *) sender {
    if (self.isWritingComment) {
        [self.textView resignFirstResponder];
        self.textView.userInteractionEnabled = NO;
        [self.delegate commentViewDidPressCommentButton:self];
    } else {
        [self setIsWritingComment:YES animated:YES];
        [self.textView becomeFirstResponder];
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [self setIsWritingComment:YES animated:YES];
    [self.delegate commentViewWillStartEditing:self];
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    [self.delegate commentView:self textDidChange:newText];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    BOOL hasComment = (textView.text.length > 0);
    [self setIsWritingComment:hasComment animated:YES];
    
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/* HOW A BASIC ANIMATION LOOKS
 Configure view appearance when the animation starts

[UIView animateWithDuration: How long the animation takes
                 animations:^{
                      Configure view appearance when the animation ends
                 }
                 completion:^(BOOL finished) {
                      Perform any cleanup after the animation has completed
                 }]; */

@end
