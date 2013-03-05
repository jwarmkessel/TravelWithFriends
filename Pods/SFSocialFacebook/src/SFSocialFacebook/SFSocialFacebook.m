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

#import "SFSocialFacebook.h"
#import "SFUtil.h"
#import "SBJSON.h"
#import "SFURLRequest.h"
#import "SFComment.h"
#import "SFTextDialog.h"

/*
 
 The last thing that needs to be accomplished to enable SSO support is a change to the .plist 
 file that handles configuration for the app. XCode creates this file automatically when the 
 project is created. A specific URL needs to be registered in this file that uniquely identifies 
 the app with iOS. Create a new row named URL types with a single item, URL Schemes, containing 
 a single value, fbYOUR_APP_ID (the literal characters fb followed by your app id). 
 
 */

NSString *const kSFAccessTokenKey = @"FBAccessTokenKey";
NSString *const kSFExpirationDateKey = @"FBExpirationDateKey";


@interface SFSocialFacebook (Private)

- (id)initWithAppId:(NSString *)appId appSecret:(NSString *)appSecret urlSchemeSuffix:(NSString *)urlSchemeSuffix andPermissions:(NSArray *)permissions;

- (SFFacebookRequest *)profileFeedWithGraphPath:(NSString *)graphPath needsLogin:(BOOL)needsLogin success:(SFListObjectsBlock)successBlock failure:(SFFailureBlock)failureBlock cancel:(SFBasicBlock)cancelBlock;
- (SFFacebookRequest *)commentsFromPostWithGraphPath:(NSString *)graphPath needsLogin:(BOOL)needsLogin success:(SFListObjectsBlock)successBlock failure:(SFFailureBlock)failureBlock cancel:(SFBasicBlock)cancelBlock;
- (SFFacebookRequest *)usersWhoLikedPostWithGraphPath:(NSString *)graphPath needsLogin:(BOOL)needsLogin success:(SFListObjectsBlock)successBlock failure:(SFFailureBlock)failureBlock cancel:(SFBasicBlock)cancelBlock;

- (void)saveLoginInfo;
- (void)loadLoginInfo;
- (void)clearLoginInfo;

- (NSDictionary *)parseURLParams:(NSString *)query;
- (void)releaseDialogBlocks;
- (NSString *)nextPageUrl:(NSDictionary *)paging;
- (NSMutableDictionary *)paramsForPost:(SFSimplePost *)post;

- (NSDate *)dateWithFacebookUnixTimestamp:(NSTimeInterval)unixTimestamp;
- (NSTimeInterval)facebookUnixTimestampFromDate:(NSDate *)date;

@end


@implementation SFSocialFacebook

#pragma mark - Singleton implementation

// According http://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CocoaFundamentals/CocoaObjects/CocoaObjects.html#//apple_ref/doc/uid/TP40002974-CH4-SW32

static SFSocialFacebook *_instance;

+ (SFSocialFacebook *)sharedInstance
{
    if (_instance == nil) {
        @throw [NSException exceptionWithName:@"SFSocialFacebook Exception" reason:@"There is no singleton instance. You must invoke sharedInstanceWithAppId: first." userInfo:nil];
    }
    
    return _instance;
}

+ (SFSocialFacebook *)sharedInstanceWithAppId:(NSString *)appId appSecret:(NSString *)appSecret urlSchemeSuffix:(NSString *)urlSchemeSuffix andPermissions:(NSArray *)permissions
{
	@synchronized(self) {
        if (_instance == nil) {
            _instance = [[super allocWithZone:NULL] initWithAppId:appId appSecret:appSecret urlSchemeSuffix:urlSchemeSuffix andPermissions:permissions];
        }
    }
    return _instance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;
}

- (oneway void)release
{
    // do nothing
}

- (id)autorelease
{
    return self;
}

#pragma mark -

- (id)init
{
    self = [super init];
    if (self) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        _localTimeZone = [[NSTimeZone localTimeZone] retain];
        _facebookTimeZone = [[NSTimeZone timeZoneWithAbbreviation:@"PST"] retain];
    }
    
    return self;
}

#pragma mark - Private Constructor

- (id)initWithAppId:(NSString *)appId appSecret:(NSString *)appSecret urlSchemeSuffix:(NSString *)urlSchemeSuffix andPermissions:(NSArray *)permissions
{
    self = [self init];
    if (self) {
#ifdef DEBUG
        
        // Check App ID:
        // This is really a warning for the developer, this should not
        // happen in a completed app
        if (!appId) {
            UIAlertView *alertView = [[UIAlertView alloc] 
                                      initWithTitle:@"Facebook Setup Error" 
                                      message:@"Missing app ID. You cannot run the app until you provide this in the code." 
                                      delegate:self 
                                      cancelButtonTitle:@"OK" 
                                      otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        } else {
            // Now check that the URL scheme fb[app_id]://authorize is in the .plist and can
            // be opened, doing a simple check without local app id factored in here
            NSString *url = [NSString stringWithFormat:@"fb%@://authorize",appId];
            BOOL bSchemeInPlist = NO; // find out if the sceme is in the plist file.
            NSArray* aBundleURLTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
            if ([aBundleURLTypes isKindOfClass:[NSArray class]] && 
                ([aBundleURLTypes count] > 0)) {
                
                for (NSDictionary *aBundleURLType in aBundleURLTypes) {
                    
                    if ([aBundleURLType isKindOfClass:[NSDictionary class]]) {
                        
                        NSArray* aBundleURLSchemes = [aBundleURLType objectForKey:@"CFBundleURLSchemes"];
                        if ([aBundleURLSchemes isKindOfClass:[NSArray class]] &&
                            ([aBundleURLSchemes count] > 0)) {
                            
                            for (NSString *scheme in aBundleURLSchemes) {
                                
                                if ([scheme isKindOfClass:[NSString class]] && 
                                    [url hasPrefix:scheme]) {
                                    bSchemeInPlist = YES;
                                    break;
                                }
                            }
                            
                            if (bSchemeInPlist) {
                                break;
                            }
                        }
                    }
                }
            }
            // Check if the authorization callback will work
            BOOL bCanOpenUrl = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString: url]];
            if (!bSchemeInPlist || !bCanOpenUrl) {
                UIAlertView *alertView = [[UIAlertView alloc] 
                                          initWithTitle:@"Facebook Setup Error" 
                                          message:@"Invalid or missing URL scheme. You cannot run the app until you set up a valid URL scheme in your .plist." 
                                          delegate:self 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil];
                [alertView show];
                [alertView release];
            } else {
#endif
                // Everything is OK
                _facebook = [[Facebook alloc] initWithAppId:appId urlSchemeSuffix:urlSchemeSuffix andDelegate:self];
                _permissions = [permissions retain];
                
                [self loadLoginInfo];
                
                _app = [[SFSimpleApplication alloc] init];
                _app.objectId = appId;
                
                _appSecret = [appSecret copy];
#ifdef DEBUG
            }
        }
#endif
    }
    return self;
}

