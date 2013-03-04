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

#import "SFSimplePost.h"


@implementation SFSimplePost

@synthesize objectId;
@synthesize from;
@synthesize message;
@synthesize picture;
@synthesize link;
@synthesize name;
@synthesize caption;
@synthesize postDescription;
@synthesize source;
@synthesize type;
@synthesize to;
@synthesize actionName;
@synthesize actionLink;
@synthesize createdTime;
@synthesize updatedTime;
@synthesize numberOfLikes;
@synthesize numberOfComments;


- (void)dealloc {
	[objectId release];
    [from release];
	[message release];
	[picture release];
	[link release];
	[name release];
	[caption release];
	[postDescription release];
	[source release];
	[type	release];
    [to release];
    [actionName release];
    [actionLink release];
    [createdTime release];
    [updatedTime release];
    
    [super dealloc];
}

- (NSString *)getIntervalDescriptionFromCreationDate {
	int timeDifference = (int)[[self createdTime] timeIntervalSinceNow];
	NSString *description;
	
	timeDifference = (-1) * timeDifference / 60; // Minutes
	
	if (timeDifference >= 60) {
		timeDifference = timeDifference / 60; // Hours
		
		if (timeDifference >= 24) {
			timeDifference = timeDifference / 24; // Days
			if (timeDifference == 1) {
				description = [NSString stringWithFormat:@"about a day ago"];
			}
			else if (timeDifference < 7) {
				description = [NSString stringWithFormat:@"%d days ago", timeDifference];
			}
			else if (timeDifference == 7) {
				description = [NSString stringWithFormat:@"about a week ago"];
			}
			else if (timeDifference < 30) {
				timeDifference = timeDifference / 7; // Weeks
				description = [NSString stringWithFormat:@"%d weeks ago", timeDifference];
			}
			else if (timeDifference < 60) {
				description = [NSString stringWithFormat:@"about a month ago"];
			}
			else if (timeDifference < 365) {
				timeDifference = timeDifference / 30; // Months
				description = [NSString stringWithFormat:@"%d months ago", timeDifference];
			}
			else if (timeDifference < 730) {
				description = [NSString stringWithFormat:@"about a year ago"];
			}
			else{
				timeDifference = timeDifference / 365; // Years
				description = [NSString stringWithFormat:@"%d years ago", timeDifference];
			}
		}
		else {
			if (timeDifference == 1) {
				description = [NSString stringWithFormat:@"about a hour ago"];
			}
			else {
				description = [NSString stringWithFormat:@"%d hours ago", timeDifference];
			}

		}

	}
	else {
		if (timeDifference == 1) {
			description = [NSString stringWithFormat:@"about a minute ago"];
		}
		else {
			description = [NSString stringWithFormat:@"%d minutes ago", timeDifference];
		}
	}

	return description;
}

@end
