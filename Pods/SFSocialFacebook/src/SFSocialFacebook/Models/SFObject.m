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

#import "SFObject.h"

@implementation SFObject

@synthesize objectId;
@synthesize name;

- (void)dealloc
{
    [objectId release];
    [name release];
    
    [super dealloc];
}

- (NSString *)pictureUrl
{
    return [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture", [self objectId]];
}

- (NSString *)pictureUrlWithType:(SFObjectPictureType)type
{
    NSString *pictureType = nil;
    switch (type) {
        case SFObjectPictureTypeSquare:
            pictureType = @"square";
            break;
        case SFObjectPictureTypeSmall:
            pictureType = @"small";
            break;
        case SFObjectPictureTypeNormal:
            pictureType = @"normal";
            break;
        case SFObjectPictureTypeLarge:
            pictureType = @"large";
            break;
        default:
            pictureType = @"";
            break;
    }
    return [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=%@", [self objectId], pictureType];
}

- (NSDictionary *)dictionary
{
    return [self dictionaryWithValuesForKeys:[NSArray arrayWithObjects:@"objectId", @"name", nil]];
}

- (NSString *)description
{
    return [[self dictionary] description];
}

@end