#pragma mark - Methods

- (BOOL)handleOpenURL:(NSURL *)url
{
	return [_facebook handleOpenURL:url];
}

- (BOOL)isSessionValid:(BOOL)needsLogin
{
    BOOL isValid = NO;
    if (needsLogin) {
        isValid = [_facebook isSessionValid];
    } else {
        isValid = [_facebook isSessionValid] || _appAccessToken;
    }
    
    return isValid;
}


- (void)getAppAccessTokenWithSuccess:(void (^)(NSString *))successBlock failure:(SFFailureBlock)failureBlock
{
    NSLog(@"IS THIS EVER CALLED?");
    [SFURLRequest requestWithURL:[NSString stringWithFormat:@"https://graph.facebook.com/oauth/access_token?client_id=%@&client_secret=%@&grant_type=client_credentials", _app.objectId, _appSecret] 
                         success:^(NSData *receivedData) {
                             NSString *response = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
                             NSArray *components = [response componentsSeparatedByString:@"="];
                             [response release];
                             
                             if ([components count] == 2) {
                                 // Success
                                 [_appAccessToken release];
                                 _appAccessToken = [[components objectAtIndex:1] retain];
                                 if (successBlock) {
                                     successBlock(_appAccessToken);
                                 }
                             } else {
                                 // Error
                                 if (failureBlock) {
                                     failureBlock(SFError(@"Could not parse App Login Acess Token"));
                                 }
                             }
                         } 
                         failure:failureBlock cancel:NULL];
}

- (void)loginWithSuccess:(SFBasicBlock)successBlock failure:(SFDidNotLoginBlock)failureBlock
{
    _loginBlock = [successBlock copy];
    _notLoginBlock = [failureBlock copy];
    
	[_facebook authorize:_permissions];
}

- (void)logoutWithSuccess:(SFBasicBlock)successsBlock
{
    _logoutBlock = [successsBlock copy];
    
	[_facebook logout];
}

- (SFFacebookRequest *)uninstallApp:(SFBasicBlock)successBlock failure:(SFFailureBlock)failureBlock cancel:(SFBasicBlock)cancelBlock
{
    SFFacebookRequest *request = nil;
    
    if ([_facebook isSessionValid]) {
        // Passing empty (no) parameters unauthorizes the entire app. To revoke individual permissions
        // add a permission parameter with the name of the permission to revoke.
        NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:nil];
        
        request = [self facebookRequestWithGraphPath:@"me/permissions" params:params httpMethod:@"DELETE" needsLogin:YES success:^(id result) {
            [self logoutWithSuccess:nil];
            if (successBlock) {
                successBlock();
            }
        } failure:failureBlock cancel:cancelBlock];
        
        [params release];
    }
    else if (failureBlock) {
        failureBlock(SFError(@"User is not logged in"));
    }
    
    return request;
}

- (SFFacebookRequest *)loadAppInfoWithSuccess:(void (^)(SFSimpleApplication *))successBlock failure:(SFFailureBlock)failureBlock cancel:(SFBasicBlock)cancelBlock
{
    if (_app.name) {
        if (successBlock) {
            successBlock(_app);
        }
        
        return nil;
    } else {
    
        SFFacebookRequest *request = [self facebookRequestWithGraphPath:[NSString stringWithFormat:@"%@?fields=name,icon_url", _app.objectId] needsLogin:NO success:^(id result) {
            
            _app.name = [result objectForKey:@"name"];
            _app.iconUrl = [result objectForKey:@"icon_url"];
            
            if (successBlock) {
                successBlock(_app);
            }
            
        } failure:failureBlock cancel:cancelBlock];
        
        return request;
    }
}


- (SFFacebookRequest *)profileFeed:(NSString *)profileId pageSize:(NSUInteger)pageSize needsLogin:(BOOL)needsLogin success:(SFListObjectsBlock)successBlock failure:(SFFailureBlock)failureBlock cancel:(SFBasicBlock)cancelBlock
{
    return [self profileFeedWithGraphPath:[NSString stringWithFormat:@"%@/feed?date_format=U&limit=%d&fields=id,from,message,picture,link,name,caption,description,source,type,created_time,updated_time,comments,likes", profileId, pageSize] needsLogin:needsLogin success:successBlock failure:failureBlock cancel:cancelBlock];
}

- (SFFacebookRequest *)profileFeedNextPage:(NSString *)nextPageUrl success:(SFListObjectsBlock)successBlock failure:(SFFailureBlock)failureBlock cancel:(SFBasicBlock)cancelBlock
{
    return [self profileFeedWithGraphPath:nextPageUrl needsLogin:NO success:successBlock failure:failureBlock cancel:cancelBlock];
}

- (void)publishPost:(SFSimplePost *)post success:(SFCreateObjectBlock)successBlock failure:(SFFailureBlock)failureBlock cancel:(SFBasicBlock)cancelBlock
{
    if (![_facebook isSessionValid]) {
        [self loginWithSuccess:^{
            [self publishPost:post success:successBlock failure:failureBlock cancel:cancelBlock];
        } failure:^(BOOL cancelled) {
            if (cancelled)
            {
                if (cancelBlock) {
                    cancelBlock();
                }
            }
            else if (failureBlock)
            {
                failureBlock(SFError(@"Could not login"));
            }
        }];
    }
    else
    {
        _currentDialogRequest = SFDialogRequestPublish;
        _dialogSuccessBlock = [successBlock copy];
        _dialogFailureBlock = [failureBlock copy];
        _dialogCancelBlock = [cancelBlock copy];
        
        [_facebook dialog:@"feed" andParams:[self paramsForPost:post] andDelegate:self];
    }
}

