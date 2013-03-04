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

#import "SFSimpleUser.h"

@implementation SFSimpleUser

@synthesize rsvpStatus;

- (NSDictionary *)dictionary
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[super dictionary]];
    [dic addEntriesFromDictionary:[self dictionaryWithValuesForKeys:[NSArray arrayWithObjects:@"rsvpStatus", nil]]];
    
    return dic;
}

@end
