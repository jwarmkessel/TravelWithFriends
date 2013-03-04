/*
 * Copyright 2012 I.ndigo
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "SFTextDialog.h"
#import <QuartzCore/QuartzCore.h>
#import "SFSimpleApplication.h"
#import "SFURLRequest.h"
#import "SFUtil.h"
#import "SFSocialFacebook.h"

@interface FBDialog (Private)

- (void)dismiss:(BOOL)animated;

@end

@interface SFTextDialog (Private)

- (void)cancelButtonClicked;
- (void)sendButtonClicked;
- (void)cancel;
- (void)keyboardWillShow:(NSNotification*)notification;
- (void)keyboardWillHide:(NSNotification*)notification;
- (void)updateWebOrientation;

@end

@implementation SFTextDialog

@synthesize placeHolder = _placeHolder, title = _title, successBlock = _successBlock, cancelBlock = _cancelBlock;

- (id)init
{
    [super init];
    
    _serverURL = @"";
    _noComment = YES;
    self.placeHolder = @"Write something...";
    self.title = @"Comment";
    
    if ([_webView respondsToSelector:@selector(scrollView)]) {
        _webView.scrollView.bounces = NO;        
    } else {
        for (id subview in _webView.subviews) {
            if ([[subview class] isSubclassOfClass: [UIScrollView class]]) {
                ((UIScrollView *)subview).bounces = NO;
                break;
            }
        }
    }
    
    _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
    _navigationBar.tintColor = [UIColor colorWithRed:0.23f green:0.35f blue:0.59f alpha:1.0f];
    _navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    UINavigationItem *item = [[UINavigationItem alloc] init];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonClicked)];
    item.leftBarButtonItem = cancelButton;
    [cancelButton release];
    
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleBordered target:self action:@selector(sendButtonClicked)];
    item.rightBarButtonItem = sendButton;
    [sendButton release];
    
    _navigationBar.items = [NSArray arrayWithObject:item];
    [item release];
    
    [self addSubview:_navigationBar];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectZero];
    _textView.delegate = self;
    _textView.textColor = [UIColor grayColor];
    _textView.layer.borderColor = [[UIColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1.0f] CGColor];
    _textView.layer.borderWidth = 1.0f;
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:_textView];
    
    _iconView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_iconView];
    
    _viaLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _viaLabel.textColor = [UIColor colorWithRed:0.47f green:0.47f blue:0.47f alpha:1.0f];
    _viaLabel.font = [UIFont systemFontOfSize:12.0f];
    _viaLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:_viaLabel];
    
    [self bringSubviewToFront:_closeButton];
    
    _appInfoRequest = [[[SFSocialFacebook sharedInstance] loadAppInfoWithSuccess:^(SFSimpleApplication *app) {
        
        _viaLabel.text = [NSString stringWithFormat:@"via %@", app.name];
        
        _pictureRequest = [[SFURLRequest alloc] initWithURL:app.iconUrl success:^(NSData *receivedData) {
            _iconView.image = [UIImage imageWithData:receivedData];
        } failure:^(NSError *error) {
            SFDLog(@"App icon request failed: %@", [error localizedDescription]);
        } cancel:NULL];

    } failure:^(NSError *error) {
        SFDLog(@"App info request failed: %@", [error localizedDescription]);
    } cancel:NULL] retain];
    
    return self;
}

- (void)dealloc
{
    [_pictureRequest cancel];
    [_pictureRequest release];
    
    [_appInfoRequest cancel];
    [_appInfoRequest release];
    
    [_navigationBar release];
    [_textView release];
    [_placeHolder release];
    [_title release];
    [_iconView release];
    [_viaLabel release];
    
    [_successBlock release];
    [_cancelBlock release];
    
    [super dealloc];
}

- (void)show
{
    [super show];
    CGRect titleFrame = _webView.frame;
    titleFrame.size.height = 44.0f;
    _navigationBar.frame = titleFrame;
    
    CGFloat margin = 10.0f;
    
    CGRect textFrame = CGRectOffset(titleFrame, 0.0f, titleFrame.size.height + margin);
    textFrame.origin.x += margin;
    textFrame.size.width -= 2.0f * margin;
    textFrame.size.height = 60.0f;
    _textView.frame = textFrame;
    
    margin = 5.0f;
    
    CGRect iconFrame = CGRectOffset(textFrame, 0.0f, textFrame.size.height + margin);
    iconFrame.size = CGSizeMake(16.0f, 16.0f);
    _iconView.frame = iconFrame;
    
    CGRect viaFrame = CGRectOffset(iconFrame, iconFrame.size.width + margin, 0.0f);
    viaFrame.size.width = textFrame.size.width - iconFrame.size.width - margin;
    _viaLabel.frame = viaFrame;
    
    _navigationBar.topItem.title = _title;
    _textView.text = _placeHolder;
    [_textView becomeFirstResponder];
}

- (void)dismiss:(BOOL)animated
{
    [super dismiss:animated];
}



#pragma mark - Private

- (void)cancelButtonClicked
{
    if (_cancelBlock) {
        _cancelBlock();
    }
}

- (void)sendButtonClicked
{
    if (_successBlock) {
        _successBlock(_textView.text);
    }
}

- (void)cancel
{
    [self cancelButtonClicked];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
}

- (void)keyboardWillHide:(NSNotification *)notification
{   
}

- (void)updateWebOrientation
{
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (_noComment) {
        textView.text = nil;
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        _noComment = YES;
        textView.text = _placeHolder;
        textView.textColor = [UIColor grayColor];
    } else {
        _noComment = NO;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        _navigationBar.topItem.rightBarButtonItem.enabled = NO;
    } else {
        _navigationBar.topItem.rightBarButtonItem.enabled = YES;
    }
}

@end