- (SFFacebookRequest *)publishPostWithoutDialog:(SFSimplePost *)post success:(SFCreateObjectBlock)successBlock failure:(SFFailureBlock)failureBlock cancel:(SFBasicBlock)cancelBlock
{
    SFFacebookRequest *request = [self facebookRequestWithGraphPath:@"me/feed" params:[self paramsForPost:post] httpMethod:@"POST" needsLogin:YES success:^(id result) {
        if (successBlock) {
            successBlock([result objectForKey:@"id"]);
        }
    } failure:failureBlock cancel:cancelBlock];
    
    return request;
}

- (SFFacebookRequest *)friendsWithPageSize:(NSUInteger)pageSize success:(SFListObjectsBlock)successBlock failure:(SFFailureBlock)failureBlock cancel:(SFBasicBlock)cancelBlock
{
    return [self friendsNextPage:[NSString stringWithFormat:@"me/friends?limit=%d", pageSize] success:successBlock failure:failureBlock cancel:cancelBlock];
}

- (SFFacebookRequest *)friendsNextPage:(NSString *)nextPageUrl success:(SFListObjectsBlock)successBlock failure:(SFFailureBlock)failureBlock cancel:(SFBasicBlock)cancelBlock
{
    SFFacebookRequest *request = [self facebookRequestWithGraphPath:[nextPageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] needsLogin:YES success:^(id result) {
        
        SFSimpleUser *user = nil;
        NSMutableArray *friends = [[NSMutableArray alloc] init];
        
        for (id ob in [result objectForKey:@"data"]) {
            user = [[SFSimpleUser alloc] init];
            [user setObjectId:[ob objectForKey:@"id"]];
            [user setName:[ob objectForKey:@"name"]];
            
            [friends addObject:user];
            [user release];
        }
        
        NSString *nextPage = [self nextPageUrl:[result objectForKey:@"paging"]];
        
        if (successBlock) {
            successBlock(friends, nextPage);
        }
        [friends release];
        
    } failure:failureBlock cancel:cancelBlock];
    
    return request;
}

- (SFFacebookRequest *)eventWithId:(NSString *)eventId needsLogin:(BOOL)needsLogin success:(void (^)(SFEvent *))successBlock failureBlock:(SFFailureBlock)failureBlock cancel:(SFBasicBlock)cancelBlock
{
    SFFacebookRequest *request = [self facebookRequestWithGraphPath:[NSString stringWithFormat:@"%@?date_format=U", eventId] needsLogin:needsLogin success:^(id result) {
        
        if (successBlock) {
            
            SFEvent *event = nil;
            NSString *eventId = [result objectForKey:@"id"];
            
            if (eventId) {
                event = [[SFEvent alloc] init];
                
                event.objectId = eventId;
                event.name = [result objectForKey:@"name"];
                event.eventDescription = [result objectForKey:@"description"];
                event.startTime = [self dateWithFacebookUnixTimestamp:[[result objectForKey:@"start_time"] doubleValue]];
                event.endTime = [self dateWithFacebookUnixTimestamp:[[result objectForKey:@"end_time"] doubleValue]];
                event.location = [result objectForKey:@"location"];
                event.privacy = [result objectForKey:@"privacy"];
                
                NSDictionary *ownerDic = [result objectForKey:@"owner"];
                if (ownerDic) {
                    SFSimpleUser *owner = [[SFSimpleUser alloc] init];
                    owner.objectId = [ownerDic objectForKey:@"id"];
                    owner.name = [ownerDic objectForKey:@"name"];
                    event.owner = owner;
                    [owner release];
                }
            }
            
            successBlock(event);
            [event release];
        }
        
    } failure:failureBlock cancel:cancelBlock];
    
    return request;
}

- (SFFacebookRequest *)eventsWithPageSize:(NSUInteger)pageSize success:(SFListObjectsBlock)successBlock failure:(SFFailureBlock)failureBlock cancel:(SFBasicBlock)cancelBlock
{
    return [self eventsNextPage:[NSString stringWithFormat:@"me/events?fields=id,name,start_time,end_time,location&date_format=U&limit=%d", pageSize] success:successBlock failure:failureBlock cancel:cancelBlock];
}

- (SFFacebookRequest *)eventsNextPage:(NSString *)nextPageUrl success:(SFListObjectsBlock)successBlock failure:(SFFailureBlock)failureBlock cancel:(SFBasicBlock)cancelBlock
{
    SFFacebookRequest *request = [self facebookRequestWithGraphPath:nextPageUrl needsLogin:YES success:^(id result) {
        
        SFEvent *event = nil;
        NSMutableArray *events = [[NSMutableArray alloc] init];
        
        for (id ob in [result objectForKey:@"data"]) {
            event = [[SFEvent alloc] init];
            [event setObjectId:[ob objectForKey:@"id"]];
            [event setName:[ob objectForKey:@"name"]];
            [event setStartTime:[self dateWithFacebookUnixTimestamp:[[ob objectForKey:@"start_time"] doubleValue]]];
            [event setEndTime:[self dateWithFacebookUnixTimestamp:[[ob objectForKey:@"end_time"] doubleValue]]];
            [event setLocation:[ob objectForKey:@"location"]];
            
            [events addObject:event];
            [event release];
        }
        
        NSString *nextPage = [self nextPageUrl:[result objectForKey:@"paging"]];
        
        if (successBlock) {
            successBlock(events, nextPage);
        }
        [events release];

        
    } failure:failureBlock cancel:cancelBlock];
    
    return request;
}

