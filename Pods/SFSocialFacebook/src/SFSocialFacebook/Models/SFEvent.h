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
#import "SFObject.h"

@class SFSimpleUser;

@interface SFEvent : SFObject

@property(nonatomic, retain) SFSimpleUser *owner;
@property(nonatomic, retain) NSString *eventDescription;
@property(nonatomic, retain) NSDate *startTime;
@property(nonatomic, retain) NSDate *endTime;
@property(nonatomic, retain) NSString *location;
@property(nonatomic, retain) NSString *privacy;

@end

/** Event `privacy' values **/
 
extern NSString *const kSFEventPrivacyPublic;
extern NSString *const kSFEventPrivacyClosed;
extern NSString *const kSFEventPrivacySecret;