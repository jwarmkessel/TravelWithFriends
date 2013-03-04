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

#import "FBDialog.h"

@class SFURLRequest;
@class SFFacebookRequest;


@interface SFTextDialog : FBDialog <UITextViewDelegate> {
    UINavigationBar     *_navigationBar;
    UITextView          *_textView;
    BOOL                _noComment;
    SFURLRequest        *_pictureRequest;
    SFFacebookRequest   *_appInfoRequest;
    UIImageView         *_iconView;
    UILabel             *_viaLabel;
    
}

- (void)dismiss:(BOOL)animated;

@property(nonatomic, copy) NSString *placeHolder;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) void (^successBlock)(NSString *message);
@property(nonatomic, copy) void (^cancelBlock)();

@end