- (SFFacebookRequest *)createEvent:(SFEvent *)event success:(SFCreateObjectBlock)successBlock failure:(SFFailureBlock)failureBlock cancel:(SFBasicBlock)cancelBlock
{
    if (event) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        NSString *value = [event name];
        if (value) {
            [params setObject:value forKey:@"name"];
        } else {
            failureBlock(SFError(@"Event name is required"));
            return nil;
        }
        
        NSDate *date = [event startTime];
        if (date) {
            [params setObject:[NSString stringWithFormat:@"%.0lf" , [self facebookUnixTimestampFromDate:date]] forKey:@"start_time"];
            
            date = [event endTime];
            if (date) {
                [params setObject:[NSString stringWithFormat:@"%.0lf" , [self facebookUnixTimestampFromDate:date]] forKey:@"end_time"];
            }
            
        } else {
            failureBlock(SFError(@"Event start time is required"));
            return nil;
        }
        
        value = [event eventDescription];
        if (value) {
            [params setObject:value forKey:@"description"];
        }
        
        value = [event location];
        if (value) {
            [params setObject:value forKey:@"location"];
        }
        
        value = [event privacy];
        if (value) {
            [params setObject:value forKey:@"privacy_type"];
        } else {
            [params setObject:kSFEventPrivacySecret forKey:@"privacy_type"];
        }
        
        SFFacebookRequest *request = [self facebookRequestWithGraphPath:@"me/events" params:params httpMethod:@"POST" needsLogin:YES success:^(id result) {
            
            if (successBlock) {
                successBlock([result objectForKey:@"id"]);
            }
            
        } failure:failureBlock cancel:cancelBlock];
        
        return request;
        
    } else {
        failureBlock(SFError(@"Event cannot be nil."));
        return nil;
    }
}

- (SFFacebookRequest *)inviteUsers:(NSArray *)userIds toEvent:(NSString *)eventId success:(SFBasicBlock)successBlock failure:(SFFailureBlock)failureBlock cancel:(SFBasicBlock)cancelBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[userIds componentsJoinedByString:@","] forKey:@"users"];
    
    SFFacebookRequest *request = [self facebookRequestWithGraphPath:[NSString stringWithFormat:@"%@/invited", eventId] params:params httpMethod:@"POST" needsLogin:YES success:^(id result) {
        
        if (successBlock) {
            successBlock();
        }
        
    } failure:failureBlock cancel:cancelBlock];
    [params release];
    
    return request;
}

- (SFFacebookRequest *)invitedUsersForEvent:(NSString *)eventId pageSize:(NSUInteger)pageSize success:(SFListObjectsBlock)successBlock failure:(SFFailureBlock)failureBlock cancel:(SFBasicBlock)cancelBlock
{
    return [self invitedUsersForEvent:eventId rsvpStatus:SFUserRSVPStatusUnknown pageSize:pageSize success:successBlock failure:failureBlock cancel:cancelBlock];
}

- (SFFacebookRequest *)invitedUsersForEvent:(NSString *)eventId rsvpStatus:(SFUserRSVPStatus)rsvpStatus pageSize:(NSUInteger)pageSize success:(SFListObjectsBlock)successBlock failure:(SFFailureBlock)failureBlock cancel:(SFBasicBlock)cancelBlock
{
    NSString *inviteeType = nil;
    
    switch (rsvpStatus) {
        case SFUserRSVPStatusUnknown:
            inviteeType = @"invited";
            break;
        case SFUserRSVPStatusAttending:
            inviteeType = @"attending";
            break;
        case SFUserRSVPStatusMaybe:
            inviteeType = @"maybe";
            break;
        case SFUserRSVPStatusDeclined:
            inviteeType = @"declined";
            break;
        case SFUserRSVPStatusNotReplied:
            inviteeType = @"noreply";
            break;
        default:
            break;
    }
    
    return [self invitedUsersNextPage:[NSString stringWithFormat:@"%@/%@?limit=%d", eventId, inviteeType, pageSize] success:successBlock failure:failureBlock cancel:cancelBlock];
}

- (SFFacebookRequest *)invitedUsersNextPage:(NSString *)nextPageUrl success:(SFListObjectsBlock)successBlock failure:(SFFailureBlock)failureBlock cancel:(SFBasicBlock)cancelBlock
{
    SFFacebookRequest *request = [self facebookRequestWithGraphPath:nextPageUrl needsLogin:YES success:^(id result) {
        
		SFSimpleUser *user;
		NSMutableArray *users = [[NSMutableArray alloc] init];
		
		for (id ob in [result objectForKey:@"data"]) {
			user = [[SFSimpleUser alloc] init];
			[user setObjectId:[ob objectForKey:@"id"]];
			[user setName:[ob objectForKey:@"name"]];
            
            NSString *rsvpStatus = [ob objectForKey:@"rsvp_status"];
            
            if (rsvpStatus != nil) {
                if ([rsvpStatus isEqualToString:@"not_replied"]) {
                    [user setRsvpStatus:SFUserRSVPStatusNotReplied];
                }
                else if ([rsvpStatus isEqualToString:@"attending"]) {
                    [user setRsvpStatus:SFUserRSVPStatusAttending];
                }
                else if ([rsvpStatus isEqualToString:@"declined"]) {
                    [user setRsvpStatus:SFUserRSVPStatusDeclined];
                }
                else if ([rsvpStatus isEqualToString:@"unsure"]) {
                    [user setRsvpStatus:SFUserRSVPStatusMaybe];
                }
            }
			
			[users addObject:user];
			[user release];
		}
		
        NSString *nextPage = [self nextPageUrl:[result objectForKey:@"paging"]];
		
		if (successBlock) {
            successBlock(users, nextPage);
		}
        [users release];
        
    } failure:failureBlock cancel:cancelBlock];
    
    return request;
}

- (SFFacebookRequest *)attendEvent:(NSString *)eventId success:(SFBasicBlock)successBlock failure:(SFFailureBlock)failureBlock cancel:(SFBasicBlock)cancelBlock
{
    SFFacebookRequest *request = [self facebookRequestWithGraphPath:[NSString stringWithFormat:@"%@/attending", eventId] params:[NSMutableDictionary dictionary] httpMethod:@"POST" needsLogin:YES success:^(id result) {
        
        if (successBlock) {
            successBlock();
        }
        
    } failure:failureBlock cancel:cancelBlock];
    
    return request;
}

