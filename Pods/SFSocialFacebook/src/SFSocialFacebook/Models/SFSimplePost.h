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

#import <Foundation/Foundation.h>

@class SFSimpleUser;


@interface SFSimplePost : NSObject

@property(nonatomic, retain) NSString *objectId;
@property(nonatomic, retain) SFSimpleUser *from;
@property(nonatomic, retain) NSString *message;
@property(nonatomic, retain) NSString *picture;
@property(nonatomic, retain) NSString *link;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *caption;
@property(nonatomic, retain) NSString *postDescription;
@property(nonatomic, retain) NSString *source;
@property(nonatomic, retain) NSString *type;
@property(nonatomic, retain) NSArray *to;
@property(nonatomic, retain) NSString *actionName;
@property(nonatomic, retain) NSString *actionLink;
@property(nonatomic, retain) NSDate *createdTime;
@property(nonatomic, retain) NSDate *updatedTime;
@property(nonatomic) NSUInteger numberOfLikes;
@property(nonatomic) NSUInteger numberOfComments;


- (NSString *)getIntervalDescriptionFromCreationDate;

@end