- (SFFacebookRequest *)commentsFromPost:(NSString *)postId pageSize:(NSUInteger)pageSize needsLogin:(BOOL)needsLogin success:(SFListObjectsBlock)successBlock failure:(SFFailureBlock)failureBlock cancel:(SFBasicBlock)cancelBlock
{
    return [self commentsFromPostWithGraphPath:[NSString stringWithFormat:@"%@/comments?date_format=U&limit=%d", postId, pageSize] needsLogin:needsLogin success:successBlock failure:failureBlock cancel:cancelBlock];
}

- (SFFacebookRequest *)commentsFromPostNextPage:(NSString *)nextPageUrl success:(SFListObjectsBlock)successBlock failure:(SFFailureBlock)failureBlock cancel:(SFBasicBlock)cancelBlock
{
    return [self commentsFromPostWithGraphPath:nextPageUrl needsLogin:NO success:successBlock failure:failureBlock cancel:cancelBlock];
}

- (SFFacebookRequest *)usersWhoLikedPost:(NSString *)postId pageSize:(NSUInteger)pageSize needsLogin:(BOOL)needsLogin success:(SFListObjectsBlock)successBlock failure:(SFFailureBlock)failureBlock cancel:(SFBasicBlock)cancelBlock
{
    return [self usersWhoLikedPostWithGraphPath:[NSString stringWithFormat:@"%@/likes?date_format=U&limit=%d", postId, pageSize] needsLogin:needsLogin success:successBlock failure:failureBlock cancel:cancelBlock];
}

- (SFFacebookRequest *)usersWhoLikedPostNextPage:(NSString *)nextPageUrl success:(SFListObjectsBlock)successBlock failure:(SFFailureBlock)failureBlock cancel:(SFBasicBlock)cancelBlock
{
    return [self usersWhoLikedPostWithGraphPath:nextPageUrl needsLogin:NO success:successBlock failure:failureBlock cancel:cancelBlock];
}

- (void)commentPost:(NSString *)postId success:(SFCreateObjectBlock)successBlock failure:(SFFailureBlock)failureBlock cancel:(SFBasicBlock)cancelBlock
{
    if (![_facebook isSessionValid]) {
        
        [self loginWithSuccess:^{
            [self commentPost:postId success:successBlock failure:failureBlock cancel:cancelBlock];
        } failure:^(BOOL cancelled) {
            if (cancelled) {
                if (cancelBlock) {
                    cancelBlock();
                }
            } else {
                if (failureBlock) {
                    failureBlock(SFError(@"Could not login"));
                }
            }
        }];
        
    } else {
    
        __block SFTextDialog *dialog = [[SFTextDialog alloc] init];
        
        __block SFSocialFacebook *blockSelf = self;
        
        dialog.successBlock = ^(NSString *message) {
            
            if (_fbRequest == nil) {
                
                _fbRequest = [[blockSelf facebookRequestWithGraphPath:[NSString stringWithFormat:@"%@/comments", postId] params:[NSMutableDictionary dictionaryWithObject:message forKey:@"message"] httpMethod:@"POST" needsLogin:YES success:^(id result) {
                    
                    if (successBlock) {
                        successBlock([result objectForKey:@"id"]);
                    }
                    
                    [_fbRequest release], _fbRequest = nil;
                    [dialog dismiss:YES];
                } failure:^(NSError *error) {
                    
                    if (failureBlock) {
                        failureBlock(error);
                    }
                    
                    [_fbRequest release], _fbRequest = nil;
                    [dialog dismiss:YES];
                } cancel:NULL] retain];
            }
        };
        
        dialog.cancelBlock = ^{
            
            if (_fbRequest) {
                [_fbRequest cancel];
                [_fbRequest release], _fbRequest = nil;
            }
            
            if (cancelBlock) {
                cancelBlock();
            }
            
            [dialog dismiss:YES];
        };
        
        [dialog show];
        [dialog release];
    }
}

- (SFFacebookRequest *)likeObject:(NSString *)objectId success:(SFBasicBlock)successBlock failure:(SFFailureBlock)failureBlock cancel:(SFBasicBlock)cancelBlock
{
    SFFacebookRequest *request = [self facebookRequestWithGraphPath:[NSString stringWithFormat:@"%@/likes", objectId] params:[NSMutableDictionary dictionary] httpMethod:@"POST" needsLogin:YES success:^(id result) {
        
        if (successBlock) {
            successBlock();
        }
        
    } failure:failureBlock cancel:cancelBlock];
    
    return request;
}

- (void)publishPost:(SFSimplePost *)post onPage:(NSString *)pageId success:(SFCreateObjectBlock)successBlock failure:(SFFailureBlock)failureBlock cancel:(SFBasicBlock)cancelBlock
{
    if (![_facebook isSessionValid]) {
        
        [self loginWithSuccess:^{
            [self publishPost:post onPage:pageId success:successBlock failure:failureBlock cancel:cancelBlock];
        } failure:^(BOOL cancelled) {
            if (cancelled) {
                if (cancelBlock) {
                    cancelBlock();
                }
            } else {
                if (failureBlock) {
                    failureBlock(SFError(@"Could not login"));
                }
            }
        }];
        
    } else {
        
        __block SFTextDialog *dialog = [[SFTextDialog alloc] init];
        dialog.title = @"Post to Wall";
        dialog.placeHolder = @"Say something about this...";
        
        __block SFSocialFacebook *blockSelf = self;
        
        dialog.successBlock = ^(NSString *message) {
            
            if (_fbRequest == nil) {
                
                NSMutableDictionary *params = [blockSelf paramsForPost:post];
                
                [params setObject:message forKey:@"message"];
                
                _fbRequest = [[blockSelf facebookRequestWithGraphPath:[NSString stringWithFormat:@"%@/feed", pageId] params:params httpMethod:@"POST" needsLogin:YES success:^(id result) {
                    
                    if (successBlock) {
                        successBlock([result objectForKey:@"id"]);
                    }
                    
                    [_fbRequest release], _fbRequest = nil;
                    [dialog dismiss:YES];
                } failure:^(NSError *error) {
                    
                    if (failureBlock) {
                        failureBlock(error);
                    }
                    
                    [_fbRequest release], _fbRequest = nil;
                    [dialog dismiss:YES];
                } cancel:NULL] retain];
            }
        };
        
        dialog.cancelBlock = ^{
            
            if (_fbRequest) {
                [_fbRequest cancel];
                [_fbRequest release], _fbRequest = nil;
            }
            
            if (cancelBlock) {
                cancelBlock();
            }
            
            [dialog dismiss:YES];
        };
        
        [dialog show];
        [dialog release];
    }
}

- (SFFacebookRequest *)publishPostWithoutDialog:(SFSimplePost *)post onPage:(NSString *)pageId success:(SFCreateObjectBlock)successBlock failure:(SFFailureBlock)failureBlock cancel:(SFBasicBlock)cancelBlock
{
    SFFacebookRequest *request = [self facebookRequestWithGraphPath:[NSString stringWithFormat:@"%@/feed", pageId] params:[self paramsForPost:post] httpMethod:@"POST" needsLogin:YES success:^(id result) {
        if (successBlock) {
            successBlock([result objectForKey:@"id"]);
        }
    } failure:failureBlock cancel:cancelBlock];
    
    return request;
}

- (SFFacebookRequest *)facebookRequestWithGraphPath:(NSString *)graphPath needsLogin:(BOOL)needsLogin success:(void (^)(id))successBlock failure:(void (^)(NSError *))failureBlock cancel:(void (^)())cancelBlock
{
    NSLog(@"This is the access token %@", _appAccessToken);
    return [self facebookRequestWithGraphPath:graphPath params:[NSMutableDictionary dictionary] httpMethod:@"GET" needsLogin:needsLogin success:successBlock failure:failureBlock cancel:cancelBlock];
}

- (SFFacebookRequest *)facebookRequestWithGraphPath:(NSString *)graphPath params:(NSMutableDictionary *)params needsLogin:(BOOL)needsLogin success:(void (^)(id))successBlock failure:(void (^)(NSError *))failureBlock cancel:(void (^)())cancelBlock
{
    NSLog(@"This is the access token %@", _appAccessToken);
    return [self facebookRequestWithGraphPath:graphPath params:params httpMethod:@"GET" needsLogin:needsLogin success:successBlock failure:failureBlock cancel:cancelBlock];
}

- (SFFacebookRequest *)facebookRequestWithGraphPath:(NSString *)graphPath params:(NSMutableDictionary *)params httpMethod:(NSString *)httpMethod needsLogin:(BOOL)needsLogin success:(void (^)(id))successBlock failure:(void (^)(NSError *))failureBlock cancel:(void (^)())cancelBlock
{
    NSLog(@"Is this the one? is the access token %@", _appAccessToken);
    if (!needsLogin && _appAccessToken) {
        [params setObject:_appAccessToken forKey:@"access_token"];
    }
    
    return [SFFacebookRequest requestWithFacebook:_facebook graphPath:[graphPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] params:params httpMethod:httpMethod needsLogin:needsLogin success:successBlock failure:failureBlock cancel:cancelBlock];
}

#pragma mark - Private

- (void)saveLoginInfo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[_facebook accessToken] forKey:kSFAccessTokenKey];
    [defaults setObject:[_facebook expirationDate] forKey:kSFExpirationDateKey];
    [defaults synchronize];
    
    SFDLog(@"Access token info saved");
}

- (void)loadLoginInfo
{
    // Retrieve authorization information
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:kSFAccessTokenKey] && [defaults objectForKey:kSFExpirationDateKey]) {
        _facebook.accessToken = [defaults objectForKey:kSFAccessTokenKey];
        _facebook.expirationDate = [defaults objectForKey:kSFExpirationDateKey];
    }
}

- (void)clearLoginInfo
{
    // Remove saved authorization information if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:kSFAccessTokenKey]) {
        [defaults removeObjectForKey:kSFAccessTokenKey];
        [defaults removeObjectForKey:kSFExpirationDateKey];
        [defaults synchronize];
    }
}

/**
 * Helper method to parse URL query parameters
 */
- (NSDictionary *)parseURLParams:(NSString *)query
{
	NSArray *pairs = [query componentsSeparatedByString:@"&"];
	NSMutableDictionary *params = [[[NSMutableDictionary alloc] init] autorelease];
	for (NSString *pair in pairs) {
		NSArray *kv = [pair componentsSeparatedByString:@"="];
		NSString *val = [[kv objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
		[params setObject:val forKey:[kv objectAtIndex:0]];
	}
    return params;
}

- (void)releaseDialogBlocks
{
    [_dialogSuccessBlock release], _dialogSuccessBlock = nil;
    [_dialogFailureBlock release], _dialogFailureBlock = nil;
    [_dialogCancelBlock release], _dialogCancelBlock = nil;
}

- (NSString *)nextPageUrl:(NSDictionary *)paging
{
    NSString *nextPageUrl = nil;
    if (paging) {
        nextPageUrl = [paging objectForKey:@"next"];
        int pos = [nextPageUrl rangeOfString:@".com/"].location + 5;
        nextPageUrl = [nextPageUrl substringFromIndex:pos];
    }
    return nextPageUrl;
}

- (NSMutableDictionary *)paramsForPost:(SFSimplePost *)post
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (post) {
        // The action links to be shown with the post in the feed
        NSString *actionName = [post actionName];
        NSString *actionLink = [post actionLink];
        
        if (actionName && actionLink) {
            [params setObject:[NSString stringWithFormat:@"[{name:\"%@\",link:\"%@\"}]", actionName, actionLink] forKey:@"actions"];
        }
        
        // Dialog parameters
        NSString *value = nil;
        NSArray *to = [post to];
        if ([to count] > 0) {
            value = [((SFSimpleUser *)[to objectAtIndex:0]) objectId];
            if (value) { [params setObject:value forKey:@"to"]; }
        }
        value = [post name];
        if (value) { [params setObject:value forKey:@"name"]; }
        value = [post caption];
        if (value) { [params setObject:value forKey:@"caption"]; }
        value = [post postDescription];
        if (value) { [params setObject:value forKey:@"description"]; }
        value = [post link];
        if (value) { [params setObject:value forKey:@"link"]; }
        value = [post picture];
        if (value) { [params setObject:value forKey:@"picture"]; }
        value = [post source];
        if (value) { [params setObject:value forKey:@"source"]; }
        value = [post message];
        if (value) { [params setObject:value forKey:@"message"]; }
    }
    
    return params;
}

- (NSDate *)dateWithFacebookUnixTimestamp:(NSTimeInterval)unixTimestamp
{
    [_dateFormatter setTimeZone:_facebookTimeZone];
    NSDate *sourceDate = [[NSDate alloc] initWithTimeIntervalSince1970:unixTimestamp];
    NSString *dateString = [_dateFormatter stringFromDate:sourceDate];
    [sourceDate release];
    
    [_dateFormatter setTimeZone:_localTimeZone];
    return [_dateFormatter dateFromString:dateString];
}

- (NSTimeInterval)facebookUnixTimestampFromDate:(NSDate *)date
{
    [_dateFormatter setTimeZone:_localTimeZone];
    NSString *dateString = [_dateFormatter stringFromDate:date];
    
    [_dateFormatter setTimeZone:_facebookTimeZone];
    return [[_dateFormatter dateFromString:dateString] timeIntervalSince1970];
}

- (SFFacebookRequest *)profileFeedWithGraphPath:(NSString *)graphPath needsLogin:(BOOL)needsLogin success:(SFListObjectsBlock)successBlock failure:(SFFailureBlock)failureBlock cancel:(SFBasicBlock)cancelBlock
{
    SFFacebookRequest *request = [self facebookRequestWithGraphPath:graphPath needsLogin:needsLogin success:^(id result) {
        SFSimplePost *post = nil;
        NSMutableArray *posts = [[NSMutableArray alloc] init];
        
        for (id obj in [result objectForKey:@"data"]) {
            post = [[SFSimplePost alloc] init];
            post.objectId = [obj objectForKey:@"id"];
            
            NSDictionary *fromJson = [obj objectForKey:@"from"];
            
            if (fromJson) {
                SFSimpleUser *from = [[SFSimpleUser alloc] init];
                from.objectId = [fromJson objectForKey:@"id"];
                from.name = [fromJson objectForKey:@"name"];
                
                post.from = from;
                [from release];
            }
            
            post.message = [obj objectForKey:@"message"];
            post.picture = [obj objectForKey:@"picture"];
            post.link = [obj objectForKey:@"link"];
            post.name = [obj objectForKey:@"name"];
            post.caption = [obj objectForKey:@"caption"];
            post.postDescription = [obj objectForKey:@"description"];
            post.source = [obj objectForKey:@"source"];
            post.type = [obj objectForKey:@"type"];
            
            post.createdTime = [NSDate dateWithTimeIntervalSince1970:[[obj objectForKey:@"created_time"] doubleValue]];
            post.updatedTime = [NSDate dateWithTimeIntervalSince1970:[[obj objectForKey:@"updated_time"] doubleValue]];
            
            NSDictionary *comments = [obj objectForKey:@"comments"];
            if (comments) {
                post.numberOfComments = [[comments objectForKey:@"count"] intValue];
            }
            
            NSDictionary *likes = [obj objectForKey:@"likes"];
            if (likes) {
                post.numberOfLikes = [[likes objectForKey:@"count"] intValue];
            }
            
            [posts addObject:post];
            [post release];
        }
        
        NSString *nextPage = [self nextPageUrl:[result objectForKey:@"paging"]];
        
        if (successBlock) {
            successBlock(posts, nextPage);
        }
        [posts release];
        
    } failure:failureBlock cancel:cancelBlock];
    
    return request;
}

- (SFFacebookRequest *)commentsFromPostWithGraphPath:(NSString *)graphPath needsLogin:(BOOL)needsLogin success:(SFListObjectsBlock)successBlock failure:(SFFailureBlock)failureBlock cancel:(SFBasicBlock)cancelBlock
{
    SFFacebookRequest *request  = [self facebookRequestWithGraphPath:graphPath needsLogin:needsLogin success:^(id result) {
        
        SFComment *comment;
		NSMutableArray *comments = [[NSMutableArray alloc] init];
		
		for (NSDictionary *commentJson in [result objectForKey:@"data"]) {
			comment = [[SFComment alloc] init];
			comment.objectId = [commentJson objectForKey:@"id"];
            comment.message = [commentJson objectForKey:@"message"];
            comment.createdTime = [NSDate dateWithTimeIntervalSince1970:[[commentJson objectForKey:@"created_time"] doubleValue]];
            comment.numberOfLikes = [[commentJson objectForKey:@"likes"] intValue];
			
            NSDictionary *fromJson = [commentJson objectForKey:@"from"];
            if (fromJson) {
                SFSimpleUser *fromUser = [[SFSimpleUser alloc] init];
                fromUser.objectId = [fromJson objectForKey:@"id"];
                fromUser.name = [fromJson objectForKey:@"name"];
                
                comment.from = fromUser;
                [fromUser release];
            }
            
			[comments addObject:comment];
			[comment release];
		}
		
        NSString *nextPage = [self nextPageUrl:[result objectForKey:@"paging"]];
		
		if (successBlock) {
            successBlock(comments, nextPage);
		}
        [comments release];
        
        
    } failure:failureBlock cancel:cancelBlock];
    
    return request;
}

- (SFFacebookRequest *)usersWhoLikedPostWithGraphPath:(NSString *)graphPath needsLogin:(BOOL)needsLogin success:(SFListObjectsBlock)successBlock failure:(SFFailureBlock)failureBlock cancel:(SFBasicBlock)cancelBlock
{
    SFFacebookRequest *request  = [self facebookRequestWithGraphPath:graphPath needsLogin:needsLogin success:^(id result) {
        
        SFSimpleUser *user;
		NSMutableArray *users = [[NSMutableArray alloc] init];
		
		for (NSDictionary *userJson in [result objectForKey:@"data"]) {
			user = [[SFSimpleUser alloc] init];
			user.objectId = [userJson objectForKey:@"id"];
            user.name = [userJson objectForKey:@"name"];
            
			[users addObject:user];
			[user release];
		}
		
        NSString *nextPage = [self nextPageUrl:[result objectForKey:@"paging"]];
		
		if (successBlock) {
            successBlock(users, nextPage);
		}
        [users release];
        
        
    } failure:failureBlock cancel:cancelBlock];
    
    return request;
}

#pragma mark - Shingle

- (SFURLRequest *)shingleConfigurationWithUrl:(NSString *)url andArea:(NSInteger)area success:(SFShingleBlock)successBlock failure:(SFFailureBlock)failureBlock cancel:(SFBasicBlock)cancelBlock
{
    return [SFURLRequest requestWithURL:[NSString stringWithFormat:@"%@facebook/getFacebook?area_id=%d", url, area] success:^(NSData *receivedData) {
        
        NSString *json = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        id result = [json JSONValue];
        [json release];
        
        NSString *profileId = nil;
        
        if ([result isKindOfClass:[NSArray class]]) {
            profileId = [[result objectAtIndex:0] objectForKey:@"account_number"];
            SFDLog(@"Shingle profileId = %@", profileId);
            
            if (successBlock) {
                successBlock(profileId, NO);
            }
        }
        else if (failureBlock) {
            failureBlock(SFError(@"Could not parse server response"));
        }
        
    } failure:failureBlock cancel:cancelBlock];
}

#pragma mark - FBSessionDelegate methods
/**
 * Called when the user successfully logged in.
 */
- (void)fbDidLogin
{
    SFDLog(@"User logged in");
    [self saveLoginInfo];
    
    if (_loginBlock) {
        _loginBlock();
        [_loginBlock release], _loginBlock = nil;
    }
    
    if (_notLoginBlock) {
        [_notLoginBlock release], _notLoginBlock = nil;
    }

}

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled
{
    SFDLog(@"Did not login. User cancelled: %@", (cancelled? @"YES" : @"NO"));
    
    if (_loginBlock) {
        [_loginBlock release], _loginBlock = nil;
    }
    
    if (_notLoginBlock) {
        _notLoginBlock(cancelled);
        [_notLoginBlock release], _notLoginBlock = nil;
    }
}

/**
 * Called after the access token was extended. If your application has any
 * references to the previous access token (for example, if your application
 * stores the previous access token in persistent storage), your application
 * should overwrite the old access token with the new one in this method.
 * See extendAccessToken for more details.
 */
- (void)fbDidExtendToken:(NSString*)accessToken expiresAt:(NSDate*)expiresAt
{
    SFDLog(@"Access token extended");
    
    [self saveLoginInfo];
}

/**
 * Called when the user logged out.
 */
- (void)fbDidLogout
{
	SFDLog(@"Logout");
    
    [self clearLoginInfo];
    
    if (_logoutBlock) {
        _logoutBlock();
        [_logoutBlock release], _logoutBlock = nil;
    }
}

/**
 * Called when the current session has expired. This might happen when:
 *  - the access token expired 
 *  - the app has been disabled
 *  - the user revoked the app's permissions
 *  - the user changed his or her password
 */
- (void)fbSessionInvalidated
{
    SFDLog(@"Session invalidated");
    
    [self clearLoginInfo];
}

#pragma mark - FBDialogDelegate

/**
 * Called when the dialog succeeds with a returning url.
 */
- (void)dialogCompleteWithUrl:(NSURL *)url
{
    if (![url query]) {
        SFDLog(@"User canceled dialog or there was an error");
        if (_dialogCancelBlock) {
            _dialogCancelBlock();
        }
    } else {
    
        NSDictionary *params = [self parseURLParams:[url query]];
        switch (_currentDialogRequest) {
            case SFDialogRequestPublish:
            {
                NSString *postId = [params valueForKey:@"post_id"];
                // Successful posts return a post_id
                if (postId) {
                    SFDLog(@"Feed post ID: %@", postId);
                    if (_dialogSuccessBlock) {
                        ((SFCreateObjectBlock)_dialogSuccessBlock)(postId);
                    }
                }
                break;
            }
//            case kDialogRequestsSendToMany:
//            case kDialogRequestsSendToSelect:
//            case kDialogRequestsSendToTarget:
//            {
//                // Successful requests return one or more request_ids.
//                // Get any request IDs, will be in the URL in the form
//                // request_ids[0]=1001316103543&request_ids[1]=10100303657380180
//                NSMutableArray *requestIDs = [[NSMutableArray alloc] init];
//                for (NSString *paramKey in params) {
//                    if ([paramKey hasPrefix:@"request_ids"]) {
//                        [requestIDs addObject:[params objectForKey:paramKey]];
//                    }
//                }
//                if ([requestIDs count] > 0) {
//                    [self showMessage:@"Sent request successfully."];
//                    NSLog(@"Request ID(s): %@", requestIDs);
//                }
//                break;
//            }
            default:
                break;
        }
    }
    
    [self releaseDialogBlocks];
}

/**
 * Called when the dialog is cancelled and is about to be dismissed.
 */
- (void)dialogDidNotComplete:(FBDialog *)dialog
{
    SFDLog(@"Dialog dismissed.");
    if (_dialogCancelBlock) {
        _dialogCancelBlock();
    }
    
    [self releaseDialogBlocks];
}

/**
 * Called when dialog failed to load due to an error.
 */
- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error
{
    SFDLog(@"Error message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    if (_dialogFailureBlock) {
        _dialogFailureBlock(error);
    }
    
    [self releaseDialogBlocks];
}

#pragma mark - UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // Quit the app
    exit(1);
}

#pragma mark - Dealloc

- (void) dealloc
{
	[_facebook release];
    [_permissions release];
    [_app release];
    [_appSecret release];
    [_appAccessToken release];
    
    [_loginBlock release];
    [_notLoginBlock release];
    [_logoutBlock release];
    
    [_dialogSuccessBlock release];
    [_dialogFailureBlock release];
    [_dialogCancelBlock release];
    
    [_dateFormatter release];
    [_facebookTimeZone release];
    [_localTimeZone release];
    
    [_fbRequest release];
    
	SFDLog(@"SFSocialFacebook deallocated");
    
	[super dealloc];
}

@end
